# k6 Load Test Plan

## 역할
- 정식 성능 비교
- 단계별 VU
- p95 / p99
- Error Rate
- Kubernetes HPA 검증
- AWS Burst 전/후 비교

## Load Generator 위치
Rocky 서버 자체에서 돌리지 않는다.

권장:
```text
Windows PC
또는
별도 Ubuntu Load Generator VM
```

## pretix-load.js
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: Number(__ENV.VUS || 5),
  duration: __ENV.DURATION || '60s',
};

export default function () {
  const res = http.get(__ENV.URL);

  check(res, {
    'status is 200': (r) => r.status === 200,
  });

  sleep(1);
}
```

## 실행
```bash
k6 run   -e VUS=5   -e DURATION=60s   -e URL="http://REAL_PRETIX_EVENT_URL/"   pretix-load.js
```

단계:
```text
5 VU
10 VU
20 VU
30 VU
40 VU
```

각 60초, 테스트 사이 약 1분 안정화.

## 기록표
| VU | RPS | p95 | p99 | Error | Rocky CPU | Pretix CPU | DB CPU | Notes |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 5 | | | | | | | | |
| 10 | | | | | | | | |
| 20 | | | | | | | | |
| 30 | | | | | | | | |
| 40 | | | | | | | | |

## Kubernetes용 stages
```javascript
export const options = {
  stages: [
    { duration: '1m', target: 5 },
    { duration: '2m', target: 10 },
    { duration: '2m', target: 20 },
    { duration: '2m', target: 40 },
    { duration: '1m', target: 0 },
  ],
};
```

관찰:
```text
VU 증가
  ↓
Pretix Pod CPU 증가
  ↓
HPA
  ↓
Replica 증가
  ↓
p95 / Error 변화
```

동일 테스트를 Compose → Kubernetes → HPA → AWS Burst에 반복한다.
