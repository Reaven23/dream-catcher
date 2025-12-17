// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

// Register service worker for PWA
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service-worker')
    .then(reg => console.log('Service worker registered:', reg.scope))
    .catch(err => console.error('Service worker registration failed:', err));
}
