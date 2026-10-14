# Troubleshooting

## Prometheus YAML 오류
증상:
```text
did not find expected key
```

검사:
```bash
docker run --rm   --entrypoint /bin/promtool   -v "$PWD/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro"   prom/prometheus   check config /etc/prometheus/prometheus.yml
```

## Prometheus 수정이 반영되지 않음
필요 시:
```bash
docker compose up -d --force-recreate prometheus
```

## cAdvisor 8080/8081 혼동
최종:
```yaml
ports:
  - "8081:8080"
```

Prometheus/Grafana는 `10.10.0.2:8081` 사용.

## node_exporter Restarting
```bash
docker logs --tail=100 node-exporter
curl -s http://localhost:9100/metrics | head
```

## WireGuard Handshake 없음
증상:
```text
0 B received
latest handshake 없음
```

점검:
- AWS Peer 등록
- AWS WG PublicKey
- UDP 51820
- AllowedIPs

## AWS는 ping 되지만 Rocky가 안 됨
```bash
ping -c 3 10.10.0.1
ping -c 3 10.10.0.2
```

`.1 성공 / .2 실패`면:
- AWS forwarding
- Rocky WG
- Rocky firewall
- AllowedIPs

## Ping은 되지만 exporter 실패
```bash
curl -s http://10.10.0.2:9100/metrics | head
curl -s http://10.10.0.2:8081/metrics | head
curl -s http://10.10.0.2:9113/metrics | head
```

점검:
- Container 상태
- Docker Port Mapping
- Listen Address
- Firewall

## Grafana No Data
Prometheus Target이 UP인데 특정 패널만 No Data면 label을 확인한다.

```promql
count by (container_label_com_docker_compose_service) (
  container_cpu_usage_seconds_total{instance="10.10.0.2:8081"}
)
```

실제 확인:
```text
pretix
db
redis
nginx
```

## Legend가 너무 김
Grafana Query Options → Legend:
```text
Pretix CPU
PostgreSQL CPU
Redis CPU
```

## PrivateKey
WireGuard PrivateKey는 GitHub/캡처/채팅에 올리지 않는다. 노출된 키는 교체한다.
