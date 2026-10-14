# WireGuard

## 주소
```text
AWS WG     10.10.0.1
Rocky      10.10.0.2
Monitoring 10.10.0.3
```

## Monitoring 확인
```bash
sudo systemctl status wg-quick@wg0 --no-pager
ip -br addr
sudo wg show
```

정상:
```text
active (exited)
latest handshake: ...
transfer: received / sent 증가
```

`active (exited)`는 wg-quick이 인터페이스 생성 작업을 완료한 정상 상태다.

## 연결 확인
```bash
ping -c 3 10.10.0.1
ping -c 3 10.10.0.2
```

Exporter:
```bash
curl -s http://10.10.0.2:9100/metrics | head
curl -s http://10.10.0.2:8081/metrics | head
curl -s http://10.10.0.2:9113/metrics | head
```

현재 모두 성공.

## 키 구조
```text
Monitoring VM
├─ PrivateKey = 자기 VM 안에만 보관
└─ PublicKey  = AWS Peer에 등록

AWS WG
├─ PrivateKey = AWS 서버 안에만 보관
└─ PublicKey  = Monitoring의 [Peer]에 등록
```

PrivateKey는 GitHub/채팅/팀 문서에 저장하지 않는다.

## Peer 영구 저장
`wg set`은 즉시 반영용이다. 재부팅 후에도 유지하려면 AWS WG 서버의 `/etc/wireguard/wg0.conf`에도 Peer를 기록한다.

수정 전:
```bash
sudo cp /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak
```

예시:
```ini
[Peer]
PublicKey = <MONITORING_VM_PUBLIC_KEY>
AllowedIPs = 10.10.0.3/32
```

실제 PrivateKey는 문서에 기록하지 않는다.
