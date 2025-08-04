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
