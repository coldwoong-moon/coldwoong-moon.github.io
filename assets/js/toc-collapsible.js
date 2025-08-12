document.addEventListener('DOMContentLoaded', function() {
  function initTocCollapsible() {
    const tocElement = document.querySelector('.toc');
    if (!tocElement) return;

    const tocContent = tocElement.querySelector('div');
    if (!tocContent) return;

    // ToC 항목들 찾기 (모든 레벨의 a 태그들)
    const tocLinks = tocContent.querySelectorAll('a');
    
    // 6개 이하면 접기/더보기 기능 비활성화
    if (tocLinks.length <= 6) return;

    // 모바일 체크 함수
    function isMobile() {
      return window.innerWidth < 1024; // lg 브레이크포인트
    }

    // 토글 버튼 생성
    function createToggleButton() {
      const button = document.createElement('button');
      button.className = 'toc-toggle-btn mt-2 text-sm text-neutral-600 hover:text-neutral-800 dark:text-neutral-400 dark:hover:text-neutral-200 flex items-center gap-1 transition-colors';
      button.innerHTML = `
        <span class="toc-toggle-text">더보기</span>
        <svg class="toc-toggle-icon w-3 h-3 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
        </svg>
      `;
      return button;
    }

    let toggleButton = null;
    let isExpanded = false;

    function setupCollapsible() {
      if (!isMobile()) {
        // 데스크톱: 토글 기능 제거
        if (toggleButton) {
          toggleButton.remove();
          toggleButton = null;
        }
        tocContent.classList.remove('toc-collapsible', 'toc-expanded');
        return;
      }

      // 모바일: 토글 기능 추가
      if (!toggleButton) {
        toggleButton = createToggleButton();
        tocElement.appendChild(toggleButton);

        toggleButton.addEventListener('click', function(e) {
          e.preventDefault();
          isExpanded = !isExpanded;
          
          if (isExpanded) {
            tocContent.classList.add('toc-expanded');
            toggleButton.querySelector('.toc-toggle-text').textContent = '접기';
            toggleButton.querySelector('.toc-toggle-icon').style.transform = 'rotate(180deg)';
            toggleButton.setAttribute('aria-expanded', 'true');
          } else {
            tocContent.classList.remove('toc-expanded');
            toggleButton.querySelector('.toc-toggle-text').textContent = '더보기';
            toggleButton.querySelector('.toc-toggle-icon').style.transform = 'rotate(0deg)';
            toggleButton.setAttribute('aria-expanded', 'false');
          }
        });
      }

      // 초기 상태 강제 설정: 접기 상태
      isExpanded = false;
      tocContent.classList.add('toc-collapsible');
      tocContent.classList.remove('toc-expanded');
      
      // 버튼 초기 상태 설정
      if (toggleButton) {
        toggleButton.querySelector('.toc-toggle-text').textContent = '더보기';
        toggleButton.querySelector('.toc-toggle-icon').style.transform = 'rotate(0deg)';
        toggleButton.setAttribute('aria-expanded', 'false');
      }
    }

    // 리사이즈 이벤트 처리 (디바운싱)
    let resizeTimer;
    function handleResize() {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(setupCollapsible, 250);
    }

    // 초기 설정
    setupCollapsible();

    // 리사이즈 이벤트 리스너
    window.addEventListener('resize', handleResize);
  }

  // ToC 초기화
  initTocCollapsible();
});