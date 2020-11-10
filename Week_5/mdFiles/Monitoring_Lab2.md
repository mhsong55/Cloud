# Lab 2. Grafana 모니터링

## 상황

Azure 모니터 대시보드를 사용해보니 그래픽이나 설정 방법 등 불편한 점이 많아 써드파티 툴인 Grafana를 알게 되었따. Grafana를 사용해 대시보드를 구성하고 경고 알림을 구성햅ㄴ다.

## 기본 조건

- Grafana VM 생성 : 여기까지 진행했을 때 VM 총 3대
- Linux Package Installer로 Grafana 설치
  - [Grafana Installation Document](https://grafana.com/docs/grafana/latest/installation/)
- NSG Flow Log 대시보드

## 대시보드 구성

1. VM Metrics 패널
   - 필수 사항 : CPU, Network, Disk
2. 활동 로그 중 가상 머신 시작/종료 와 관련된 패널
3. NSG Flow Log 대시보드

**Challenge**
- 알림 구성 : Slack 채널에 Metric 임계치 알림이 발송되도록 구성 (Webhook)
- NSG Flow Log 대시보드에서 접속자 IP를 탐색할 수 있도록 텍스트 박스 구성