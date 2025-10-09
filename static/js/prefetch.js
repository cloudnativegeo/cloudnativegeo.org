/**
 * Smart prefetching for faster navigation
 * Uses Speculation Rules API for modern browsers, falls back to hover prefetch
 */
document.addEventListener('DOMContentLoaded', () => {
  // Check if browser supports Speculation Rules API
  const supportsSpeculationRules = 'supports' in HTMLScriptElement && 
                                    HTMLScriptElement.supports('speculationrules');
  
  // If Speculation Rules is supported, it will handle prerendering
  // But we still add hover prefetch for links not in the speculation rules list
  const prefetchedUrls = new Set();
  
  const prefetchOnHover = (url) => {
    // Don't prefetch if already done
    if (prefetchedUrls.has(url)) return;
    
    // Mark as prefetched
    prefetchedUrls.add(url);
    
    // Create prefetch link
    const link = document.createElement('link');
    link.rel = 'prefetch';
    link.href = url;
    document.head.appendChild(link);
  };

  // Find all internal links
  const internalLinks = document.querySelectorAll('a[href^="/"]');
  
  internalLinks.forEach(link => {
    const url = link.getAttribute('href');
    
    // Skip invalid URLs, anchors, and special protocols
    if (!url || url.includes('#') || url.includes('mailto:') || url.includes('tel:')) {
      return;
    }
    
    // Add hover and focus listeners for accessibility
    link.addEventListener('mouseenter', () => prefetchOnHover(url), { passive: true });
    link.addEventListener('focus', () => prefetchOnHover(url), { passive: true });
  });
  
  // Log prefetch strategy (remove in production if desired)
  if (supportsSpeculationRules) {
    console.log('✨ Using Speculation Rules API + hover prefetch');
  } else {
    console.log('⚡ Using hover prefetch fallback');
  }
});

