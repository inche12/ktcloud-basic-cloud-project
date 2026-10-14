# Architecture

## 프로젝트 흐름
```text
Compose Baseline
      ↓
모니터링
      ↓
부하 측정
      ↓
Kubernetes
      ↓
HPA
      ↓
온프레미스 한계
      ↓
AWS Burst
```

## 현재 Baseline
```text
Client
  |
  v
Nginx
  |
  v
Pretix
  |
  +---- PostgreSQL
  |
  +---- Redis
```

현재 팀 메인 환경은 Rocky Linux 한 대에 Docker Compose로 구성된 All-in-One 방식이다.

## Monitoring
```text
Rocky
 ├─ node_exporter :9100
 ├─ cAdvisor      :8081
 └─ nginx exporter:9113
        |
        v
     WireGuard
        |
        v
Monitoring VM
 ├─ Prometheus
 └─ Grafana
```

## 향후 Kubernetes
```text
External Nginx
      |
      v
Kubernetes Service
      |
      +---- Pretix Pod 1
      +---- Pretix Pod 2
      +---- Pretix Pod N
              ^
              |
             HPA
```

처음에는 DB/Redis를 기존 Data 계층에 유지하고 Pretix App Tier부터 Kubernetes로 이전한다.

## 최종 Hybrid Burst
```text
Client
  |
  v
Nginx
  |
  +---- On-prem Kubernetes / HPA
  |
  +---- AWS ALB / ASG
```

핵심은 기술 사용 자체보다 동일한 부하 조건으로 Before/After를 비교하는 것이다.
