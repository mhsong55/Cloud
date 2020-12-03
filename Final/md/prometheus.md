# Prometheus

> ## Reference
> 1. [Prometheus Docs](https://prometheus.io/docs/introduction/first_steps/)  
> 2. [finda-tech](https://medium.com/finda-tech/prometheus%EB%9E%80-cf52c9a8785f)  
> 3. [조대협님 블로그 | 프로메테우스 #1 기본 개념과 구조](https://bcho.tistory.com/1372)  
> 4. [호롤리한 하루 | Kubernetes Monitoring - Prometheus 실습](https://gruuuuu.github.io/cloud/monitoring-02/#)
> 5. [아리수 | 쿠버네티스 모니터링 : 프로메테우스](https://arisu1000.tistory.com/27857)

Prometheus는 오픈 소스 기반의 모니터링 시스템이다.

**Exporter**  
Exporter는 모니터링 에이전트로 타겟 시스템에서 메트릭을 읽어서, 프로메테우스가 풀링을 할 수 있도록 한다. 재미 있는 점은 Exporter 는 단순히 HTTP GET으로 메트릭을 텍스트 형태로 프로메테우스에 리턴한다. 요청 당시의 데이타를 리턴하는 것일뿐, Exporter 자체는 기존값(히스토리)를 저장하는 등의 기능은 없다. 

출처: https://bcho.tistory.com/1372 [조대협의 블로그]