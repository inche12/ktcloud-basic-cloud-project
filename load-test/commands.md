# Load Test Commands

## 개인 온프렘

```powershell
.\hey.exe -z 60s -c 5  http://192.168.120.152/
.\hey.exe -z 60s -c 10 http://192.168.120.152/
.\hey.exe -z 60s -c 20 http://192.168.120.152/
.\hey.exe -z 60s -c 30 http://192.168.120.152/
.\hey.exe -z 60s -c 40 http://192.168.120.152/
```

## Smoke Test

`hey` 기본 concurrency가 50이므로 `-n 1`만 쓰면 안 됩니다.

```powershell
.\hey.exe -n 1 -c 1 http://192.168.120.152/
```

## 팀 환경

팀 URL은 별도 확인 후 사용합니다. 개인 환경의 `/` URL과 팀 이벤트 경로를 혼동하지 않습니다.

## Server Side

Prometheus/Grafana가 정상 구성된 뒤에는 `docker stats`를 매번 수동 기록할 필요가 없습니다. 필요할 때 검증/트러블슈팅용으로만 사용합니다.

```bash
docker stats
```
