# VSCode Hugo 블로그 작성 가이드

## 📦 설치된 확장 프로그램

### 핵심 확장 프로그램
1. **Hugo Language and Syntax Support** - Hugo 템플릿 문법 지원
2. **Better TOML** - Hugo 설정 파일(config.toml) 편집
3. **Front Matter CMS** - Hugo 콘텐츠 관리 UI
4. **Markdown All in One** - Markdown 통합 도구

### Markdown 편집 도구
1. **Markdown Preview Enhanced** - 고급 미리보기
2. **markdownlint** - Markdown 문법 검사
3. **Code Spell Checker** - 맞춤법 검사

### 이미지 관리
1. **Paste Image** - 클립보드에서 이미지 붙여넣기

## 🚀 빠른 시작

### 1. 새 포스트 만들기

#### 방법 1: Front Matter CMS 사용 (추천)
1. VSCode 좌측 사이드바에서 Front Matter 아이콘 클릭
2. "Create new" 버튼 클릭
3. 제목과 메타데이터 입력

#### 방법 2: 터미널 사용
```bash
hugo new posts/my-new-post.md
```

#### 방법 3: 스니펫 사용
1. 새 Markdown 파일 생성
2. `post` 입력 후 Tab 키

### 2. Congo 테마 단축 코드 사용

VSCode에서 다음 스니펫을 입력하고 Tab 키를 누르세요:

- `alert` → 알림 박스
- `badge` → 뱃지
- `button` → 버튼
- `figure` → 이미지 with 캡션
- `chart` → 차트
- `mermaid` → 다이어그램
- `katex` → 수학 공식
- `lead` → 강조 텍스트

### 3. 이미지 삽입

#### 클립보드에서 붙여넣기
1. 이미지 복사 (스크린샷 또는 파일)
2. Markdown 파일에서 `Cmd+Alt+V` (Mac) / `Ctrl+Alt+V` (Windows)
3. 이미지가 자동으로 저장되고 링크 생성됨

#### 드래그 앤 드롭
1. 이미지 파일을 VSCode로 드래그
2. Shift 키를 누른 상태로 드롭

### 4. 실시간 미리보기

#### 로컬 서버 실행
```bash
hugo server -D
```
브라우저에서 http://localhost:1313 접속

#### VSCode 내 미리보기
- `Cmd+K V` (Mac) / `Ctrl+K V` (Windows): 사이드 미리보기
- `Cmd+Shift+V` (Mac) / `Ctrl+Shift+V` (Windows): 전체 미리보기

### 5. Front Matter 메타데이터

```yaml
---
title: "포스트 제목"
date: 2024-08-04T10:00:00+09:00
draft: false
description: "포스트 설명"
tags: ["태그1", "태그2"]
categories: ["카테고리"]
showTableOfContents: true
showAuthor: true
showDate: true
showReadingTime: true
---
```

## 📝 유용한 단축키

### 일반 편집
- `Cmd+B` / `Ctrl+B`: 굵게
- `Cmd+I` / `Ctrl+I`: 기울임
- `Cmd+K` → `Cmd+L` / `Ctrl+K` → `Ctrl+L`: 링크 삽입

### Markdown All in One
- `Alt+C`: 체크박스 토글
- `Ctrl+Shift+]`: 헤딩 레벨 증가
- `Ctrl+Shift+[`: 헤딩 레벨 감소
- `Alt+Shift+F`: 테이블 정렬

### Front Matter CMS
- `Cmd+Shift+P` → "Front Matter: Open Dashboard": 대시보드 열기
- `Cmd+Shift+P` → "Front Matter: Create new content": 새 콘텐츠

## 🎨 Congo 테마 특수 기능

### 1. 알림 박스 아이콘
- `circle-info`: 정보
- `triangle-exclamation`: 경고
- `skull-crossbones`: 위험
- `bug`: 버그
- `lightbulb`: 팁

### 2. 차트 타입
- `bar`: 막대 차트
- `line`: 선 차트
- `pie`: 파이 차트
- `doughnut`: 도넛 차트
- `radar`: 레이더 차트

### 3. Mermaid 다이어그램
- `graph TD`: 위에서 아래로
- `graph LR`: 왼쪽에서 오른쪽으로
- `graph BT`: 아래에서 위로
- `graph RL`: 오른쪽에서 왼쪽으로

## 🔧 문제 해결

### 이미지가 표시되지 않을 때
1. 이미지 경로가 올바른지 확인
2. `static/` 폴더에 이미지가 있는지 확인
3. 파일명에 공백이 없는지 확인

### Front Matter가 작동하지 않을 때
1. `frontmatter.json` 파일이 프로젝트 루트에 있는지 확인
2. VSCode 재시작
3. Front Matter 확장 프로그램 재설치

### Markdown 미리보기가 깨질 때
1. `hugo server -D` 실행 중인지 확인
2. 브라우저에서 직접 확인: http://localhost:1313

## 📚 추가 리소스
- [Congo 테마 문서](https://jpanther.github.io/congo/)
- [Hugo 문서](https://gohugo.io/documentation/)
- [Markdown 가이드](https://www.markdownguide.org/)