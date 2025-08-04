#!/bin/bash

# Congo 테마 업데이트 스크립트
# 이 스크립트는 Congo 테마의 업데이트를 확인하고 안전하게 적용합니다.

set -e

# 색상 코드 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로깅 함수
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 프로젝트 루트 디렉토리 확인
if [ ! -f "go.mod" ] || [ ! -f "theme.toml" ]; then
    error "Hugo 프로젝트 루트 디렉토리에서 실행해주세요."
    exit 1
fi

# 백업 디렉토리 생성
BACKUP_DIR="backups/congo-theme-$(date +'%Y%m%d-%H%M%S')"
mkdir -p "$BACKUP_DIR"

# 현재 테마 파일 백업
backup_theme() {
    log "현재 테마 파일을 백업하는 중..."
    
    # 백업할 디렉토리 목록
    BACKUP_ITEMS=(
        "assets"
        "layouts"
        "i18n"
        "data"
        "static"
        "config"
        "theme.toml"
        "go.mod"
        "go.sum"
        "package.json"
        "package-lock.json"
    )
    
    for item in "${BACKUP_ITEMS[@]}"; do
        if [ -e "$item" ]; then
            cp -r "$item" "$BACKUP_DIR/"
            log "백업: $item"
        fi
    done
    
    # 백업 정보 파일 생성
    cat > "$BACKUP_DIR/backup-info.txt" << EOF
백업 날짜: $(date)
Congo 테마 버전: $(grep 'module github.com/jpanther/congo' go.mod | awk '{print $2}')
백업 이유: 테마 업데이트 전 백업
EOF
    
    success "백업이 완료되었습니다: $BACKUP_DIR"
}

# 원격 저장소에서 최신 버전 확인
check_latest_version() {
    log "Congo 테마의 최신 버전을 확인하는 중..."
    
    # GitHub API를 사용하여 최신 릴리스 확인
    LATEST_VERSION=$(curl -s https://api.github.com/repos/jpanther/congo/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$LATEST_VERSION" ]; then
        error "최신 버전을 확인할 수 없습니다."
        exit 1
    fi
    
    # 현재 버전 확인
    CURRENT_VERSION=$(grep 'module github.com/jpanther/congo' go.mod | awk '{print $2}' | sed 's/v//')
    
    log "현재 버전: v$CURRENT_VERSION"
    log "최신 버전: $LATEST_VERSION"
    
    if [ "$LATEST_VERSION" = "v$CURRENT_VERSION" ]; then
        success "이미 최신 버전을 사용하고 있습니다."
        exit 0
    fi
}

# 업데이트 다운로드 및 적용
download_and_apply_update() {
    log "Congo 테마 업데이트를 다운로드하는 중..."
    
    # 임시 디렉토리 생성
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # 최신 버전 다운로드
    wget -q "https://github.com/jpanther/congo/archive/refs/tags/$LATEST_VERSION.tar.gz" -O congo.tar.gz
    
    if [ $? -ne 0 ]; then
        error "업데이트 다운로드에 실패했습니다."
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    # 압축 해제
    tar -xzf congo.tar.gz
    cd -
    
    log "업데이트를 적용하는 중..."
    
    # 업데이트 적용 (기존 파일 덮어쓰기)
    UPDATE_DIR="$TEMP_DIR/congo-${LATEST_VERSION#v}"
    
    # 테마 파일 복사
    cp -r "$UPDATE_DIR/assets"/* assets/ 2>/dev/null || true
    cp -r "$UPDATE_DIR/layouts"/* layouts/ 2>/dev/null || true
    cp -r "$UPDATE_DIR/i18n"/* i18n/ 2>/dev/null || true
    cp -r "$UPDATE_DIR/data"/* data/ 2>/dev/null || true
    cp -r "$UPDATE_DIR/static"/* static/ 2>/dev/null || true
    
    # 설정 파일 업데이트 (주의: 사용자 설정을 덮어쓰지 않도록 별도 처리)
    if [ -d "$UPDATE_DIR/exampleSite/config" ]; then
        warning "새로운 설정 예제가 있습니다. config/congo-updates 디렉토리를 확인하세요."
        mkdir -p config/congo-updates
        cp -r "$UPDATE_DIR/exampleSite/config"/* config/congo-updates/ 2>/dev/null || true
    fi
    
    # theme.toml 업데이트
    cp "$UPDATE_DIR/theme.toml" theme.toml
    
    # package.json 업데이트 (dependencies만)
    if [ -f "$UPDATE_DIR/package.json" ]; then
        log "package.json dependencies를 업데이트하는 중..."
        # 여기서는 수동으로 확인하도록 안내
        warning "package.json이 업데이트되었습니다. 'npm install'을 실행해주세요."
    fi
    
    # 정리
    rm -rf "$TEMP_DIR"
    
    success "Congo 테마가 $LATEST_VERSION으로 업데이트되었습니다!"
}

# Hugo 모듈 업데이트 (Fork 방식 지원)
update_hugo_modules() {
    log "Hugo 설정을 업데이트하는 중..."
    
    # Fork 방식인지 모듈 방식인지 확인
    if grep -q "github.com/jpanther/congo" go.mod 2>/dev/null; then
        # 모듈 방식
        log "Hugo 모듈 방식으로 설정되어 있습니다."
        
        # go.mod 파일 업데이트
        sed -i.bak "s|github.com/jpanther/congo/v[0-9]*|github.com/jpanther/congo/${LATEST_VERSION}|g" go.mod
        rm go.mod.bak
        
        # Hugo 모듈 업데이트
        hugo mod get -u
        hugo mod tidy
    else
        # Fork 방식
        log "Fork 방식으로 설정되어 있습니다."
        
        # go.mod가 프로젝트 모듈로 설정되어 있는지 확인
        if [ ! -f "go.mod" ]; then
            log "go.mod 파일을 생성하는 중..."
            echo "module github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')" > go.mod
            echo "" >> go.mod
            echo "go 1.21" >> go.mod
        fi
        
        # npm 의존성 업데이트 메시지
        if [ -f "package.json" ]; then
            warning "package.json이 업데이트되었습니다. 'npm install'을 실행해주세요."
        fi
    fi
    
    success "설정이 업데이트되었습니다."
}

# 업데이트 후 검증
verify_update() {
    log "업데이트를 검증하는 중..."
    
    # Hugo 빌드 테스트
    hugo --gc --minify --buildDrafts --buildFuture --destination public-test > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        success "Hugo 빌드 테스트가 성공했습니다."
        rm -rf public-test
    else
        error "Hugo 빌드 테스트가 실패했습니다. 백업에서 복원할 수 있습니다."
        echo "복원 명령: ./rollback-congo-theme.sh $BACKUP_DIR"
        exit 1
    fi
}

# 롤백 스크립트 생성
create_rollback_script() {
    cat > rollback-congo-theme.sh << 'EOF'
#!/bin/bash

# Congo 테마 롤백 스크립트

if [ -z "$1" ]; then
    echo "사용법: $0 <백업_디렉토리>"
    echo "예시: $0 backups/congo-theme-20240101-120000"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "백업 디렉토리를 찾을 수 없습니다: $BACKUP_DIR"
    exit 1
fi

echo "백업에서 복원하는 중: $BACKUP_DIR"

# 백업 파일 복원
cp -r "$BACKUP_DIR"/* .

echo "복원이 완료되었습니다."
echo "Hugo 모듈을 재설치하는 중..."

hugo mod get -u
hugo mod tidy

echo "롤백이 완료되었습니다."
EOF

    chmod +x rollback-congo-theme.sh
    log "롤백 스크립트가 생성되었습니다: rollback-congo-theme.sh"
}

# 메인 실행 흐름
main() {
    echo "========================================="
    echo "       Congo 테마 업데이트 스크립트"
    echo "========================================="
    echo ""
    
    # 1. 현재 테마 백업
    backup_theme
    
    # 2. 최신 버전 확인
    check_latest_version
    
    # 3. 사용자 확인
    echo ""
    read -p "업데이트를 진행하시겠습니까? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        warning "업데이트가 취소되었습니다."
        exit 0
    fi
    
    # 4. 업데이트 다운로드 및 적용
    download_and_apply_update
    
    # 5. Hugo 모듈 업데이트
    update_hugo_modules
    
    # 6. 업데이트 검증
    verify_update
    
    # 7. 롤백 스크립트 생성
    create_rollback_script
    
    echo ""
    echo "========================================="
    success "Congo 테마 업데이트가 완료되었습니다!"
    echo "========================================="
    echo ""
    echo "다음 단계:"
    echo "1. 'npm install'을 실행하여 JavaScript 의존성을 업데이트하세요."
    echo "2. 'hugo server'로 로컬에서 사이트를 확인하세요."
    echo "3. config/congo-updates 디렉토리에서 새로운 설정 옵션을 확인하세요."
    echo "4. 문제가 발생하면 './rollback-congo-theme.sh $BACKUP_DIR'로 롤백하세요."
    echo ""
}

# 스크립트 실행
main