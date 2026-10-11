# AWS Integration Plan

## 목표

온프렘 처리 한계를 넘는 요청을 Nginx `backup` upstream인 AWS ALB로 전달합니다.

## 의존 순서

```text
WireGuard server + EIP
→ On-Prem/AWS tunnel peer
→ AWS Pretix → On-Prem DB/Redis connection OK
→ ALB target healthy
→ ASG 연결
→ Nginx ALB backup 활성화
→ Before / After test
```

## 확인할 지표

### ALB

- RequestCount
- TargetResponseTime
- HTTPCode_ELB_5XX / Target 5XX
- HealthyHostCount

### EC2 / ASG

- CPUUtilization
- NetworkIn / NetworkOut
- Desired / InService instance count

## 리소스 기록 규칙

- 이름 prefix: `pretix-demo-`
- tag: `Project=pretix-demo`
- region: `ap-northeast-2`
- Terraform 전환을 위해 생성한 AWS 리소스 ID를 별도 표에 기록
