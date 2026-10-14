# hey Baseline

## 역할
빠르게 동시 요청을 발생시켜 대략적인 한계 구간을 찾는다.

```bash
hey -z 60s -c 20 http://TARGET/
```

```text
-z 60s : 60초
-c 20  : 20개 동시 worker
```

## 주의
반드시 HTTP 200이 나오는 실제 Pretix 페이지를 사용한다.

이전에 `/` 경로로 테스트했을 때 HTTP 400이 발생한 결과는 최종 성능 Baseline으로 사용하지 않는다.

## 기록
- RPS
- Average
- p95
- p99
- HTTP Status
- Timeout
- Connection refused

hey는 빠른 점검용, 정식 비교는 k6로 진행한다.
