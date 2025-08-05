// 모바일 UI 개선 JavaScript

document.addEventListener('DOMContentLoaded', function() {
  // 1. 목차 토글 기능
  initializeTocToggle();
  
  // 2. 맨 위로 버튼 개선
  improveScrollToTop();
  
  // 3. 모바일 메뉴 일관성
  ensureMobileMenuConsistency();
});

// 목차 토글 기능 초기화
function initializeTocToggle() {
  const tocElements = document.querySelectorAll('.toc');
  
  tocElements.forEach(toc => {
    // 이미 처리된 경우 스킵
    if (toc.querySelector('.toc-toggle')) return;
    
    // 모바일에서만 토글 추가
    if (window.innerWidth <= 1023) {
      // 토글 버튼 생성
      const toggle = document.createElement('div');
      toggle.className = 'toc-toggle';
      toggle.innerHTML = '목차';
      
      // 기존 내용을 래퍼로 감싸기
      const content = document.createElement('div');
      content.className = 'toc-content';
      
      // 모든 자식 요소를 content로 이동
      while (toc.firstChild) {
        content.appendChild(toc.firstChild);
      }
      
      // 토글과 콘텐츠 추가
      toc.appendChild(toggle);
      toc.appendChild(content);
      
      // 토글 이벤트 리스너
      toggle.addEventListener('click', function() {
        toc.classList.toggle('open');
        
        // 접근성을 위한 aria 속성 추가
        const isOpen = toc.classList.contains('open');
        toggle.setAttribute('aria-expanded', isOpen);
        content.setAttribute('aria-hidden', !isOpen);
      });
      
      // 초기 aria 속성 설정
      toggle.setAttribute('aria-expanded', 'false');
      toggle.setAttribute('role', 'button');
      toggle.setAttribute('tabindex', '0');
      content.setAttribute('aria-hidden', 'true');
      
      // 키보드 접근성
      toggle.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          toggle.click();
        }
      });
    }
  });
}

// 맨 위로 버튼 개선
function improveScrollToTop() {
  const toTopButton = document.getElementById('to-top');
  if (!toTopButton) return;
  
  let lastScrollTop = 0;
  let isScrollingUp = false;
  
  // 스크롤 방향 감지 및 버튼 표시/숨김
  window.addEventListener('scroll', function() {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    
    // 스크롤 방향 감지
    isScrollingUp = scrollTop < lastScrollTop;
    lastScrollTop = scrollTop;
    
    // 페이지 상단 근처에서는 숨기기
    if (scrollTop < 300) {
      toTopButton.style.opacity = '0';
      toTopButton.style.pointerEvents = 'none';
    } else {
      toTopButton.style.opacity = '1';
      toTopButton.style.pointerEvents = 'auto';
      
      // 스크롤 다운 시 버튼 숨기기 (모바일에서)
      if (window.innerWidth <= 640) {
        if (!isScrollingUp && scrollTop > 500) {
          toTopButton.style.transform = 'translateY(100px)';
        } else {
          toTopButton.style.transform = 'translateY(0)';
        }
      }
    }
  });
  
  // 부드러운 스크롤 애니메이션
  const toTopLink = toTopButton.querySelector('a');
  if (toTopLink) {
    toTopLink.addEventListener('click', function(e) {
      e.preventDefault();
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  }
  
  // 초기 스타일 설정
  toTopButton.style.transition = 'all 0.3s ease';
  toTopButton.style.opacity = '0';
}

// 모바일 메뉴 일관성 확보
function ensureMobileMenuConsistency() {
  // 모바일 메뉴 버튼 찾기
  const mobileMenuButtons = document.querySelectorAll('.hamburger-menu, .mobile-menu-button, [aria-label*="menu"]');
  
  mobileMenuButtons.forEach(button => {
    // 일관된 스타일 클래스 추가
    if (!button.classList.contains('mobile-menu-unified')) {
      button.classList.add('mobile-menu-unified');
    }
    
    // 접근성 개선
    if (!button.getAttribute('aria-label')) {
      button.setAttribute('aria-label', '메뉴 열기');
    }
    
    // 터치 이벤트 최적화
    button.addEventListener('touchstart', function(e) {
      button.style.backgroundColor = 'rgba(0, 0, 0, 0.1)';
    });
    
    button.addEventListener('touchend', function(e) {
      setTimeout(() => {
        button.style.backgroundColor = '';
      }, 200);
    });
  });
}

// 윈도우 리사이즈 시 재초기화
let resizeTimeout;
window.addEventListener('resize', function() {
  clearTimeout(resizeTimeout);
  resizeTimeout = setTimeout(function() {
    // 데스크톱으로 전환 시 목차 토글 제거
    if (window.innerWidth > 1023) {
      const tocElements = document.querySelectorAll('.toc');
      tocElements.forEach(toc => {
        const toggle = toc.querySelector('.toc-toggle');
        const content = toc.querySelector('.toc-content');
        
        if (toggle && content) {
          // 콘텐츠의 모든 자식을 toc로 다시 이동
          while (content.firstChild) {
            toc.appendChild(content.firstChild);
          }
          // 토글과 래퍼 제거
          toggle.remove();
          content.remove();
          toc.classList.remove('open');
        }
      });
    } else {
      // 모바일로 전환 시 다시 초기화
      initializeTocToggle();
    }
  }, 250);
});

// 테이블 가로 스크롤 처리
document.addEventListener('DOMContentLoaded', function() {
  const tables = document.querySelectorAll('.prose table');
  
  tables.forEach(table => {
    // 이미 래퍼가 있는지 확인
    if (!table.parentElement.classList.contains('table-wrapper')) {
      const wrapper = document.createElement('div');
      wrapper.className = 'table-wrapper';
      table.parentNode.insertBefore(wrapper, table);
      wrapper.appendChild(table);
    }
  });
});