# Personal App/Data Split Lab

## VM
```text
App VM        192.168.120.152
Data VM       192.168.120.153
Monitoring VM 192.168.120.154
```

## App
- Nginx
- Pretix
- node_exporter
- cAdvisor

## Data
- PostgreSQL
- Redis
- node_exporter
- cAdvisor

## Monitoring
- Prometheus
- Grafana
- WireGuard Client

개인 실습 환경은 All-in-One과 App/Data 분리 방식의 차이를 확인하는 용도로 유지한다.

향후 Kubernetes 적용 시 App 계층부터 K8s로 대체하고 Data 계층은 우선 유지할 수 있다.
