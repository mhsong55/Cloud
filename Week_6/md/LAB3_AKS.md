# LAB 3. AKS

## 1. AKS 배포하기

### 1.1. 기본 사항

![aks-cluster-create-basic](./img/aks_cluster_create_basic.PNG)

- Kubernetes 버전 : 클러스터 생성 후 이 버전을 업그레이드할 수 있음.
- 노드 크기 : 클러스터의 노드를 형성하는 가상 컴퓨터의 크기
  - 클러스터를 만든 후 변경할 수 없음
- 노드 개수 : 클러스터와 함께 만들어야하는 노드 수
  - 나중에 클러스터 크기 조정 가능

### 1.2. 노드 풀

![aks-cluster-create-nodepool](./img/aks_cluster_create_nodepool.PNG)

### 1.3. 인증

### 1.3.1. 내 서비스 사용자 구성

- `Azure Active Directory`에서 기존 항목의 값을 가져온다.
  - `Azure AD`의 앱(`_AKS-test-intern`)의 Client ID, Password 가져옴
    
### 1.3.2. 인증부 구성 설정 완료 화면
  
  ![aks-cluster-create-auth-complete](./img/aks_cluster_create_auth_complete.PNG)

### 1.4. 네트워킹

![aks-cluster-create-networking](./img/aks_cluster_create_networking.PNG)

### 1.4.1. 가상 네트워크 새로 만들기

![aks-cluster-create-networking-newVNET](./img/aks_cluster_create_networking_newVNET.PNG)

### 1.5. 통합

![aks-cluster-create-integration](./img/aks_cluster_create_integration.PNG)

## 2. Azure Container Registry 배포하기

ACR은 Container image를 위한 Private Registry이다.

### 2.1. 기본 사항

![aks-acr-create-basic](./img/aks_ACR_create_basic.PNG)

- SKU 조사 필요

## 3. VM 세팅

### 3.1. Docker 설치

  > Docker의 경우 `LAB 1. Docker` 를 진행하면서 설치한 것으로 갈음한다.

### 3.2. Docker-compose 설치

> Reference : [[Docker Docs] Install Docker Compose](https://docs.docker.com/compose/install/)

```bash
[mhsong@dockerVM2 ~]$ sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

|%|Total|%|Received|%|Xferd|Average|Speed|Time|Time|Time|Current|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|||||||Dload|Upload|Total|Spent|Left|Speed|
|100|651|100|651|0|0|21700|0| --:--:-- | --:--:-- | --:--:-- |21700|
|100|11.6M|100|11.6M|0|0|4378k|0|0:00:02|0:00:02|--:--:--|5249k|

- `docker-compose` command 권한 설정

  ```bash
  [mhsong@dockerVM2 ~]$ sudo chmod +x /usr/local/bin/docker-compose
  ```

- 설치 확인

  ```bash
  [mhsong@dockerVM2 ~]$ docker-compose version

  docker-compose version 1.27.4, build 40524192
  docker-py version: 4.3.1
  CPython version: 3.7.7
  OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
  ```

### 3.3. Azure CLI 설치 

> Reference : [[Microsoft Docs] Install Azure CLI](https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli)

### 3.3.1. Import the Microsoft repository key

```bash
[mhsong@dockerVM2 ~]$ sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

### 3.3.2. Create local `azure-cli` repository information

```bash
[mhsong@dockerVM2 ~]$ sudo sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
```

### 3.3.3. Install with the `yum install` command

```bash
[mhsong@dockerVM2 ~]$ sudo yum install azure-cli
```

### 3.3.4. `az` command를 사용해 `kubectl`을 VM에 설치

```bash
[mhsong@dockerVM2 ~]$ sudo az aks install-cli
```

### 3.4. Azure 계정에 login

### 3.4.1. Run the Azure CLI with the `az` command. To sign in, use `az login` command.

Run the `login` command

```bash
[mhsong@dockerVM2 ~]$ az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code HSAJTALS7 to authenticate.
```

해당 web page로 접속해 code를 입력하고 login을 수행한 후, Browser 창을 닫는다.

![aks-az-login-web-complete](./img/aks_az_login_web_complete.PNG)

- 사용할 구독 지정

```bash
[mhsong@dockerVM2 ~]$ az account set --subscription 
[mhsong@dockerVM2 ~]$ az account show
[mhsong@dockerVM2 ~]$ az account list
```

## 3.5. 생성한 AKS Cluster에 연결

자격 증명을 다운로드하고 Kubernetes CLI가 다운받은 자격 증명을 사용하도록 구성한다.

```bash
[mhsong@dockerVM2 ~]$ az aks get-credentials -n AKS-RG-Cluster-mh -g AKS-RG

Merged "AKS-RG-Cluster-mh" as current context in /home/mhsong/.kube/config

[mhsong@dockerVM2 ~]$ cd .kube/
[mhsong@dockerVM2 .kube]$ ll

total 12
-rw-------. 1 mhsong mhsong 9558 Nov 11 05:58 config
```

AKS Cluster와의 연결을 확인하려면 `kubectl get nodes` command를 입력한다.

```bash
[mhsong@dockerVM2 ~]$ kubectl get nodes
NAME                                STATUS   ROLES   AGE    VERSION
aks-agentpool-25963097-vmss000000   Ready    agent   4h1m   v1.18.10
aks-agentpool-25963097-vmss000001   Ready    agent   4h1m   v1.18.10
```


여기까지 진행하면 해당 Linux VM에서 AKS를 사용할 준비가 완료된다.

## 4. AKS LAB을 위한 애플리케이션 준비

AKS LAB을 진행할 Directory인 `kube_workshop`를 생성한다.

```bash
[mhsong@dockerVM2 .kube]$ cd ~
[mhsong@dockerVM2 ~]$ mkdir kube_workshop
[mhsong@dockerVM2 ~]$ cd kube_workshop/
[mhsong@dockerVM2 kube_workshop]$ pwd

/home/mhsong/kube_workshop
```

### 4.1. Git 설치

LAB 진행에 필요한 Sample file을 github에서 다운로드 하기 전에 git을 설치한다.

```bash
[mhsong@dockerVM2 kube_workshop]$ sudo yum -y install git
```

### 4.2. Sample File Cloning

AKS LAB 진행에 필요한 Web application code를 clone한다.

```bash
[mhsong@dockerVM2 kube_workshop]$ git clone https://github.com/Azure-Samples/azure-voting-app-redis.git

[mhsong@dockerVM2 kube_workshop]$ ll

total 0
drwxrwxr-x. 5 mhsong mhsong 177 Nov 11 06:04 azure-voting-app-redis

[mhsong@dockerVM2 kube_workshop]$ cd azure-voting-app-redis/
[mhsong@dockerVM2 azure-voting-app-redis]$ ll
total 16
drwxrwxr-x. 3 mhsong mhsong  128 Nov 11 06:04 azure-vote
-rw-rw-r--. 1 mhsong mhsong 1532 Nov 11 06:04 azure-vote-all-in-one-redis.yaml
-rw-rw-r--. 1 mhsong mhsong  433 Nov 11 06:04 docker-compose.yaml
drwxrwxr-x. 2 mhsong mhsong   59 Nov 11 06:04 jenkins-tutorial
-rw-rw-r--. 1 mhsong mhsong 1162 Nov 11 06:04 LICENSE
-rw-rw-r--. 1 mhsong mhsong 1806 Nov 11 06:04 README.md

[mhsong@dockerVM2 azure-voting-app-redis]$ cat docker-compose.yaml
```

```yaml
version: '3'
services:
  azure-vote-back:
    image: mcr.microsoft.com/oss/bitnami/redis:6.0.8
    container_name: azure-vote-back
    environment:
      ALLOW_EMPTY_PASSWORD: "yes"
    ports:
        - "6379:6379"

  azure-vote-front:
    build: ./azure-vote
    image: mcr.microsoft.com/azuredocs/azure-vote-front:v1
    container_name: azure-vote-front
    environment:
      REDIS: azure-vote-back
    ports:
        - "8080:80"
```

### 4.3. Container 생성 및 실행

다운로드 받은 docker-compose.yaml 파일로 Container를 생성하고 실행한다. 생성되는 Container는 `azure-vote-back`과 `azure-vote-front` 두 개이다.

- `docker-compose up -d`
  - `up` option : Container 생성 및 실행
  - `-d` flag : detach mode - Run containers in the background

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker-compose up -d

WARNING: The Docker Engine you're using is running in swarm mode.

Compose does not use swarm mode to deploy services to multiple nodes in a swarm. All containers will be scheduled on the current node.

To deploy your application across the swarm, use `docker stack deploy`.

Creating network "azure-voting-app-redis_default" with the default driver
Pulling azure-vote-back (mcr.microsoft.com/oss/bitnami/redis:6.0.8)...
6.0.8: Pulling from oss/bitnami/redis
58212c1109c5: Pull complete
476959f86aed: Pull complete
e9439c5c5ef5: Pull complete
bf887c7f6b15: Pull complete
4e934f6d99d2: Pull complete
e33ec5243c54: Pull complete
9f99ff6b922f: Pull complete
097294963657: Pull complete
919efe137172: Pull complete
b3346fcea345: Pull complete
3bb7743413aa: Pull complete
Digest: sha256:9b53ae0f1cf3f7d7854584c8b7c5a96fe732c48d504331da6c00f892fdcce102
Status: Downloaded newer image for mcr.microsoft.com/oss/bitnami/redis:6.0.8
Building azure-vote-front
Step 1/3 : FROM tiangolo/uwsgi-nginx-flask:python3.6
python3.6: Pulling from tiangolo/uwsgi-nginx-flask
90fe46dd8199: Pull complete
35a4f1977689: Pull complete
bbc37f14aded: Pull complete
74e27dc593d4: Pull complete
4352dcff7819: Pull complete
1847e662e737: Pull complete
11d40aa4a4d0: Pull complete
423a225c2f8b: Pull complete
730abf0e8db7: Pull complete
2f2c1f99caec: Pull complete
117b2bb6b9f5: Pull complete
24cf85cbbf19: Pull complete
e5b1d4c157be: Pull complete
41ed8631c488: Pull complete
4cea017a23a1: Pull complete
634fcb400bb1: Pull complete
751c69d0afb6: Pull complete
d5a08367e03a: Pull complete
d9cd7fb23581: Pull complete
f81f7e2c0189: Pull complete
cd58b8e863a0: Pull complete
509a744cedbf: Pull complete
fa7e0b384c56: Pull complete
5e741e7fd668: Pull complete
ba3119aded00: Pull complete
4ff97eb414d1: Pull complete
Digest: sha256:806a54891bddfe2ffacaa224550ab93b38402e497b6bc96870f8af752c744c6d
Status: Downloaded newer image for tiangolo/uwsgi-nginx-flask:python3.6
 ---> a16ce562e863
Step 2/3 : RUN pip install redis
 ---> Running in 0fe2ac5cf8ff
Collecting redis
  Downloading redis-3.5.3-py2.py3-none-any.whl (72 kB)
Installing collected packages: redis
Successfully installed redis-3.5.3
WARNING: You are using pip version 20.1; however, version 20.2.4 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
Removing intermediate container 0fe2ac5cf8ff
 ---> aad93c6b320d
Step 3/3 : ADD /azure-vote /app
 ---> a954e44b7ccd

Successfully built a954e44b7ccd
Successfully tagged mcr.microsoft.com/azuredocs/azure-vote-front:v1
WARNING: Image for service azure-vote-front was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating azure-vote-back  ... done
Creating azure-vote-front ... done
```

`docker ps` command로 현재 동작 중인 Container를 확인한다.

```bash
[mhsong@dockerVM1 azure-voting-app-redis]$ docker ps
CONTAINER ID        IMAGE                                             COMMAND                  CREATED             STATUS              PORTS                           NAMES
b4390bdd1fa4        mcr.microsoft.com/azuredocs/azure-vote-front:v1   "/entrypoint.sh /sta…"   4 minutes ago       Up 4 minutes        443/tcp, 0.0.0.0:8080->80/tcp   azure-vote-front
89da436945f6        mcr.microsoft.com/oss/bitnami/redis:6.0.8         "/opt/bitnami/script…"   4 minutes ago       Up 4 minutes        0.0.0.0:6379->6379/tcp          azure-vote-back
```

Web application이 잘 작동하고 있는지를 `curl` command로 확인할 수 있다.

```bash
[mhsong@dockerVM1 azure-voting-app-redis]$ curl localhost:8080
```

```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link rel="stylesheet" type="text/css" href="/static/default.css">
    <title>Azure Voting App</title>

    <script language="JavaScript">
        function send(form){
        }
    </script>

</head>
<body>
    <div id="container">
        <form id="form" name="form" action="/"" method="post"><center>
        <div id="logo">Azure Voting App</div>
        <div id="space"></div>
        <div id="form">
        <button name="vote" value="Cats" onclick="send()" class="button button1">Cats</button>
        <button name="vote" value="Dogs" onclick="send()" class="button button2">Dogs</button>
        <button name="vote" value="reset" onclick="send()" class="button button3">Reset</button>
        <div id="space"></div>
        <div id="space"></div>
        <div id="results"> Cats - 0 | Dogs - 0 </div>
        </form>
        </div>
    </div>
</body>
</html>
```

`docker-compose down` : Stop and remove containers, networks, images, and volumes

- Container instance, resource 중지 및 제거

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker-compose down
Stopping azure-vote-front ... done
Stopping azure-vote-back  ... done
Removing azure-vote-front ... done
Removing azure-vote-back  ... done
Removing network azure-voting-app-redis_default
```

## 5. Azure Container Registry 사용

docker hub 대신 Azure Container Registry에 docker image를 push해두고 pull해서 사용해본다. 이를 위해서는 기존에 docker hub에 login한 계정을 log out하고 Azure Container Registry로 login해야 한다.

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker logout
Removing login credentials for https://index.docker.io/v1/
```

Azure Container Registry에 login하기 위해서는 ACR의 접근 정보가 필요하다. 이를 위해서는 먼저 Azure Portal에서 접속하려는 Container Registry resource에 접근해 `액세스 키`에서 관리 사용자 사용 옵션을 활성화시켜야 한다.

![aks-acr-login-info](./img/aks_ACR_login_info.PNG)

### 5.1. ACR login

`docker login <ACR-LoginServer>`으로 docker에서 ACR에 접근한다. `Username`은 사용자 이름, `Password`는 두 개의 password 중 하나를 입력한다.

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker login mhsongacr.azurecr.io
Username: smhaksdev
Password:
WARNING! Your password will be stored unencrypted in /home/mhsong/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

### 5.2. Image push to ACR

`docker images` command로 push 할 docker image를 확인한다.

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker images
REPOSITORY                                     TAG                 IMAGE ID            CREATED             SIZE
mcr.microsoft.com/azuredocs/azure-vote-front   v1                  a954e44b7ccd        19 minutes ago      944MB
mhsong55/node-host                             v0.1                9cf0a56946a3        24 hours ago        918MB
nginx                                          latest              c39a868aad02        5 days ago          133MB
node                                           12                  1f560ce4ce7e        4 weeks ago         918MB
mcr.microsoft.com/oss/bitnami/redis            6.0.8               3a54a920bb6c        6 weeks ago         103MB
tiangolo/uwsgi-nginx-flask                     python3.6           a16ce562e863        2 months ago        944MB
```

ACR에 image를 push한다.

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker push mcr.microsoft.com/azuredocs/azure-vote-front:v1
The push refers to repository [mcr.microsoft.com/azuredocs/azure-vote-front]
811fb563ec87: Preparing
e6c5ec3a8fb0: Preparing
1971b933c82a: Preparing
596464cb926b: Preparing
07289a4a4d58: Preparing
4249ef06ae69: Waiting
e775b278161a: Waiting
27d9a6169c9f: Waiting
b9557a3d31d9: Waiting
c8f52965417f: Waiting
9cde96ca61c2: Waiting
f3fd11fd6d6c: Waiting
e553743c668b: Waiting
88af765ea71f: Waiting
b47c358499df: Waiting
cbd550635f44: Waiting
2efef025159b: Waiting
3acbf6947195: Waiting
f90fe4978ca2: Waiting
88383b8e3cb5: Waiting
e93627dfc607: Waiting
8f23b00cc77f: Waiting
cf691a2ea3f9: Waiting
3d3e92e98337: Waiting
8967306e673e: Waiting
9794a3b3ed45: Waiting
5f77a51ade6a: Waiting
e40d297cf5f8: Waiting
error parsing HTTP 403 response body: invalid character '<' looking for beginning of value: "<html>\r\n<head><title>403 Forbidden</title></head>\r\n<body bgcolor=\"white\">\r\n<center><h1>403 Forbidden</h1></center>\r\n<hr><center>openresty</center>\r\n</body>\r\n</html>\r\n"
```

위 push 명령은 `mcr.microsoft.com/azuredocs/azure-vote-front` repository에 push를 진행한다. 당연히 권한이 없어 에러가 발생한다. ACR Repository에 push하려면 `tag` command를 사용해 image tag를 변경해 repository를 바꿔준다.


```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 \
> mhsongacr.azurecr.io/azure-vote-front:v1
[mhsong@dockerVM2 azure-voting-app-redis]$ docker images
REPOSITORY                                     TAG                 IMAGE ID            CREATED             SIZE
mhsongacr.azurecr.io/azure-vote-front          v1                  caa7e4b21925        26 minutes ago      944MB
mcr.microsoft.com/azuredocs/azure-vote-front   v1                  caa7e4b21925        26 minutes ago      944MB
mcr.microsoft.com/oss/bitnami/redis            6.0.8               3a54a920bb6c        6 weeks ago         103MB
tiangolo/uwsgi-nginx-flask                     python3.6           a16ce562e863        2 months ago        944MB
```

이미지의 버전을 붙이지 않으면 버전이 `latest`로 지정된다. tag 변경이 성공한다면, 변경한 tag로 image push를 진행한다.

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ docker push mhsongacr.azurecr.io/azure-vote-front:v1
The push refers to repository [mhsongacr.azurecr.io/azure-vote-front]
2d1cbdc60024: Pushed
dfd08aff725d: Pushed
1971b933c82a: Pushed
596464cb926b: Pushed
07289a4a4d58: Pushed
4249ef06ae69: Pushed
e775b278161a: Pushed
27d9a6169c9f: Pushed
b9557a3d31d9: Pushed
c8f52965417f: Pushed
9cde96ca61c2: Pushed
f3fd11fd6d6c: Pushed
e553743c668b: Pushed
88af765ea71f: Pushed
b47c358499df: Pushed
cbd550635f44: Pushed
2efef025159b: Pushed
3acbf6947195: Pushed
f90fe4978ca2: Pushed
88383b8e3cb5: Pushed
e93627dfc607: Pushed
8f23b00cc77f: Pushed
cf691a2ea3f9: Pushed
3d3e92e98337: Pushed
8967306e673e: Pushed
9794a3b3ed45: Pushed
5f77a51ade6a: Pushed
e40d297cf5f8: Pushed
v1: digest: sha256:5c9c02ac72bb055ac10b7e9d2d03da468b9efda5eb57b587b120f6674f1e5e4e size: 6175
```

push 완료 후 Azure portal에서 push 결과를 확인할 수 있다.

![aks-acr-push-result](./img/aks_ACR_push_result.PNG)

## 6. Application 실행

### 6.1. AKS credential update

push한 ACR Image를 사용하기 전에 aks에 ACR 인증 정보를 update한다.

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ history | grep "az aks"
  166  az aks install-cli
  167  sudo az aks install-cli
  172  az aks get-credentials -n AKS-RG-Cluster-mh -g AKS-RG
  200  history | grep "az aks"
[mhsong@dockerVM2 azure-voting-app-redis]$ az aks update -n AKS-RG-Cluster-mh -g AKS-RG --attach-acr mhsongacr
```

```json
{- Finished ..
  "aadProfile": null,
  "addonProfiles": {
    "KubeDashboard": {
      "config": null,
      "enabled": false,
      "identity": null
    },
    "azurePolicy": {
      "config": null,
      "enabled": false,
      "identity": null
    },
    "httpApplicationRouting": {
      "config": null,
      "enabled": false,
      "identity": null
    }
  },
  "agentPoolProfiles": [
    {
      "availabilityZones": null,
      "count": 2,
      "enableAutoScaling": null,
      "enableNodePublicIp": null,
      "maxCount": null,
      "maxPods": 110,
      "minCount": null,
      "mode": "System",
      "name": "agentpool",
      "nodeImageVersion": "AKSUbuntu-1804-2020.10.28",
      "nodeLabels": {},
      "nodeTaints": null,
      "orchestratorVersion": "1.18.10",
      "osDiskSizeGb": 128,
      "osDiskType": "Managed",
      "osType": "Linux",
      "powerState": {
        "code": "Running"
      },
      "provisioningState": "Succeeded",
      "proximityPlacementGroupId": null,
      "scaleSetEvictionPolicy": null,
      "scaleSetPriority": null,
      "spotMaxPrice": null,
      "tags": null,
      "type": "VirtualMachineScaleSets",
      "upgradeSettings": null,
      "vmSize": "Standard_B2s",
      "vnetSubnetId": "/subscriptions/917428f7-be1f-4e78-898e-bf25497ced6a/resourceGroups/AKS-RG/providers/Microsoft.Network/virtualNetworks/AKS-RG-vnet/subnets/default"
    }
  ],
  "apiServerAccessProfile": {
    "authorizedIpRanges": null,
    "enablePrivateCluster": false
  },
  "autoScalerProfile": null,
  "diskEncryptionSetId": null,
  "dnsPrefix": "AKS-RG-Cluster-mh-dns",
  "enablePodSecurityPolicy": null,
  "enableRbac": true,
  "fqdn": "aks-rg-cluster-mh-dns-fa3fe715.hcp.koreacentral.azmk8s.io",
  "identity": null,
  "identityProfile": null,
  "kubernetesVersion": "1.18.10",
  "linuxProfile": null,
  "location": "koreacentral",
  "maxAgentPools": 10,
  "name": "AKS-RG-Cluster-mh",
  "networkProfile": {
    "dnsServiceIp": "100.0.0.10",
    "dockerBridgeCidr": "172.17.0.1/16",
    "loadBalancerProfile": {
      "allocatedOutboundPorts": null,
      "effectiveOutboundIps": [
        {
          "resourceGroup": "MC_AKS-RG_AKS-RG-Cluster-mh_koreacentral"
        }
      ],
      "idleTimeoutInMinutes": null,
      "managedOutboundIps": {
        "count": 1
      },
      "outboundIpPrefixes": null,
      "outboundIps": null
    },
    "loadBalancerSku": "Standard",
    "networkMode": null,
    "networkPlugin": "azure",
    "networkPolicy": null,
    "outboundType": "loadBalancer",
    "podCidr": null,
    "serviceCidr": "100.0.0.0/16"
  },
  "nodeResourceGroup": "MC_AKS-RG_AKS-RG-Cluster-mh_koreacentral",
  "powerState": {
    "code": "Running"
  },
  "privateFqdn": null,
  "provisioningState": "Succeeded",
  "resourceGroup": "AKS-RG",
  "servicePrincipalProfile": {
    "clientId": "c1ddebba-4665-4cdc-9b3e-41030166dd9d",
    "secret": null
  },
  "sku": {
    "name": "Basic",
    "tier": "Free"
  },
  "tags": null,
  "type": "Microsoft.ContainerService/ManagedClusters",
  "windowsProfile": {
    "adminPassword": null,
    "adminUsername": "azureuser",
    "licenseType": null
  }
}
```

### 6.2. 매니페스트 파일 업데이트

컨테이너를 실행하기 전에 ACR에 업데이트한 image를 pulling하는 것으로 매니페스트 파일을 수정한다. 

```yaml
containers:
- name: azure-vote-front
  image: mcr.microsoft.com/azuredocs/azure-vote-front:v1
```

```yaml
containers:
- name: azure-vote-front
  image: <arcName>.azurecr.io/azure-vote-front:v1
```

![aks-manifest-revise](./img/aks_manifest_revise.PNG)

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ ls
azure-vote  azure-vote-all-in-one-redis.yaml  docker-compose.yaml  jenkins-tutorial  LICENSE  README.md
[mhsong@dockerVM2 azure-voting-app-redis]$ vim azure-vote-all-in-one-redis.yaml
```

### 6.3. Application 배포

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ kubectl apply -f azure-vote-all-in-one-redis.yaml

deployment.apps/azure-vote-back created
service/azure-vote-back created
deployment.apps/azure-vote-front created
service/azure-vote-front created
```

해당 yaml 파일에는 deployment 뿐 아니라 외부에 각 deployment를 노출시키는 service 생성에 대한 내용도 포함되어 있다. `kubectl get services` command로 service가 생성되었는지 확인할 수 있다. 

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ kubectl get services
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
azure-vote-back    ClusterIP      100.0.157.127   <none>         6379/TCP       6s
azure-vote-front   LoadBalancer   100.0.208.189   20.196.138.8   80:30836/TCP   6s
kubernetes         ClusterIP      100.0.0.1       <none>         443/TCP        79m
```

`LoadBalancer` type service가 생성돼 자동으로 Azure ELB가 AKS와 연결되고 External IP를 할당한다. 해당 External IP로 web에서 접근할 수 있다.

![aks-webapplication-deploy-result](./img/aks_webApplication_deploy_result.PNG)

```bash
[mhsong@dockerVM2 azure-voting-app-redis]$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
azure-vote-back-859c8848cb-k5g4n    1/1     Running   0          85s
azure-vote-front-64f7c8b79f-z8w69   1/1     Running   0          85s
[mhsong@dockerVM2 azure-voting-app-redis]$ cd ..
[mhsong@dockerVM2 kube_workshop]$ ls

apiVersion: apps/v1
azure-voting-app-redis
[mhsong@dockerVM2 kube_workshop]$ vim busybox.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - image: busybox:1.28
    name: busybox
    command: ["sleep","10000"]
```

```bash
[mhsong@dockerVM2 kube_workshop]$ kubectl apply -f busybox.yaml
pod/busybox created

[mhsong@dockerVM2 kube_workshop]$ kubectl get pod

NAME                                READY   STATUS    RESTARTS   AGE
azure-vote-back-859c8848cb-k5g4n    1/1     Running   0          13m
azure-vote-front-64f7c8b79f-z8w69   1/1     Running   0          13m
busybox                             1/1     Running   0          12s

[mhsong@dockerVM2 kube_workshop]$ kubectl exec busybox -- pwd
/

[mhsong@dockerVM2 kube_workshop]$ kubectl exec busybox -- ls
bin
dev
etc
home
proc
root
sys
tmp
usr
var
```

## 7. `LAB 2. Kubernetes` 에서 배포했던 nginx 서버 AKS에서 배포하기

### 7.1. Manifest 파일 생성

```bash
[mhsong@dockerVM2 kube_workshop]$ vim nginx-deploy.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-deploy
  template:
    metadata:
      name: nginx-deploy-pods
      labels:
        app: nginx-deploy
    spec:
      containers:
      - image: nginx:alpine
        name: nginx-container
```

### 7.2. nginx-deploy 배포

```bash
[mhsong@dockerVM2 kube_workshop]$ kubectl apply -f nginx-deploy.yaml
deployment.apps/nginx-deploy created

[mhsong@dockerVM2 kube_workshop]$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
azure-vote-back-859c8848cb-k5g4n    1/1     Running   0          19m
azure-vote-front-64f7c8b79f-z8w69   1/1     Running   0          19m
busybox                             1/1     Running   0          6m26s
nginx-deploy-765c877b49-c2dhv       1/1     Running   0          107s
nginx-deploy-765c877b49-xtxjk       1/1     Running   0          107s
nginx-deploy-765c877b49-xv6wt       1/1     Running   0          107s

[mhsong@dockerVM1 kube_workshop]$ kubectl get pods --show-labels
NAME                                READY   STATUS    RESTARTS   AGE     LABELS
azure-vote-back-859c8848cb-k5g4n    1/1     Running   0          19m     app=azure-vote-back,pod-template-hash=859c8848cb
azure-vote-front-64f7c8b79f-z8w69   1/1     Running   0          19m     app=azure-vote-front,pod-template-hash=64f7c8b79f
busybox                             1/1     Running   0          6m32s   <none>
nginx-deploy-765c877b49-c2dhv       1/1     Running   0          113s    app=nginx-deploy,pod-template-hash=765c877b49
nginx-deploy-765c877b49-xtxjk       1/1     Running   0          113s    app=nginx-deploy,pod-template-hash=765c877b49
nginx-deploy-765c877b49-xv6wt       1/1     Running   0          113s    app=nginx-deploy,pod-template-hash=765c877b49

[mhsong@dockerVM1 kube_workshop]$ kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE     IP             NODE                                NOMINATED NODE   READINESS GATES
azure-vote-back-859c8848cb-k5g4n    1/1     Running   0          20m     10.240.0.133   aks-agentpool-10165640-vmss000001   <none>           <none>
azure-vote-front-64f7c8b79f-z8w69   1/1     Running   0          20m     10.240.0.47    aks-agentpool-10165640-vmss000000   <none>           <none>
busybox                             1/1     Running   0          6m52s   10.240.0.143   aks-agentpool-10165640-vmss000001   <none>           <none>
nginx-deploy-765c877b49-c2dhv       1/1     Running   0          2m13s   10.240.0.119   aks-agentpool-10165640-vmss000001   <none>           <none>
nginx-deploy-765c877b49-xtxjk       1/1     Running   0          2m13s   10.240.0.12    aks-agentpool-10165640-vmss000000   <none>           <none>
nginx-deploy-765c877b49-xv6wt       1/1     Running   0          2m13s   10.240.0.32    aks-agentpool-10165640-vmss000000   <none>           <none>
```

### 7.3. LoadBalancer type service를 생성

배포한 Container를 외부에서 접속할 수 있게 service를 생성한다.

```bash
[mhsong@dockerVM1 kube_workshop]$ vim nginx-deploy-service.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-deploy-svc
spec:
  type: LoadBalancer
  selector:
    app: nginx-deploy
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

```bash
[mhsong@dockerVM1 kube_workshop]$ [mhsong@dockerVM1 kube_workshop]$ kubectl apply -f nginx-deploy-service.yaml
service/nginx-deploy-svc created

[mhsong@dockerVM2 azure-voting-app-redis]$ kubectl get services
NAME               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)        AGE
azure-vote-back    ClusterIP      100.0.21.89    <none>           6379/TCP       65m
azure-vote-front   LoadBalancer   100.0.20.240   20.196.137.106   80:31967/TCP   65m
kubernetes         ClusterIP      100.0.0.1      <none>           443/TCP        5h38m
nginx-deploy-svc   LoadBalancer   100.0.97.248   20.39.190.99     80:31482/TCP   16m
```

![aks-nginx-deploy-result](./img/aks_nginx_deploy_result.PNG)