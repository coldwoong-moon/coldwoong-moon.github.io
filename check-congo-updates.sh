#!/bin/bash

# Congo 테마 업데이트 확인 전용 스크립트
# 실제 업데이트 없이 업데이트 가능 여부만 확인합니다.

set -e

# 색상 코드 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로깅 함수
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

# 현재 버전 확인
get_current_version() {
    if grep -q "github.com/jpanther/congo" go.mod; then
        CURRENT_VERSION=$(grep 'github.com/jpanther/congo' go.mod | awk '{print $2}' | sed 's/v//')
    else
        CURRENT_VERSION="unknown"
    fi
}

# 원격 저장소에서 최신 버전 확인
get_latest_version() {
    log "Congo 테마의 최신 버전을 확인하는 중..."
    
    # GitHub API를 사용하여 최신 릴리스 확인
    LATEST_VERSION=$(curl -s https://api.github.com/repos/jpanther/congo/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')
    
    if [ -z "$LATEST_VERSION" ]; then
        error "최신 버전을 확인할 수 없습니다. 인터넷 연결을 확인해주세요."
        exit 1
    fi
}

# 릴리스 노트 가져오기
get_release_notes() {
    log "릴리스 노트를 가져오는 중..."
    
    RELEASE_NOTES=$(curl -s https://api.github.com/repos/jpanther/congo/releases/latest | grep '"body":' | sed -E 's/.*"body": *"([^"]+)".*/\1/' | sed 's/\\n/\n/g' | sed 's/\\r//g')
    
    if [ -z "$RELEASE_NOTES" ]; then
        warning "릴리스 노트를 가져올 수 없습니다."
        RELEASE_NOTES="릴리스 노트를 사용할 수 없습니다."
    fi
}

# 의존성 확인
check_dependencies() {
    log "필수 의존성을 확인하는 중..."
    
    # Hugo 설치 확인
    if ! command -v hugo &> /dev/null; then
        error "Hugo가 설치되어 있지 않습니다."
        echo "Hugo 설치: https://gohugo.io/getting-started/installing/"
        return 1
    fi
    
    # Go 설치 확인
    if ! command -v go &> /dev/null; then
        error "Go가 설치되어 있지 않습니다."
        echo "Go 설치: https://golang.org/doc/install"
        return 1
    fi
    
    # curl 설치 확인
    if ! command -v curl &> /dev/null; then
        error "curl이 설치되어 있지 않습니다."
        return 1
    fi
    
    success "모든 필수 의존성이 확인되었습니다."
    return 0
}

# 버전 비교
version_compare() {
    if [ "$1" = "$2" ]; then
        return 0  # 같음
    fi
    
    # 버전 문자열을 숫자로 변환하여 비교
    local ver1=$(echo "$1" | sed 's/[^0-9.]*//g')
    local ver2=$(echo "$2" | sed 's/[^0-9.]*//g')
    
    # 간단한 버전 비교 (더 정확한 비교를 위해서는 별도 함수 필요)
    if [ "$ver1" \< "$ver2" ]; then
        return 1  # 첫 번째가 더 낮음
    else
        return 2  # 첫 번째가 더 높거나 같음
    fi
}

# 메인 함수
main() {
    echo "========================================="
    echo "      Congo 테마 업데이트 확인"
    echo "========================================="
    echo ""
    
    # 의존성 확인
    if ! check_dependencies; then
        exit 1
    fi
    
    # 현재 버전 확인
    get_current_version
    
    # 최신 버전 확인
    get_latest_version
    
    # 릴리스 노트 가져오기
    get_release_notes
    
    # 결과 출력
    echo ""
    echo "========================================="
    echo "              버전 정보"
    echo "========================================="
    echo "현재 버전: v$CURRENT_VERSION"
    echo "최신 버전: v$LATEST_VERSION"
    echo ""
    
    # 버전 비교
    version_compare "$CURRENT_VERSION" "$LATEST_VERSION"
    case $? in
        0)
            success "이미 최신 버전을 사용하고 있습니다!"
            echo ""
            echo "업데이트가 필요하지 않습니다."
            ;;
        1) 
            warning "새로운 버전이 있습니다!"
            echo ""
            echo "========================================="
            echo "              릴리스 노트"
            echo "========================================="
            echo "$RELEASE_NOTES"
            echo ""
            echo "========================================="
            echo "              업데이트 안내"
            echo "========================================="
            echo "업데이트를 적용하려면 다음 명령을 실행하세요:"
            echo "  ./update-congo-theme.sh"
            echo ""
            echo "업데이트 전에 다음을 확인하세요:"
            echo "  1. 중요한 작업을 커밋했는지 확인"
            echo "  2. 로컬 백업이 있는지 확인"
            echo "  3. 충분한 시간이 있는지 확인"
            ;;
        2)
            warning "현재 버전이 공식 릴리스보다 높습니다."
            echo ""
            echo "개발 버전을 사용 중이거나 버전 정보에 오류가 있을 수 있습니다."
            ;;
    esac
    
    echo ""
    echo "========================================="
    echo "              시스템 정보"
    echo "========================================="
    echo "Hugo 버전: $(hugo version 2>/dev/null || echo 'Hugo 버전을 확인할 수 없습니다.')"
    echo "Go 버전: $(go version 2>/dev/null || echo 'Go 버전을 확인할 수 없습니다.')"
    echo "Git 버전: $(git --version 2>/dev/null || echo 'Git 버전을 확인할 수 없습니다.')"
    echo ""
}

# 스크립트 실행
main