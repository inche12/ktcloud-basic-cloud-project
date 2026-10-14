# Progress

## 완료
- Rocky Docker Compose
- Nginx / Pretix / PostgreSQL / Redis
- node_exporter
- cAdvisor
- nginx-prometheus-exporter
- Monitoring VM
- Prometheus
- Grafana
- WireGuard
- Rocky 원격 exporter scrape
- Grafana Dashboard

## 현재 확인한 연결
```text
Monitoring 10.10.0.3
   |
   | WireGuard Handshake
   v
AWS WG 10.10.0.1
   |
   v
Rocky 10.10.0.2
```

확인 완료:
```text
ping 10.10.0.1  성공
ping 10.10.0.2  성공
:9100 metrics    성공
:8081 metrics    성공
:9113 metrics    성공
```

## 다음
1. k6 Baseline
2. 한계 구간 선정
3. Kubernetes
4. HPA
5. AWS Burst
6. 동일 조건 재테스트
