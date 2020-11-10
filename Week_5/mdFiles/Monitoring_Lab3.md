# Lab 3. TIG 사용

## 상황

Azure Monitor만 사용해보니 OS의 메모리 사용 현황을 확인할 수 없어서 오픈소스 솔루션 TIG를 사용해본다.

## 기본 조건

- Grafana VM에 Influx DB 설치
- 웹 서버와 애플리케이션 서버에 Telegraf 설치
- Grafana의 데이터 소스는 localhost에 설치된 InfluxDB

## Monitoring Metrics

### 필수 사항

- CPU, Memory, Disk

### Challenge

- Nginx Access Log 등 Log 대시보드 작성