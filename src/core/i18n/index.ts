import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import HttpBackend from 'i18next-http-backend';

// Supported languages
export const SUPPORTED_LANGUAGES = [
  { code: 'en', name: 'English', dir: 'ltr' },
  { code: 'fr', name: 'Français', dir: 'ltr' },
  { code: 'ar', name: 'العربية', dir: 'rtl' },
] as const;

export type LanguageCode = typeof SUPPORTED_LANGUAGES[number]['code'];

// Get language direction
export const getLanguageDirection = (lang: string): 'ltr' | 'rtl' => {
  const language = SUPPORTED_LANGUAGES.find(l => l.code === lang);
  return language?.dir || 'ltr';
};

// Initialize i18n
i18n
  .use(HttpBackend)
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    // Default language
    fallbackLng: 'en',
    
    // Supported languages
    supportedLngs: SUPPORTED_LANGUAGES.map(l => l.code),
    
    // Debug mode (disable in production)
    debug: process.env.NODE_ENV === 'development',
    
    // Namespace configuration
    ns: ['translation'],
    defaultNS: 'translation',
    
    // Backend configuration for loading translations
    backend: {
      loadPath: '/locales/{{lng}}/{{ns}}.json',
    },
    
    // Language detection configuration
    detection: {
      order: ['localStorage', 'navigator', 'htmlTag'],
      caches: ['localStorage'],
      lookupLocalStorage: 'i18nextLng',
    },
    
    // Interpolation configuration
    interpolation: {
      escapeValue: false, // React already escapes values
    },
    
    // React configuration
    react: {
      useSuspense: false, // Don't use Suspense to avoid blank page flashes
    },
  });

// Update document direction when language changes
i18n.on('languageChanged', (lng) => {
  const dir = getLanguageDirection(lng);
  document.documentElement.dir = dir;
  document.documentElement.lang = lng;
});

export default i18n;
