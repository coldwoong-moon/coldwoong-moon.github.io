# Hugo 블로그 이미지 관리 가이드

## 이미지 저장 위치 및 참조 방법

### 1. Static 폴더 방식 (권장) ✅
VSCode 미리보기와 Hugo 모두에서 작동하는 방법

**이미지 저장 위치:**
```
static/
└── images/
    └── posts/
        └── your-post-name/
            └── image.jpg
```

**Markdown에서 참조:**
```markdown
![이미지 설명](/images/posts/your-post-name/image.jpg)
```

**장점:**
- VSCode Markdown 미리보기에서도 작동
- Hugo 서버에서도 작동
- 절대 경로로 일관성 있게 관리 가능

### 2. Page Bundle 방식 (Hugo 전용)
Hugo의 이미지 처리 기능을 활용하는 방법

**디렉토리 구조:**
```
content/posts/
└── your-post-name/
    ├── index.md        # 반드시 index.md여야 함
    └── image.jpg
```

**Markdown에서 참조:**
```markdown
![이미지 설명](image.jpg)
```

**장점:**
- Hugo가 자동으로 이미지 최적화 (크기 조정, 반응형 이미지 생성)
- 포스트와 관련 리소스를 한 폴더에서 관리

**단점:**
- VSCode Markdown 미리보기에서 이미지가 보이지 않음

## VSCode 설정

`.vscode/settings.json`에 다음 설정이 추가되어 있습니다:

```json
{
  // 이미지를 static 폴더에 자동 저장
  "pasteImage.path": "${projectRoot}/static/images",
  "pasteImage.insertPattern": "![${imageFileName}](/images/${imageFileName})",
  
  // Markdown 미리보기 설정
  "markdown.preview.resourceRoot": "${workspaceFolder}"
}
```

## 권장 워크플로우

1. **새 포스트 작성 시:**
   - `hugo new posts/my-new-post/index.md` 명령으로 Page Bundle 생성
   - 또는 `hugo new posts/my-new-post.md`로 일반 포스트 생성

2. **이미지 추가 시:**
   - **Static 방식**: `/static/images/posts/포스트명/` 폴더에 이미지 저장
   - **Page Bundle**: 포스트와 같은 폴더에 이미지 저장

3. **이미지 참조:**
   - **Static 방식**: `/images/posts/포스트명/이미지.jpg`
   - **Page Bundle**: `이미지.jpg` (상대 경로)

## 문제 해결

### VSCode 미리보기에서 이미지가 안 보일 때
- Static 폴더 방식 사용
- 절대 경로로 참조 (`/images/...`)
- VSCode 재시작 후 다시 시도

### Hugo 서버에서 이미지가 안 보일 때
- `hugo server -D` 명령으로 draft 포스트도 표시
- 브라우저 캐시 초기화 (Cmd+Shift+R)
- `localhost:1313` 사용 (127.0.0.1 대신)

### 이미지 경로 변환 스크립트
기존 Page Bundle 이미지를 Static 폴더로 이동하는 경우:
```bash
# 예시 명령
cp content/posts/my-post/*.jpg static/images/posts/my-post/
```

## 참고사항
- Hugo는 `/static` 폴더의 내용을 사이트 루트에 복사
- 따라서 `/static/images/file.jpg`는 `/images/file.jpg`로 접근
- Page Bundle 사용 시 파일명은 반드시 `index.md`여야 함