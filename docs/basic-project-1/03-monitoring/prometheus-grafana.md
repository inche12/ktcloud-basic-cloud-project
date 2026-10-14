# Prometheus + Grafana

## Monitoring VM
```text
LAN: 192.168.120.154
WG : 10.10.0.3
```

```text
Prometheus http://192.168.120.154:9090
Grafana    http://192.168.120.154:3000
```

## Prometheus targets
```yaml
- job_name: "team-rocky-node"
  static_configs:
    - targets: ["10.10.0.2:9100"]

- job_name: "team-rocky-cadvisor"
  static_configs:
    - targets: ["10.10.0.2:8081"]

- job_name: "team-rocky-nginx"
  static_configs:
    - targets: ["10.10.0.2:9113"]
```

## 설정 검사
```bash
cd ~/monitoring

docker run --rm   --entrypoint /bin/promtool   -v "$PWD/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro"   prom/prometheus   check config /etc/prometheus/prometheus.yml
```

정상:
```text
SUCCESS
```

## 재시작
```bash
docker compose restart prometheus
docker compose ps
```

필요 시 강제 재생성:
```bash
docker compose up -d --force-recreate prometheus
```

## Target 확인
```promql
up{job=~"team-rocky.*"}
```

목표:
```text
team-rocky-node       1
team-rocky-cadvisor   1
team-rocky-nginx      1
```

## Grafana datasource
```text
http://prometheus:9090
```
