# Kubernetes + HPA Plan

## 1차 범위
전체를 한 번에 이전하지 않는다.

```text
Kubernetes
└─ Pretix App Tier

기존 Data Tier
├─ PostgreSQL
└─ Redis
```

## 개인 환경
32GB RAM 호스트 기준으로 기존 App VM을 단일 Node Kubernetes로 시작한다.

```text
Control Plane + Workload
```

실습에서 확인:
- Deployment
- Service
- Self-healing
- Metrics Server
- HPA

한계:
- 실제 물리 Node scale-out은 아님
- Pod들이 같은 Node CPU/RAM을 공유함

## 추가 Grafana 패널
- Node CPU
- Node Memory
- Pretix Pod CPU
- Pretix Pod Memory
- Running Pod Count
- HPA Current Replicas
- HPA Desired Replicas
- Pod Restart Count

## 목표 흐름
```text
k6
 ↓
Service
 ↓
Pretix Pods
 ↓
CPU 증가
 ↓
HPA
 ↓
Replica 증가
```

## 최종
```text
Nginx
 ├─ On-prem K8s / HPA
 └─ AWS ALB / ASG
```
