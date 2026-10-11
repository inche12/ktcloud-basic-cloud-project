# Team Initial Load Test Result - c=5

## Scope

팀 메인 Pretix 환경의 초기 c=5 측정값입니다. 개인 온프렘 `.152` 결과와 구분합니다.

## Command

```powershell
.\hey.exe -z 60s -c 5 http://180.228.159.254/test-org/kfbj8/
```

## Result

| 항목 | 값 |
|---|---:|
| Total | 60.3213s |
| Slowest | 2.7536s |
| Fastest | 0.2054s |
| Average | 0.4117s |
| Requests/sec | 12.1184 |
| p50 | 0.3925s |
| p90 | 0.5185s |
| p95 | 0.5596s |
| p99 | 0.6820s |
| HTTP 200 | 731 |
| Error | 없음 |
| Pretix CPU Peak | 추후 기록 |

## 판정

- p95가 2초 이하
- HTTP 200 응답 731개
- 에러 없음
- 현재 기준으로 정상 구간
