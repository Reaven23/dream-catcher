// Service Worker for DreamCatcher PWA

const CACHE_NAME = 'dreamcatcher-v1';

// Install event
self.addEventListener('install', (event) => {
  console.log('[SW] Installing...');
  self.skipWaiting();
});

// Activate event
self.addEventListener('activate', (event) => {
  console.log('[SW] Activated');
  self.clients.claim();
});

// Fetch event - required for PWA installability
self.addEventListener('fetch', (event) => {
  // Network-first strategy: try network, fall back to cache
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );
});
