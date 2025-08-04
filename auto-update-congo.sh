#!/bin/bash

# Congo 테마 자동 업데이트 스크립트
# 정기적으로 실행하여 자동으로 업데이트를 확인하고 적용할 수 있습니다.
# 주의: 자동 업데이트는 신중하게 사용하세요.

set -e

# 색상 코드 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 설정
AUTO_APPLY=${1:-false}  # 첫 번째 인수가 'true'이면 자동 적용
LOG_FILE="congo-update.log"

# 로깅 함수
log() {
    local message="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    echo -e "${BLUE}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

error() {
    local message="[ERROR] $1"
    echo -e "${RED}$message${NC}" >&2
    echo "$message" >> "$LOG_FILE"
}

success() {
    local message="[SUCCESS] $1"
    echo -e "${GREEN}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

warning() {
    local message="[WARNING] $1"
    echo -e "${YELLOW}$message${NC}"
    echo "$message" >> "$LOG_FILE"
}

# 업데이트 확인
check_for_updates() {
    log "자동 업데이트 확인을 시작합니다..."
    
    # check-congo-updates.sh 스크립트 실행
    if [ -f "check-congo-updates.sh" ]; then
        # 스크립트의 출력을 캡처하여 로그 파일에도 기록
        ./check-congo-updates.sh | tee -a "$LOG_FILE"
        
        # 업데이트가 필요한지 확인 (간단한 방법)
        if ./check-congo-updates.sh | grep -q "새로운 버전이 있습니다"; then
            return 0  # 업데이트 필요
        else
            return 1  # 업데이트 불필요
        fi
    else
        error "check-congo-updates.sh 스크립트를 찾을 수 없습니다."
        return 1
    fi
}

# 자동 업데이트 적용
apply_auto_update() {
    log "자동 업데이트를 적용합니다..."
    
    if [ -f "update-congo-theme.sh" ]; then
        # 업데이트 스크립트를 자동으로 실행 (사용자 입력 없이)
        echo "y" | ./update-congo-theme.sh >> "$LOG_FILE" 2>&1
        
        if [ $? -eq 0 ]; then
            success "자동 업데이트가 성공적으로 완료되었습니다."
            
            # 선택사항: 자동으로 커밋
            if git status --porcelain | grep -q .; then
                log "변경사항을 자동으로 커밋합니다..."
                git add -A
                git commit -m "feat: Congo 테마 자동 업데이트 - $(date +'%Y-%m-%d %H:%M:%S')"
                success "변경사항이 커밋되었습니다."
            fi
            
            return 0
        else
            error "자동 업데이트가 실패했습니다."
            return 1
        fi
    else
        error "update-congo-theme.sh 스크립트를 찾을 수 없습니다."
        return 1
    fi
}

# 알림 전송 (선택사항)
send_notification() {
    local message="$1"
    
    # macOS 알림
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"Congo 테마 업데이트\""
    fi
    
    # Linux 알림 (notify-send가 있는 경우)
    if command -v notify-send &> /dev/null; then
        notify-send "Congo 테마 업데이트" "$message"
    fi
    
    log "알림: $message"
}

# 메인 함수
main() {
    echo "========================================="
    echo "       Congo 테마 자동 업데이트"
    echo "========================================="
    echo ""
    echo "실행 시간: $(date)"
    echo "자동 적용: $AUTO_APPLY"
    echo "로그 파일: $LOG_FILE"
    echo ""
    
    # 프로젝트 디렉토리 확인
    if [ ! -f "go.mod" ] || [ ! -f "theme.toml" ]; then
        error "Hugo 프로젝트 루트 디렉토리에서 실행해주세요."
        exit 1
    fi
    
    # 업데이트 확인
    if check_for_updates; then
        warning "새로운 업데이트가 있습니다!"
        
        if [ "$AUTO_APPLY" = "true" ]; then
            # 자동 적용
            if apply_auto_update; then
                send_notification "Congo 테마가 성공적으로 업데이트되었습니다."
            else
                send_notification "Congo 테마 업데이트가 실패했습니다."
                error "자동 업데이트 실패. 수동으로 확인해주세요."
                exit 1
            fi
        else
            # 수동 확인 필요
            send_notification "Congo 테마 업데이트가 있습니다. 수동으로 적용해주세요."
            warning "자동 적용이 비활성화되어 있습니다."
            echo "업데이트를 적용하려면 다음을 실행하세요:"
            echo "  ./update-congo-theme.sh"
        fi
    else
        success "이미 최신 버전을 사용하고 있습니다."
        log "업데이트가 필요하지 않습니다."
    fi
    
    echo ""
    echo "자동 업데이트 확인이 완료되었습니다."
    echo "자세한 로그는 $LOG_FILE을 확인하세요."
}

# 사용법 출력
show_usage() {
    echo "사용법: $0 [true|false]"
    echo ""
    echo "인수:"
    echo "  true   - 업데이트가 있을 경우 자동으로 적용"
    echo "  false  - 업데이트 확인만 하고 수동 적용 (기본값)"
    echo ""
    echo "예시:"
    echo "  $0          # 확인만"
    echo "  $0 false    # 확인만"
    echo "  $0 true     # 자동 적용"
    echo ""
    echo "크론탭 설정 예시 (매일 오전 9시):"
    echo "  0 9 * * * cd /path/to/your/blog && ./auto-update-congo.sh false"
    echo ""
    echo "주의사항:"
    echo "  - 자동 적용(true)은 신중하게 사용하세요."
    echo "  - 중요한 작업 전에는 수동으로 백업하세요."
    echo "  - 로그 파일을 정기적으로 확인하세요."
}

# 인수 처리
case "${1:-}" in
    -h|--help)
        show_usage
        exit 0
        ;;
    true|false|"")
        main
        ;;
    *)
        error "잘못된 인수입니다: $1"
        show_usage
        exit 1
        ;;
esac