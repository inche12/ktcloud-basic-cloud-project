# Progress Log

## 2026-10-10

### On-Prem APP

- Pretix CPU limit `cpus: "0.5"` 적용
- `docker inspect pretix-app --format '{{.HostConfig.NanoCpus}}'` 결과 `500000000` 확인
- Nginx upstream hybrid 설정 추가
  - `max_conns` 지원
  - AWS ALB `backup` placeholder
  - `rt`, `up`, `urt` access log
  - `X-Served-By` response header
- 온프렘 한계 측정을 위해 `max_conns`는 일시 제거하고 테스트 수행

### Monitoring

- APP Node Exporter `192.168.120.152:9100`
- APP cAdvisor `192.168.120.152:8080`
- DATA Node Exporter `192.168.120.153:9100`
- DATA cAdvisor `192.168.120.153:8080`
- Monitoring VM `192.168.120.154`
  - Prometheus `:9090`
  - Grafana `:3000`
- Prometheus `up` query에서 4개 target 모두 `1`
- Grafana Dashboard `Pretix On-prem Monitoring`
  - APP CPU Usage
  - DATA CPU Usage
  - Pretix Container CPU Usage

### Load Test

`hey`로 c=5,10,20,30,40 단계별 테스트 수행.

- c=30: p95 약 1.81초 → 한계 근접
- c=40: p95 약 2.99초 + timeout 3건 → 한계 초과
- c=40 재현 테스트에서도 p95 > 2초 확인

현재 1차 한계 구간은 c≈40으로 판단.

### Next

- Nginx `max_conns=25~28` 초기 후보 검증
- AWS ALB / Target Group / ASG 준비
- AWS Pretix → WireGuard → On-Prem DB/Redis 연결 검증
- Before / After 동일 부하 비교
- 최종 검증은 k6로 재현 가능한 시나리오 작성
- Loki + Alloy로 Nginx/Pretix 로그 시각화
