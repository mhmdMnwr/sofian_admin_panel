import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { FiUser, FiLock, FiEye, FiEyeOff } from 'react-icons/fi';
import { useAppDispatch, useAppSelector } from '../../core/hooks/reduxHooks';
import { login, clearError, setAuthenticated, selectAuthError, selectAuthErrorMessage, selectAuthLoading } from '../../core/store/slices/authSlice';
import { ErrorCode } from '../../core/utils/errorHandler';
import { logo } from '../../assets';
import './LoginPage.css';

// Sun icon for light mode
const SunIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <circle cx="12" cy="12" r="5" />
    <line x1="12" y1="1" x2="12" y2="3" />
    <line x1="12" y1="21" x2="12" y2="23" />
    <line x1="4.22" y1="4.22" x2="5.64" y2="5.64" />
    <line x1="18.36" y1="18.36" x2="19.78" y2="19.78" />
    <line x1="1" y1="12" x2="3" y2="12" />
    <line x1="21" y1="12" x2="23" y2="12" />
    <line x1="4.22" y1="19.78" x2="5.64" y2="18.36" />
    <line x1="18.36" y1="5.64" x2="19.78" y2="4.22" />
  </svg>
);

// Moon icon for dark mode
const MoonIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
  </svg>
);

// Globe icon for language
const GlobeIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
    <circle cx="12" cy="12" r="10" />
    <line x1="2" y1="12" x2="22" y2="12" />
    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
  </svg>
);

interface Language {
  code: string;
  name: string;
  flag: string;
}

const languages: Language[] = [
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'ar', name: 'العربية', flag: '🇸🇦' },
];

const LoginPage: React.FC = () => {
  const { t, i18n } = useTranslation();
  const navigate = useNavigate();
  const dispatch = useAppDispatch();
  const isLoading = useAppSelector(selectAuthLoading);
  const error = useAppSelector(selectAuthError);
  const errorMessage = useAppSelector(selectAuthErrorMessage);

  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errors, setErrors] = useState({ username: '', password: '' });
  
  // Theme state
  const [isDarkMode, setIsDarkMode] = useState(() => {
    const saved = localStorage.getItem('theme');
    return saved === 'dark';
  });
  
  // Language dropdown state
  const [isLangDropdownOpen, setIsLangDropdownOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Apply theme on mount and change
  useEffect(() => {
    if (isDarkMode) {
      document.documentElement.setAttribute('data-theme', 'dark');
      localStorage.setItem('theme', 'dark');
    } else {
      document.documentElement.removeAttribute('data-theme');
      localStorage.setItem('theme', 'light');
    }
  }, [isDarkMode]);

  // Close dropdown when clicking outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsLangDropdownOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
  };

  const changeLanguage = (langCode: string) => {
    i18n.changeLanguage(langCode);
    setIsLangDropdownOpen(false);
    
    // Set RTL for Arabic
    if (langCode === 'ar') {
      document.documentElement.setAttribute('dir', 'rtl');
    } else {
      document.documentElement.setAttribute('dir', 'ltr');
    }
  };

  const currentLanguage = languages.find((lang) => lang.code === i18n.language) || languages[0];

  const validate = (): boolean => {
    const newErrors = { username: '', password: '' };
    if (!username.trim()) newErrors.username = t('validation.usernameRequired');
    else if (username.trim().length < 3) newErrors.username = t('validation.usernameMinLength', { min: 3 });
    if (!password) newErrors.password = t('validation.passwordRequired');
    else if (password.length < 6) newErrors.password = t('validation.passwordMinLength', { min: 6 });
    setErrors(newErrors);
    return !newErrors.username && !newErrors.password;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    try {
      await dispatch(login({ username: username.trim(), password })).unwrap();
      // Only set authenticated and navigate after successful login
      dispatch(setAuthenticated(true));
      navigate('/dashboard');
    } catch (err) {
      // Error is handled by Redux - stay on login page
    }
  };

  const handleInputChange = (field: 'username' | 'password', value: string) => {
    if (field === 'username') setUsername(value);
    else setPassword(value);
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: '' }));
    if (error) dispatch(clearError());
  };

  // Get translated error message
  const getTranslatedError = () => {
    // Check if we have any error
    if (!error && !errorMessage) return null;
    
    // Get the error code - could be from error object or default to unknown
    const errorCode = error?.code || ErrorCode.UNKNOWN_ERROR;
    // Get the fallback message
    const fallbackMessage = errorMessage || error?.message || 'An error occurred';
    
    switch (errorCode) {
      case ErrorCode.USER_NOT_FOUND:
        return t('errors.userNotFound', fallbackMessage);
      case ErrorCode.USER_INACTIVE:
        return t('errors.userInactive', fallbackMessage);
      case ErrorCode.INVALID_CREDENTIALS:
        return t('errors.invalidCredentials', fallbackMessage);
      case ErrorCode.NETWORK_ERROR:
        return t('errors.networkError', fallbackMessage);
      case ErrorCode.TIMEOUT_ERROR:
        return t('errors.timeoutError', fallbackMessage);
      case ErrorCode.MISSING_FIELDS:
        return t('errors.missingFields', fallbackMessage);
      default:
        // For unknown errors, show the actual error message from the server
        return t('errors.unknownError', fallbackMessage);
    }
  };

  const translatedError = getTranslatedError();

  return (
    <div className="login-page">
      {/* Settings buttons in top right */}
      <div className="login-settings">
        {/* Theme Toggle */}
        <button
          className="login-settings__btn"
          onClick={toggleTheme}
          title={isDarkMode ? t('common.lightMode', 'Light Mode') : t('common.darkMode', 'Dark Mode')}
        >
          {isDarkMode ? <SunIcon /> : <MoonIcon />}
        </button>

        {/* Language Dropdown */}
        <div className="login-lang-dropdown" ref={dropdownRef}>
          <button
            className="login-settings__btn"
            onClick={() => setIsLangDropdownOpen(!isLangDropdownOpen)}
            title={t('common.changeLanguage', 'Change Language')}
          >
            <GlobeIcon />
            <span className="login-lang-code">{currentLanguage.code.toUpperCase()}</span>
          </button>
          
          {isLangDropdownOpen && (
            <div className="login-lang-menu">
              {languages.map((lang) => (
                <button
                  key={lang.code}
                  className={`login-lang-item ${lang.code === i18n.language ? 'active' : ''}`}
                  onClick={() => changeLanguage(lang.code)}
                >
                  <span className="login-lang-flag">{lang.flag}</span>
                  <span className="login-lang-name">{lang.name}</span>
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="login-card">
        {/* Logo */}
        <div className="login-logo">
          <img src={logo} alt="Bouchfoof Logo" />
        </div>

        {/* Welcome Text */}
        <h1 className="login-title">{t('auth.welcomeBack', 'Welcome Back')}</h1>

        {/* Error Display */}
        {translatedError && (
          <div className="login-error">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="8" x2="12" y2="12"></line>
              <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <span>{translatedError}</span>
          </div>
        )}

        {/* Login Form */}
        <form onSubmit={handleSubmit} className="login-form">
          <div className="login-field">
            <div className="login-input-wrapper">
              <span className="login-input-icon">
                {React.createElement(FiUser as any, {})}
              </span>
              <input
                type="text"
                value={username}
                onChange={(e) => handleInputChange('username', e.target.value)}
                className={`login-input ${errors.username ? 'error' : ''}`}
                placeholder={t('auth.username', 'User Name')}
              />
            </div>
            {errors.username && <p className="login-field-error">{errors.username}</p>}
          </div>

          <div className="login-field">
            <div className="login-input-wrapper">
              <span className="login-input-icon">
                {React.createElement(FiLock as any, {})}
              </span>
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => handleInputChange('password', e.target.value)}
                className={`login-input ${errors.password ? 'error' : ''}`}
                placeholder={t('auth.password', 'Password')}
              />
              <button
                type="button"
                className="login-password-toggle"
                onClick={() => setShowPassword(!showPassword)}
              >
                {showPassword 
                  ? React.createElement(FiEyeOff as any, {}) 
                  : React.createElement(FiEye as any, {})}
              </button>
            </div>
            {errors.password && <p className="login-field-error">{errors.password}</p>}
          </div>

          <button type="submit" className="login-submit" disabled={isLoading}>
            {isLoading ? (
              <span className="login-loading">
                <span className="login-spinner"></span>
              </span>
            ) : (
              t('auth.logIn', 'Log In')
            )}
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
