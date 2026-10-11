# Load Test Plan

## 목적

1. 온프렘 Pretix 처리 한계를 찾는다.
2. 한계값을 바탕으로 Nginx `max_conns` 초기 후보를 결정한다.
3. AWS ALB 연결 전/후에 동일 부하를 적용해 Cloud Burst 효과를 비교한다.

## 현재 도구 구분

- `hey`: 한계값 빠른 탐색 및 간단한 반복 테스트
- `k6`: AWS 연결 후 최종 하이브리드 시나리오 / Before-After 재현 테스트
- Prometheus/Grafana: 서버/컨테이너 자원 시계열

## 개인 실습 명령

```powershell
.\hey.exe -z 60s -c 5  http://192.168.120.152/
.\hey.exe -z 60s -c 10 http://192.168.120.152/
.\hey.exe -z 60s -c 20 http://192.168.120.152/
.\hey.exe -z 60s -c 30 http://192.168.120.152/
.\hey.exe -z 60s -c 40 http://192.168.120.152/
```

각 테스트 사이에는 약 30초 이상 쉬고, CPU가 평상시 수준으로 내려왔는지 Grafana에서 확인합니다.

## 팀 메인 환경

팀 Pretix 이벤트 URL을 사용할 때는 팀에서 현재 사용 중인 실제 URL을 확인한 뒤 동일한 방식으로 테스트합니다. 개인 실습 URL과 팀 URL을 혼동하지 않습니다.

## 기록 항목

| c | RPS | Average | p95 | p99 | HTTP 200 | Error/Timeout | Pretix CPU Peak | APP CPU Peak | DATA CPU Peak | 판정 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 5 | | | | | | | | | | |
| 10 | | | | | | | | | | |
| 20 | | | | | | | | | | |
| 30 | | | | | | | | | | |
| 40 | | | | | | | | | | |

## 판정 기준

- 정상: p95 ≤ 2초, 오류 없음 또는 매우 낮음
- 한계 시작: p95 > 2초 또는 오류 증가 시작
- 먹통 시연 기준: p95 > 5초 또는 Error Rate > 5%

## max_conns

팀 실습에서는 `한계 동시성 × 약 0.7`을 초기 후보로 사용합니다.

현재 개인 실습 결과:

```text
한계 후보 c ≈ 40
40 × 0.7 ≈ 28
```

따라서 `max_conns=25~28`을 초기 후보로 검증합니다.

> `hey -c`는 클라이언트 동시 요청 수이고, Nginx `max_conns`는 upstream active connection 제한이므로 같은 값으로 간주하면 안 됩니다.

## Before / After

Cloud Burst 비교에서는 **동일한 명령과 동일한 duration/concurrency**를 사용합니다.

| 항목 | Before (On-Prem only) | After (On-Prem + AWS) |
|---|---:|---:|
| c | 동일 | 동일 |
| RPS | | |
| Average | | |
| p95 | | |
| p99 | | |
| Error Rate | | |
| Pretix CPU | | |
| APP CPU | | |
| DATA CPU | | |
| AWS 처리 증거 | 없음 | Nginx upstream / AWS metrics |
