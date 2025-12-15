// Initialize Bootstrap dropdowns - webpack bundle doesn't expose bootstrap globally
(function() {
  function initDropdowns() {
    document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(function(trigger) {
      if (!trigger.dataset.initialized) {
        trigger.dataset.initialized = 'true';
        trigger.addEventListener('click', function(e) {
          e.preventDefault();
          e.stopPropagation();
          var dropdown = trigger.closest('.dropdown');
          var menu = dropdown.querySelector('.dropdown-menu');
          var isOpen = menu.classList.contains('show');
          
          // Close all other dropdowns
          document.querySelectorAll('.dropdown-menu.show').forEach(function(m) {
            if (m !== menu) {
              m.classList.remove('show');
              var t = m.closest('.dropdown').querySelector('[data-bs-toggle="dropdown"]');
              if (t) t.setAttribute('aria-expanded', 'false');
            }
          });
          
          // Toggle current dropdown
          menu.classList.toggle('show');
          trigger.setAttribute('aria-expanded', menu.classList.contains('show'));
        });
      }
    });
  }
  
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDropdowns);
  } else {
    initDropdowns();
  }
  
  // Handle Turbo navigation
  if (typeof Turbo !== 'undefined') {
    document.addEventListener('turbo:load', initDropdowns);
  }
  
  // Close dropdowns when clicking outside
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.dropdown')) {
      document.querySelectorAll('.dropdown-menu.show').forEach(function(menu) {
        menu.classList.remove('show');
        var trigger = menu.closest('.dropdown').querySelector('[data-bs-toggle="dropdown"]');
        if (trigger) trigger.setAttribute('aria-expanded', 'false');
      });
    }
  });
})();

