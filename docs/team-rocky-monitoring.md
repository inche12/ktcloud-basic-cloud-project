# Team Rocky Monitoring Plan

팀 메인 환경이 Rocky Linux라면 개인 Ubuntu Dashboard와 분리된 Grafana Dashboard를 권장합니다.

```text
Team Rocky On-prem Monitoring
├─ Rocky VM CPU / Memory
├─ Pretix CPU / Memory
├─ Nginx CPU
├─ PostgreSQL CPU
└─ Redis CPU
```

## 1. Rocky exporter 확인

```bash
docker ps -a --filter name=node-exporter
docker ps -a --filter name=cadvisor
```

없으면 Node Exporter/cAdvisor를 구성합니다. Rocky에서는 UFW가 아니라 firewalld/SELinux 영향을 확인해야 합니다.

## 2. 네트워크 주의

Monitoring VM과 팀 Rocky가 다른 LAN이면 사설 IP만으로 Prometheus scrape가 되지 않습니다. 같은 LAN, WireGuard/VPN, 또는 라우팅 가능한 사설 경로가 필요합니다.

`9100`, `8080`을 인터넷 전체에 직접 공개하지 않습니다.

## 3. Prometheus target 예시

```yaml
- job_name: "team-rocky-node"
  static_configs:
    - targets: ["<ROCKY_IP>:9100"]

- job_name: "team-rocky-cadvisor"
  static_configs:
    - targets: ["<ROCKY_IP>:8080"]
```

## 4. Grafana

기존 `Pretix On-prem Monitoring` Dashboard를 복제해 `Team Rocky On-prem Monitoring`으로 저장한 뒤 job/instance label만 팀 환경에 맞게 변경하는 방식이 가장 빠릅니다.
