# Next Steps

## 1. 온프렘 기준값 확정

- `max_conns=25~28` 중 후보값 적용
- 온프렘 단독 상태에서 재검증
- Nginx 로그에서 upstream 상태 확인

## 2. 팀 Rocky 메인 환경 모니터링

개인 Ubuntu 대시보드와 별도로 팀용 Grafana Dashboard를 생성합니다.

예시:

```text
Team Rocky On-prem Monitoring
├─ Rocky VM CPU / Memory
├─ Pretix CPU / Memory
├─ Nginx CPU
├─ PostgreSQL CPU
└─ Redis CPU
```

기존 Monitoring VM의 Prometheus/Grafana를 재사용하되, 팀 Rocky exporter target이 네트워크상 접근 가능한 경우에만 추가합니다. `9100`, `8080`을 인터넷에 직접 공개하지 않습니다.

## 3. AWS Cloud Burst

- WireGuard server + EIP
- AWS Pretix가 온프렘 PostgreSQL / Redis에 접속되는지 확인
- ALB Target Group `healthy`
- ASG 연결
- Nginx ALB backup 활성화

예시:

```nginx
upstream pretix_pool {
    zone pretix_zone 64k;
    server pretix:80 max_conns=25;
    server <ALB_DNS>:80 backup;
}
```

## 4. k6 최종 검증

`hey`는 온프렘 한계 탐색에 사용하고, k6는 최종 하이브리드 검증에 사용합니다.

최종적으로 같은 시간축에서 확인할 값:

- RPS
- p95 / p99
- Error Rate
- Pretix CPU / Memory
- APP / DATA CPU
- AWS EC2 / ALB / ASG 지표

## 5. Logs: Loki + Alloy 권장

이미 Grafana를 사용하고 있으므로 ELK를 추가하기보다 Loki + Alloy가 프로젝트 구성에 더 자연스럽습니다.

```text
Nginx / Pretix / Docker logs
          ↓
        Alloy
          ↓
         Loki
          ↓
        Grafana
```

수집 추천 필드:

- HTTP status
- `$request_time`
- `$upstream_addr`
- `$upstream_status`
- `$upstream_response_time`
- request ID
- Nginx 502/503/504
- Pretix exception / worker timeout

### Logback / Logstash / Elasticsearch

- Logback: Java/Spring 계열 애플리케이션 로깅 프레임워크이므로 Pretix(Python/Django)에는 필수 아님
- Logstash: 로그 수집/변환 파이프라인
- Elasticsearch: 로그 검색/저장
- Kibana: Elasticsearch 시각화

본 프로젝트는 Prometheus/Grafana가 이미 있으므로 **Loki + Alloy + Grafana**를 우선 권장합니다. ELK는 별도 기술 학습 시나리오로 추가할 수 있습니다.
