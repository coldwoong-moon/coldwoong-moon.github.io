# Congo 테마 업데이트 가이드

이 문서는 Congo 테마의 업데이트를 안전하게 관리하기 위한 스크립트들과 사용법을 설명합니다.

## 📁 제공되는 스크립트

### 1. `check-congo-updates.sh` - 업데이트 확인 전용
```bash
./check-congo-updates.sh
```
- **기능**: 현재 버전과 최신 버전을 비교
- **안전**: 실제 업데이트 없이 확인만 수행
- **정보**: 릴리스 노트, 시스템 정보 제공

### 2. `update-congo-theme.sh` - 메인 업데이트 스크립트
```bash
./update-congo-theme.sh
```
- **기능**: 안전한 백업 후 업데이트 적용
- **백업**: 자동 백업 생성 (`backups/congo-theme-YYYYMMDD-HHMMSS`)
- **검증**: 업데이트 후 Hugo 빌드 테스트
- **롤백**: 문제 발생 시 자동 롤백 스크립트 생성

### 3. `auto-update-congo.sh` - 자동 업데이트 (선택사항)
```bash
# 확인만
./auto-update-congo.sh false

# 자동 적용 (주의!)
./auto-update-congo.sh true
```
- **기능**: 정기적인 업데이트 확인 및 자동 적용
- **로깅**: 모든 작업을 `congo-update.log`에 기록
- **알림**: 시스템 알림 지원 (macOS/Linux)

### 4. `rollback-congo-theme.sh` - 롤백 스크립트 (자동 생성)
```bash
./rollback-congo-theme.sh backups/congo-theme-20240101-120000
```
- **기능**: 지정된 백업으로 완전 복원
- **자동생성**: 업데이트 스크립트 실행 시 자동 생성

## 🚀 사용법

### 기본 워크플로우

1. **업데이트 확인**
   ```bash
   ./check-congo-updates.sh
   ```

2. **업데이트 적용** (필요한 경우)
   ```bash
   ./update-congo-theme.sh
   ```

3. **업데이트 후 확인**
   ```bash
   npm install  # JavaScript 의존성 업데이트
   hugo server  # 로컬 서버로 테스트
   ```

4. **문제 발생 시 롤백**
   ```bash
   ./rollback-congo-theme.sh backups/congo-theme-YYYYMMDD-HHMMSS
   ```

### 정기적인 업데이트 확인 (크론탭)

```bash
# 크론탭 편집
crontab -e

# 매일 오전 9시에 업데이트 확인
0 9 * * * cd /path/to/your/blog && ./auto-update-congo.sh false

# 매주 일요일 오전 2시에 자동 업데이트 (신중하게 사용)
0 2 * * 0 cd /path/to/your/blog && ./auto-update-congo.sh true
```

## ⚠️ 주의사항

### 업데이트 전 체크리스트
- [ ] 중요한 작업을 Git에 커밋했는지 확인
- [ ] 충분한 디스크 공간이 있는지 확인
- [ ] 업데이트에 충분한 시간이 있는지 확인
- [ ] 테스트 환경에서 먼저 시도해볼 수 있는지 확인

### 자동 업데이트 사용 시 주의
- 프로덕션 환경에서는 신중하게 사용
- 정기적으로 로그 파일 확인
- 백업 디렉토리 용량 관리
- 롤백 계획 준비

## 📂 백업 관리

### 백업 구조
```
backups/
├── congo-theme-20240101-120000/
│   ├── assets/
│   ├── layouts/
│   ├── i18n/
│   ├── config/
│   ├── theme.toml
│   ├── go.mod
│   └── backup-info.txt
└── congo-theme-20240102-140000/
    └── ...
```

### 백업 정리
오래된 백업을 정리하려면:
```bash
# 30일 이상 된 백업 찾기
find backups/ -name "congo-theme-*" -type d -mtime +30

# 30일 이상 된 백업 삭제 (주의!)
find backups/ -name "congo-theme-*" -type d -mtime +30 -exec rm -rf {} \;
```

## 🔧 문제 해결

### 일반적인 문제

**1. 권한 오류**
```bash
chmod +x *.sh
```

**2. Hugo 빌드 실패**
```bash
# 모듈 정리
hugo mod clean
hugo mod get -u
hugo mod tidy

# 캐시 정리
hugo --gc --cleanDestinationDir
```

**3. Go 모듈 문제**
```bash
go mod download
go mod verify
```

### 로그 확인
```bash
# 최신 업데이트 로그 확인
tail -f congo-update.log

# 특정 날짜 로그 검색
grep "2024-01-01" congo-update.log
```

## 📋 업데이트 후 확인사항

1. **설정 파일 검토**
   - `config/congo-updates/` 디렉토리에서 새로운 설정 옵션 확인
   - 기존 설정과 새 설정을 비교하여 필요한 항목 추가

2. **의존성 업데이트**
   ```bash
   npm install
   npm audit fix
   ```

3. **빌드 테스트**
   ```bash
   hugo --gc --minify
   ```

4. **로컬 서버 테스트**
   ```bash
   hugo server -D
   ```

5. **프로덕션 배포**
   ```bash
   # GitHub Pages의 경우
   git add -A
   git commit -m "feat: Congo 테마 업데이트"
   git push origin main
   ```

## 🔗 유용한 링크

- [Congo 테마 공식 저장소](https://github.com/jpanther/congo)
- [Congo 테마 문서](https://jpanther.github.io/congo/)
- [Hugo 공식 문서](https://gohugo.io/documentation/)

## 📝 변경 로그

스크립트 변경사항이나 중요한 업데이트는 이곳에 기록하세요.

- **2024-08-01**: 초기 스크립트 생성
  - 업데이트 확인, 적용, 자동화 스크립트 추가
  - 백업 및 롤백 기능 구현
  - 로깅 및 알림 기능 추가