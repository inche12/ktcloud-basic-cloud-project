# Codex Handoff

`basic-project-1/` 폴더 전체를 GitHub 저장소에 추가한다.

권장 위치:
```text
docs/basic-project-1/
```

## 주의
- 기존 파일은 삭제하지 않는다.
- Secret을 Markdown에 직접 넣지 않는다.
- `<...>` placeholder를 실제 비밀값으로 치환하지 않는다.
- `.env`, WireGuard PrivateKey, AWS Secret, DB Password는 커밋 금지.

## 예시
```bash
git status
git pull --rebase origin main

git add basic-project-1/
git commit -m "docs: add basic project 1 infrastructure notes"
git push origin main
```

기존 저장소가 `docs/` 중심이면:
```bash
mkdir -p docs
mv basic-project-1 docs/
git add docs/basic-project-1/
git commit -m "docs: add basic project 1 infrastructure notes"
git push origin main
```
