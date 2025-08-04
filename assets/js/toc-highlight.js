// ToC Active Section Highlighting with Smooth Scroll
document.addEventListener('DOMContentLoaded', function() {
  // ToC 요소 찾기
  const tocElement = document.querySelector('.toc');
  if (!tocElement) return;
  
  // ToC 내의 모든 링크 가져오기
  const tocLinks = tocElement.querySelectorAll('a');
  if (tocLinks.length === 0) return;
  
  // 각 링크에 해당하는 섹션 헤딩 수집
  const sections = [];
  tocLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href && href.startsWith('#')) {
      // URL 디코딩 처리
      const decodedHref = decodeURIComponent(href);
      let target;
      
      // 먼저 디코딩된 ID로 찾아보고, 없으면 원본으로 시도
      try {
        target = document.querySelector(decodedHref) || document.querySelector(href);
      } catch (e) {
        // CSS selector 에러 처리 (특수문자 등)
        target = document.getElementById(decodedHref.substring(1)) || document.getElementById(href.substring(1));
      }
      
      if (target) {
        sections.push({
          link: link,
          target: target
        });
      }
    }
  });
  
  // ToC 링크 클릭 시 부드러운 스크롤
  tocLinks.forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      const href = this.getAttribute('href');
      if (href && href.startsWith('#')) {
        const decodedHref = decodeURIComponent(href);
        let target;
        
        try {
          target = document.querySelector(decodedHref) || document.querySelector(href);
        } catch (e) {
          target = document.getElementById(decodedHref.substring(1)) || document.getElementById(href.substring(1));
        }
        
        if (target) {
          // 헤더 높이 고려한 스크롤 위치
          const headerOffset = 80;
          const elementPosition = target.getBoundingClientRect().top;
          const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
          
          window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
          });
          
          // URL 해시 업데이트 (히스토리 유지)
          history.pushState(null, null, href);
        }
      }
    });
  });
  
  // Intersection Observer로 현재 보이는 섹션 감지
  const observerOptions = {
    rootMargin: '-20% 0px -70% 0px'
  };
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      const section = sections.find(s => s.target === entry.target);
      if (section) {
        if (entry.isIntersecting) {
          // 모든 링크와 헤더에서 active 클래스 제거
          tocLinks.forEach(l => l.classList.remove('toc-active'));
          sections.forEach(s => s.target.classList.remove('heading-active'));
          
          // 현재 섹션 링크와 헤더에 active 클래스 추가
          section.link.classList.add('toc-active');
          section.target.classList.add('heading-active');
        }
      }
    });
  }, observerOptions);
  
  // 모든 섹션 관찰 시작
  sections.forEach(section => {
    observer.observe(section.target);
  });
});