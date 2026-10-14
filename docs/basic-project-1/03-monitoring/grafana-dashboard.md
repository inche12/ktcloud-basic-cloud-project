# Grafana Dashboard

Dashboard:
```text
Ferrot Rocky On-prem Monitoring
```

## Rocky VM CPU
```promql
100 - (
  avg by(instance)(
    rate(node_cpu_seconds_total{
      instance="10.10.0.2:9100",
      mode="idle"
    }[1m])
  ) * 100
)
```

```text
Unit: Percent (0-100)
Min: 0
Max: 100
Decimals: 1
Threshold: 80 / 90
Legend: Rocky CPU
```

## Rocky Memory
```promql
(
  1 -
  node_memory_MemAvailable_bytes{instance="10.10.0.2:9100"}
  /
  node_memory_MemTotal_bytes{instance="10.10.0.2:9100"}
) * 100
```

```text
Min 0 / Max 100 / Threshold 80, 90
```

## Pretix CPU
```promql
sum(
  rate(container_cpu_usage_seconds_total{
    instance="10.10.0.2:8081",
    container_label_com_docker_compose_service="pretix",
    cpu="total"
  }[1m])
) * 100
```

Pretix 0.5 CPU quota 기준:
```text
Min: 0
Max: 60
Threshold: 50
Legend: Pretix CPU
```

## PostgreSQL CPU
```promql
sum(
  rate(container_cpu_usage_seconds_total{
    instance="10.10.0.2:8081",
    container_label_com_docker_compose_service="db",
    cpu="total"
  }[1m])
) * 100
```

```text
Min: 0
Max: Auto
Threshold: 없음
Legend: PostgreSQL CPU
```

## Redis CPU
```promql
sum(
  rate(container_cpu_usage_seconds_total{
    instance="10.10.0.2:8081",
    container_label_com_docker_compose_service="redis",
    cpu="total"
  }[1m])
) * 100
```

```text
Min: 0
Max: Auto
Threshold: 없음
Legend: Redis CPU
```

## Network RX
```promql
rate(node_network_receive_bytes_total{
  instance="10.10.0.2:9100",
  device="ens160"
}[1m])
```

## Network TX
```promql
rate(node_network_transmit_bytes_total{
  instance="10.10.0.2:9100",
  device="ens160"
}[1m])
```

```text
Unit: bytes/sec IEC
Legend: RX / TX
```

## Nginx Active Connections
```promql
nginx_connections_active{instance="10.10.0.2:9113"}
```

## Nginx Request Rate
```promql
rate(nginx_http_requests_total{
  instance="10.10.0.2:9113"
}[30s])
```

## sum() 의미
```text
cAdvisor의 여러 CPU 시계열
       ↓
rate(...[1m])
최근 1분 CPU 사용 속도
       ↓
sum(...)
서비스 전체 값으로 합침
       ↓
* 100
CPU 사용률 형태
```

Prometheus가 연결된 시점부터만 데이터를 저장하므로 연결 이전 시간대가 비어 있는 것은 정상이다.
