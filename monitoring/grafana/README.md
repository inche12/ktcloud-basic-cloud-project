# Grafana Dashboard Notes

현재 Dashboard: `Pretix On-prem Monitoring`

## 1. APP VM CPU Usage

```promql
100 - (
  avg by(instance) (
    rate(node_cpu_seconds_total{instance="192.168.120.152:9100", mode="idle"}[1m])
  ) * 100
)
```

추천 설정:

```text
Unit: Percent (0-100)
Min: 0
Max: 100
```

## 2. DATA VM CPU Usage

```promql
100 - (
  avg by(instance) (
    rate(node_cpu_seconds_total{instance="192.168.120.153:9100", mode="idle"}[1m])
  ) * 100
)
```

```text
Unit: Percent (0-100)
Min: 0
Max: 100
```

## 3. Pretix Container CPU Usage

Raw 1 CPU=100% 기준:

```promql
rate(
  container_cpu_usage_seconds_total{
    instance="192.168.120.152:8080",
    name="pretix-app",
    cpu="total"
  }[1m]
) * 100
```

Pretix에 `cpus: "0.5"`를 적용했으므로 이 표현에서는 약 50% 근처가 CPU quota 상한에 해당합니다.

추천 설정:

```text
Unit: Percent (0-100)
Min: 0
Max: 50
Threshold: Percentage 80% 또는 Absolute 40
```

> APP/DATA VM 전체 CPU 패널은 Max 100을 유지합니다.

## 해석 예시

- Pretix CPU가 50%에 반복적으로 닿음
- APP VM 전체 CPU는 약 30%대
- DATA VM CPU는 한 자릿수
- 동시에 p95가 증가하면 VM 전체나 DB가 아니라 CPU 제한된 Pretix가 주요 병목일 가능성이 높음
