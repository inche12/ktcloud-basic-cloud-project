# Roadmap

## 1. Monitoring Baseline 고정
- Rocky CPU
- Rocky Memory
- Pretix CPU
- PostgreSQL CPU
- Redis CPU
- Network RX/TX
- Nginx Active Connections
- Nginx Request Rate

## 2. k6 Baseline
```text
5 / 10 / 20 / 30 / 40 VU
각 60초
테스트 사이 1분 휴식
```

기록:
- RPS
- p95
- p99
- Error Rate
- Rocky CPU
- Pretix CPU
- DB CPU
- Redis CPU
- Network
- Nginx Request Rate

## 3. 한계 구간 정의
한 번의 결과로 단정하지 않고 가능하면 2~3회 반복한다.

관찰:
```text
p95 급증
Error 발생
Pretix CPU quota 접근
Rocky CPU 상승
```

## 4. Kubernetes
- Deployment
- Service
- Metrics Server
- HPA

## 5. 동일 k6 반복
```text
Compose
vs
Kubernetes
vs
Kubernetes + HPA
```

## 6. AWS Burst
향후:
- VPC
- ALB
- ASG
- WAF
- WireGuard
- CloudWatch

CloudWatch:
- RequestCount
- TargetResponseTime p95
- 5xx
- UnHealthyHostCount
- ASG InService Instances
- EC2 CPU

## 7. 최종 데모
```text
Grafana + CloudWatch + k6
```

스토리:
```text
부하 증가
→ On-prem 지표 증가
→ HPA 확장
→ 온프레미스 한계
→ AWS Traffic 증가
→ 성능 재검증
```
