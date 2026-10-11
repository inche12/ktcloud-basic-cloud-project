# Troubleshooting Log

## 1. Nginx 설정 파일을 수정했는데 컨테이너는 이전 설정을 계속 읽음

### 증상

호스트의 `~/stack/nginx.conf`에는 hybrid 설정이 있었지만 컨테이너 내부는 기존 설정이 남아 있었습니다.

```bash
docker compose exec nginx cat /etc/nginx/conf.d/default.conf
```

결과가 기존 `proxy_pass http://pretix:80;` 설정이었습니다.

### 확인

```bash
docker inspect pretix-nginx \
  --format '{{range .Mounts}}{{println .Source "->" .Destination}}{{end}}'
```

Bind mount 자체는 정상:

```text
/home/student/stack/nginx.conf -> /etc/nginx/conf.d/default.conf
```

### 원인

편집기가 저장 과정에서 기존 파일에 직접 덮어쓰지 않고 새 파일을 만든 뒤 rename/replace 하는 경우 inode가 변경될 수 있습니다. 이미 생성된 컨테이너는 이전 bind mount 대상을 계속 보고 있을 수 있어 `nginx -s reload`만으로 해결되지 않았습니다.

### 해결

```bash
docker compose up -d --force-recreate nginx
```

재생성 후:

```bash
docker compose exec nginx cat /etc/nginx/conf.d/default.conf
docker compose exec nginx nginx -t
curl -s -D - -o /dev/null http://localhost/ | grep -i X-Served-By
```

정상적으로 `X-Served-By`가 출력되고 hybrid access log에 `rt=`, `up=`, `urt=`가 기록되는 것을 확인했습니다.

### 배운 점

- 호스트 파일 내용과 컨테이너 내부 파일 내용을 각각 확인한다.
- bind mount 파일을 교체한 뒤 설정이 반영되지 않으면 컨테이너 재생성을 고려한다.
- `reload`는 Nginx 설정 reload이지 Docker bind mount를 다시 생성하는 작업이 아니다.

---

## 2. 장소 이동 후 Docker image pull 실패 / DNS timeout

### 증상

집에서 도서관으로 이동한 뒤 cAdvisor image pull 실패:

```text
lookup ghcr.io on 127.0.0.53:53: i/o timeout
```

### 진단

```bash
ping -c 3 8.8.8.8
# 실패

ip route
# default via 192.168.120.2 정상

ping -c 3 192.168.120.1
# 성공

ping -c 3 192.168.120.2
# 실패
```

### 판단

- VM ↔ Windows VMnet8 adapter(.1)는 정상
- VMware NAT Gateway(.2)가 비정상
- DNS 이전 단계인 NAT 경로 문제

### 해결

Windows `services.msc`에서 **VMware NAT Service**를 재시작했습니다.

재시작 후:

```bash
ping -c 3 192.168.120.2
ping -c 3 8.8.8.8
getent hosts ghcr.io
```

모두 정상으로 복구되었습니다.

### 배운 점

장소 이동 후 VM 내부 IP를 바로 변경하지 말고 다음 순서로 점검합니다.

```text
VM IP/route
→ VMnet8 host adapter (.1)
→ VMware NAT gateway (.2)
→ 8.8.8.8
→ DNS hostname
```

---

## 3. node-exporter / cAdvisor 컨테이너 이름 충돌

### 증상

```text
Conflict. The container name "/node-exporter" is already in use
Conflict. The container name "/cadvisor" is already in use
```

### 원인

이전 실습에서 동일한 이름의 exporter 컨테이너를 이미 생성해 둔 상태에서 새 Compose 프로젝트로 같은 이름을 생성하려 했습니다.

### 해결 절차

먼저 기존 상태 확인:

```bash
docker ps -a --filter name=node-exporter
docker ps -a --filter name=cadvisor
```

정상 컨테이너이면 재사용하고, 새 `~/m-agent` Compose 기준으로 통일할 필요가 있을 때만 exporter 컨테이너를 제거 후 재생성합니다.

```bash
docker rm -f node-exporter cadvisor
cd ~/m-agent
docker compose up -d
```

> PostgreSQL/Pretix처럼 상태가 중요한 서비스가 아니라 exporter 컨테이너에만 적용합니다.

---

## 4. Node Exporter는 Created, cAdvisor는 기존 컨테이너로 실행 중

Compose 작업이 중간의 이름 충돌로 중단되면서 `node-exporter`가 `Created` 상태에 머물고 `:9100/metrics` 응답이 없었습니다. 기존 exporter를 정리하고 Compose를 다시 실행한 뒤 둘 다 정상화했습니다.

```bash
docker compose ps
curl -s http://192.168.120.152:9100/metrics | head
curl -s http://192.168.120.152:8080/metrics | head
```

---

## 운영 규칙

- 15분 이상 막히면 막힌 지점 / 시도한 내용 / 에러 메시지를 공유한다.
- 비밀정보는 트러블슈팅 문서에도 기록하지 않는다.
- 정상 동작 중인 서비스는 원인 확인 없이 삭제/재설치하지 않는다.
