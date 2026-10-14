# Exporters

## node_exporter
Rocky VM 자체 지표:
- CPU
- Memory
- Network
- Filesystem

```bash
curl -s http://10.10.0.2:9100/metrics | head
```

## cAdvisor
Docker Container 지표.

```bash
curl -s http://10.10.0.2:8081/metrics | head
```

Compose service 확인:
```promql
count by (container_label_com_docker_compose_service) (
  container_cpu_usage_seconds_total{instance="10.10.0.2:8081"}
)
```

## nginx-prometheus-exporter
```bash
curl -s http://10.10.0.2:9113/metrics | head
curl -s http://10.10.0.2:9113/metrics | grep '^nginx_' | head
```

주요 지표:
```text
nginx_connections_active
nginx_http_requests_total
```

## 보안
Exporter를 인터넷에 직접 공개하지 않고 WireGuard 경로로 Monitoring VM에서 접근한다.
