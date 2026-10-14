# Basic Project 1
## 마감·예약형 서비스의 순간 트래픽 대응을 위한 하이브리드 클라우드 인프라 구축

> 실제 특정 기업의 내부 구조를 재현한 것이 아니라, 마감·예약형 서비스의 순간 트래픽 문제에서 착안한 실습용 프로젝트다.

## 목표
- Rocky Linux + Docker Compose 기반 Pretix Baseline 구축
- Prometheus + Grafana 모니터링
- WireGuard로 원격 Rocky ↔ AWS ↔ Monitoring VM 연결
- k6로 부하를 재현해 한계 지점 측정
- Kubernetes + HPA 적용
- 최종적으로 AWS Burst 구조와 성능 비교

## 현재 상태
| 항목 | 상태 |
|---|---|
| Rocky Compose | 완료 |
| Pretix / PostgreSQL / Redis / Nginx | 완료 |
| node_exporter / cAdvisor / nginx exporter | 완료 |
| Prometheus / Grafana | 완료 |
| WireGuard Monitoring ↔ AWS | 완료 |
| WireGuard Monitoring ↔ Rocky | 완료 |
| Grafana Rocky Dashboard | 완료 |
| k6 정식 테스트 | 다음 단계 |
| Kubernetes / HPA | 예정 |
| AWS Burst | 예정 |

## 현재 구조
```text
Rocky 10.10.0.2
├─ Nginx
├─ Pretix
├─ PostgreSQL
├─ Redis
├─ node_exporter :9100
├─ cAdvisor      :8081
└─ nginx exporter:9113
        |
        | WireGuard
        v
AWS WG 10.10.0.1
        |
        | WireGuard
        v
Monitoring VM 10.10.0.3
├─ Prometheus :9090
└─ Grafana    :3000
```

## 문서 구조
```text
basic-project-1/
├─ README.md
├─ CODEX_HANDOFF.md
├─ 01-overview/
├─ 02-onprem/
├─ 03-monitoring/
├─ 04-network/
├─ 05-load-test/
├─ 06-kubernetes/
├─ 07-troubleshooting/
└─ 08-next/
```

## 보안
절대 GitHub에 올리지 않는다.
- WireGuard PrivateKey
- AWS Access Key / Secret Key
- DB Password
- Grafana 관리자 비밀번호
- `.env`
- API Token / Secret
