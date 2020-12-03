1. AKS Cluster 생성
2. `az aks get-credentials`로 credentials 가져오기
3. `az aks update`로 acr attach
4. jekyll blog deployment 및 service 배포

    ```yaml
    apiVersion: app/v1
    kind: Deployment
    metadata:
      name: jekyll-blog-depl
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: jekyll-blog-depl
      strategy:
        rollingUpdate: 
          maxSurge: 1
          maxUnavailable: 1
      minReadySeconds: 5
      template:
        metadata:
          labels:
            app: jekyll-blog-depl
        spec:
          containers:
          - name: jekyll-blog
            image: mhsongacr.azurecr.io/jekyll-blog:v1
            ports:
            - containerPort: 4000
            resources:
              requests:
                cpu: 250m
              limits:
                cpu: 500m
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: jekyll-blog-svc
    spec:
      type: LoadBalancer
      ports:
      - port: 4000
      selector:
        app: jekyll-blog-depl
    ```

5. 외부 접속 테스트
6. Prometheus ( Ref : [호롤리님 blog | Kubernetes Monitoring - Prometheus 실습](https://gruuuuu.github.io/cloud/monitoring-02/#) )

## **Step**

## 1. Prometheuns 배포

### **namespace**

제일 먼저 prometheus 관련 object들이 사용할 namespace 생성

```bash
$ kubectl create ns monitoring
```

### **Cluster Role**

Prometheus Container가 API Server 에 접근할 수 있는 권한을 부여해주기 위해 `ClusterRole`을 설정하고 `ClusterRoleBinding`을 수행한다. 생성된 `ClusterRole`은 `monitoring` namespace의 기본 Service Account와 연동도어 권한을 부여해준다.

```yaml
# prometheus-cluster-role.yaml

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: prometheus
  namespace: monitoring
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: default
  namespace: monitoring
```

### **Configmap**

Prometheus가 기동되려면 환경설정 파일이 필요한데 해당 환경설정 파일을 정의해주는 부분이다. `data` 밑에 `prometheus.rules`와 `prometheus.yml`를 각각 정의하게 되어 있다.

- `prometheus.rules` : 수집한 metrics에 대한 알람 조건을 지정해 특정 조건이 되면 `AlertManager`로 알람을 보낼 수 있음
- `prometheus.yml` : 수집할 metrics의 종류와 수집 주기 등을 기입

```yaml
# prometheus-config-map.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server-conf
  labels:
    name: prometheus-server-conf
  namespace: monitoring
data:
  prometheus.rules: |-
    groups:
    - name: container memory alert
      rules:
      - alert: container memory usage rate is very high( > 55%)
        expr: sum(container_memory_working_set_bytes{pod!="", name=""})/ sum (kube_node_status_allocatable_memory_bytes) * 100 > 55
        for: 1m
        labels:
          severity: fatal
        annotations:
          summary: High Memory Usage on 
          identifier: ""
          description: " Memory Usage: "
    - name: container CPU alert
      rules:
      - alert: container CPU usage rate is very high( > 10%)
        expr: sum (rate (container_cpu_usage_seconds_total{pod!=""}[1m])) / sum (machine_cpu_cores) * 100 > 10
        for: 1m
        labels:
          severity: fatal
        annotations:
          summary: High Cpu Usage
  prometheus.yml: |-
    global:
      scrape_interval: 5s
      evaluation_interval: 5s
    rule_files:
      - /etc/prometheus/prometheus.rules
    alerting:
      alertmanagers:
      - scheme: http
        static_configs:
        - targets:
          - "alertmanager.monitoring.svc:9093"

    scrape_configs:
      - job_name: 'kubernetes-apiservers'

        kubernetes_sd_configs:
        - role: endpoints
        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        relabel_configs:
        - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
          action: keep
          regex: default;kubernetes;https

      - job_name: 'kubernetes-nodes'

        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        kubernetes_sd_configs:
        - role: node

        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
        - target_label: __address__
          replacement: kubernetes.default.svc:443
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          target_label: __metrics_path__
          replacement: /api/v1/nodes/${1}/proxy/metrics


      - job_name: 'kubernetes-pods'

        kubernetes_sd_configs:
        - role: pod

        relabel_configs:
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
          action: replace
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
          target_label: __address__
        - action: labelmap
          regex: __meta_kubernetes_pod_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_pod_name]
          action: replace
          target_label: kubernetes_pod_name

      - job_name: 'kube-state-metrics'
        static_configs:
          - targets: ['kube-state-metrics.kube-system.svc.cluster.local:8080']

      - job_name: 'kubernetes-cadvisor'

        scheme: https

        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

        kubernetes_sd_configs:
        - role: node

        relabel_configs:
        - action: labelmap
          regex: __meta_kubernetes_node_label_(.+)
        - target_label: __address__
          replacement: kubernetes.default.svc:443
        - source_labels: [__meta_kubernetes_node_name]
          regex: (.+)
          target_label: __metrics_path__
          replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor

      - job_name: 'kubernetes-service-endpoints'

        kubernetes_sd_configs:
        - role: endpoints

        relabel_configs:
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
          action: replace
          target_label: __scheme__
          regex: (https?)
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
          action: replace
          target_label: __metrics_path__
          regex: (.+)
        - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
          action: replace
          target_label: __address__
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
        - action: labelmap
          regex: __meta_kubernetes_service_label_(.+)
        - source_labels: [__meta_kubernetes_namespace]
          action: replace
          target_label: kubernetes_namespace
        - source_labels: [__meta_kubernetes_service_name]
          action: replace
          target_label: kubernetes_name
```

## VMSS 기반 - VMSS insance (AKS node) 의 제한

Reference : [MS Docs | AKS의 할당량, 가상 머신 크기 제한 및 지역 가용성](https://docs.microsoft.com/ko-kr/azure/aks/quotas-skus-regions)

기존 VMSS와 동일하게 적용된다.
|리소스|제한|
|:---:|:---:|
|VMSS 및 Basic SKU LB를 사용하는 Cluster 당 최대 node 수|100|
|VMSS 및 Standard SKU LB를 사용하는 Cluster 당 최대 node 수|1000 (Nodepool 당 node 100개)|

<br>

- 100개 이하의 VM은 하나의 Placement Group 안에 배치
- Standard SKU LB의 Back End Pool의  최대 크기가 100개로 제약되기 때문
- Auto-Rolling update가 가능하려면 LoadBalancer가 붙어 있고 Probe 설정이 되어 있어야 한다.