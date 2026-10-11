# k6 Plan

`hey`로 온프렘 한계 탐색은 완료했으므로 동일 실험을 k6로 처음부터 다시 할 필요는 없습니다.

k6는 AWS 연결 이후 최종 하이브리드 검증에 사용합니다.

## 목적

- 재현 가능한 단계형 부하 시나리오
- Before / After 동일 시나리오 반복
- RPS / p95 / p99 / Error Rate 자동 수집
- 향후 Prometheus Remote Write / Grafana 연동

## 예시 시나리오

```text
1분 낮은 부하
2분 중간 부하
2분 온프렘 한계 초과
2분 높은 부하 유지
1분 감소
```

최종적으로 Grafana에서 다음을 같은 시간축으로 비교하는 것이 목표입니다.

```text
k6 RPS / p95 / Error Rate
Pretix CPU / Memory
APP / DATA VM CPU
AWS ALB / EC2 / ASG metrics
Nginx upstream logs
```
