# Rocky Compose Baseline

## 구성
```text
Rocky Linux
├─ nginx
├─ pretix
├─ db
├─ redis
├─ node-exporter
├─ cadvisor
└─ nginx-exporter
```

## 상태 확인
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

주요 포트:
```text
Nginx          :80
node_exporter  :9100
cAdvisor       :8081
nginx exporter :9113
```

## cAdvisor
컨테이너 내부는 8080, Rocky 호스트는 8081로 사용한다.

```yaml
ports:
  - "8081:8080"
```

8081이 8080보다 더 안전해서가 아니라 포트 충돌 가능성을 줄이고 프로젝트 설정을 통일하기 위해서다.

## 실제 Compose service label
Prometheus에서 확인:
```text
nginx-exporter
cadvisor
nginx
redis
db
pretix
node-exporter
```

Container CPU 쿼리에서는:
```text
container_label_com_docker_compose_service
```
를 사용한다.
