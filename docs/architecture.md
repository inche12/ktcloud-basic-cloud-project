# Architecture

## 1. 개인 실습 환경

```text
Windows Load PC
  |
  | hey / k6
  v
onprem-app (192.168.120.152)
  ├─ Nginx :80
  │   ├─ hybrid access log
  │   ├─ X-Served-By header
  │   ├─ max_conns (Cloud Burst 기준)
  │   └─ AWS ALB backup (예정)
  └─ Pretix
       |
       +--> onprem-data (192.168.120.153):5432 PostgreSQL
       +--> onprem-data (192.168.120.153):6379 Redis
                            |
                            └─ wg0 10.10.0.2/24
                                  |
                                  └─ AWS WireGuard 10.10.0.1 (예정)

Monitoring VM (192.168.120.154)
  ├─ Prometheus :9090
  └─ Grafana    :3000
        ^
        |
        +-- APP Node Exporter :9100
        +-- APP cAdvisor      :8080
        +-- DATA Node Exporter:9100
        +-- DATA cAdvisor     :8080
```

## 2. 설계 의도

- APP / DATA 역할을 분리하여 애플리케이션 병목과 데이터 계층 병목을 구분한다.
- PostgreSQL / Redis는 외부 인터넷에 직접 노출하지 않는다.
- AWS 확장 시에도 같은 데이터 저장소를 사용하도록 WireGuard 경로를 사용한다.
- Node Exporter는 VM 전체 자원, cAdvisor는 Docker 컨테이너 자원을 수집한다.
- Prometheus는 5초 간격으로 수집하고 Grafana에서 시간축으로 비교한다.

## 3. Cloud Burst 목표 구조

```text
Client / k6
    |
    v
On-Prem Nginx
    |
    +--> On-Prem Pretix (max_conns까지)
    |
    └--> AWS ALB (backup)
             |
             v
        AWS Pretix EC2 / ASG
             |
         WireGuard
             |
             v
    On-Prem PostgreSQL / Redis
```

Nginx 로그의 `up=$upstream_addr`, `urt=$upstream_response_time`, `rt=$request_time`과 `X-Served-By`를 이용해 실제 요청 처리 위치를 확인합니다.

## 4. 트레이드오프

- PostgreSQL / Redis가 단일 지점이므로 SPOF 가능성이 있습니다.
- AWS 앱이 온프렘 데이터 계층을 사용하므로 VPN 구간 지연이 추가됩니다.
- `cpus: "0.5"`는 실제 운영 권장값이 아니라 작은 실습 환경에서 포화 구간을 재현하기 위한 데모 제약입니다.
- `max_conns`는 `hey -c`와 동일한 개념이 아니므로 실측 후 조정해야 합니다.
