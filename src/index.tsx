import React, { Suspense } from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

// Initialize i18n
import './core/i18n';

const root = ReactDOM.createRoot(document.getElementById('root') as HTMLElement);
root.render(
  <React.StrictMode>
    <Suspense fallback={<div className="app-loading">Loading...</div>}>
      <App />
    </Suspense>
  </React.StrictMode>
);
