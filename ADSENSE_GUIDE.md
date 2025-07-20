# Google AdSense 설정 가이드

## 1. AdSense 활성화

`config/_default/params.toml` 파일에서 AdSense 설정을 구성합니다:

```toml
[adsense]
  enable = true
  client = "ca-pub-9092255711462498"
  slot_sidebar = "1234567890"  # 사이드바 광고 슬롯 ID
  slot_article = "0987654321"  # 포스트 내 광고 슬롯 ID
  slot_list = "5678901234"     # 목록 페이지 광고 슬롯 ID
```

## 2. 광고 위치

### 자동 광고 위치
- **포스트 목록**: 3개 포스트마다 자동으로 광고 표시
- **헤더**: AdSense 스크립트 자동 로드 (활성화된 경우)

### 수동 광고 삽입

#### 포스트 내에서 shortcode 사용:
```markdown
{{< adsense >}}
```

커스텀 슬롯 ID 지정:
```markdown
{{< adsense slot="YOUR_CUSTOM_SLOT_ID" format="horizontal" >}}
```

#### 템플릿에서 partial 사용:
```html
{{ partial "adsense.html" (dict "slot" "YOUR_SLOT_ID" "format" "rectangle") }}
```

## 3. 개발 환경

로컬 개발 환경에서는 광고 대신 플레이스홀더가 표시됩니다:
- `hugo server` 실행 시 광고 위치에 `[광고 위치]` 표시
- 프로덕션 빌드에서만 실제 광고 표시

## 4. 광고 슬롯 ID 확인 방법

1. [Google AdSense](https://www.google.com/adsense/) 로그인
2. 광고 → 광고 단위
3. 새 광고 단위 생성 또는 기존 광고 단위 선택
4. 코드에서 `data-ad-slot="XXXXXXXXXX"` 값 복사

## 5. 주의사항

- AdSense 정책을 준수해야 합니다
- 과도한 광고는 사용자 경험을 해칠 수 있습니다
- 모바일 최적화를 고려하세요
- 광고 차단기 사용자를 위한 대체 콘텐츠를 고려하세요

## 6. 문제 해결

### 광고가 표시되지 않는 경우:
1. AdSense 계정이 승인되었는지 확인
2. 도메인이 AdSense에 등록되었는지 확인
3. 광고 슬롯 ID가 올바른지 확인
4. 브라우저 개발자 도구에서 콘솔 오류 확인

### 개발 환경에서 테스트:
```bash
# 프로덕션 빌드로 테스트
hugo --environment production
hugo server --environment production
```