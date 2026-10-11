# Codex 작업 지침

이 저장소는 KT Cloud 실습/프로젝트 과정을 개인 포트폴리오 형태로 기록하기 위한 저장소다.

## 작업 원칙

1. 기존 문서 구조와 기록을 유지하고, 사용자가 제공한 실습 결과만 사실로 기록한다.
2. `.env`, DB 비밀번호, AWS Access Key/Secret Key, WireGuard PrivateKey, `*.pem`, `*.key`, `pretix.cfg` 등 비밀정보를 절대 커밋하지 않는다.
3. 커밋 전 `.gitignore`, `git status`, `git diff --cached`를 확인한다.
4. 부하 테스트 결과는 `load-test/results/`에 기록하고 README/진행 문서의 요약도 함께 갱신한다.
5. 아키텍처 변경은 `docs/architecture.md`, 장애/해결 과정은 `docs/troubleshooting.md`, 다음 작업은 `docs/next-steps.md`에 반영한다.
6. 이미지에 비밀정보가 보이지 않는지 확인한 뒤에만 `images/`에 포함한다.
7. 이미 정상 동작 중인 서비스나 파일을 이유 없이 삭제/초기화하지 않는다.
8. 커밋 메시지는 의미가 드러나는 짧은 영어 또는 한국어로 작성한다.

## GitHub 업로드 작업

사용자가 이 폴더를 GitHub에 올려 달라고 하면 다음 순서로 처리한다.

1. 현재 디렉터리가 `ktcloud-basic-cloud-project`인지 확인한다.
2. Git 저장소가 아니면 `git init` 후 기본 브랜치를 `main`으로 설정한다.
3. 민감정보 검사를 수행한다.
4. `.gitignore`가 정상 적용되는지 확인한다.
5. `git add .` 후 staged diff를 검토한다.
6. 최초 커밋 메시지는 `Initial KT Cloud basic project notes`로 한다.
7. GitHub에 새 저장소 `ktcloud-basic-cloud-project`를 생성한다. GitHub 계정은 현재 인증된 사용자의 계정을 사용한다.
8. 공개/비공개 여부가 명확하지 않으면 저장소 생성 전에 사용자에게 확인한다.
9. `origin` 연결 후 `main` 브랜치를 push한다.
10. 완료 후 저장소 주소, 브랜치, 마지막 커밋 hash를 알려준다.

## 민감정보 검사 예시

```bash
grep -RInE \
  --exclude-dir=.git \
  --exclude='*.png' \
  '(AWS_ACCESS_KEY_ID|AWS_SECRET_ACCESS_KEY|PrivateKey|DB_PASSWORD|password[[:space:]]*=|BEGIN .*PRIVATE KEY)' .
```

민감정보가 발견되면 push하지 말고 파일명/위치만 알려준다. 비밀값 자체는 출력하지 않는다.
