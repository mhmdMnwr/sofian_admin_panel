import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { FiMail, FiLock, FiEye, FiEyeOff, FiAlertCircle, FiWifi } from 'react-icons/fi';
import { useAppDispatch, useAppSelector } from '../../core/hooks/reduxHooks';
import { login, clearError, selectAuthError, selectAuthErrorMessage, selectAuthLoading } from '../../core/store/slices/authSlice';
import { isValidEmail } from '../../core/utils/helpers';
import { ErrorCode } from '../../core/utils/errorHandler';
import './LoginPage.css';

const LoginPage: React.FC = () => {
  const { t } = useTranslation();
  const navigate = useNavigate();
  const dispatch = useAppDispatch();
  const isLoading = useAppSelector(selectAuthLoading);
  const error = useAppSelector(selectAuthError);
  const errorMessage = useAppSelector(selectAuthErrorMessage);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errors, setErrors] = useState({ email: '', password: '' });

  useEffect(() => {
    return () => { dispatch(clearError()); };
  }, [dispatch]);

  const validate = (): boolean => {
    const newErrors = { email: '', password: '' };
    if (!email.trim()) newErrors.email = t('validation.emailRequired');
    else if (!isValidEmail(email)) newErrors.email = t('validation.emailInvalid');
    if (!password) newErrors.password = t('validation.passwordRequired');
    else if (password.length < 6) newErrors.password = t('validation.passwordMinLength', { min: 6 });
    setErrors(newErrors);
    return !newErrors.email && !newErrors.password;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    try {
      await dispatch(login({ email: email.trim().toLowerCase(), password })).unwrap();
      navigate('/dashboard');
    } catch (err) {
      // Error is handled by Redux, no need for additional handling
    }
  };

  const handleInputChange = (field: 'email' | 'password', value: string) => {
    if (field === 'email') setEmail(value);
    else setPassword(value);
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: '' }));
    if (error) dispatch(clearError());
  };

  // Determine error icon and style based on error type
  const getErrorDisplay = () => {
    if (!error || !errorMessage) return null;

    const isNetworkError = error.code === ErrorCode.NETWORK_ERROR || error.code === ErrorCode.TIMEOUT_ERROR;
    const isAuthError = error.code === ErrorCode.INVALID_CREDENTIALS || error.code === ErrorCode.UNAUTHORIZED;

    return (
      <div className={`error-alert ${isNetworkError ? 'network-error' : ''} ${isAuthError ? 'auth-error' : ''}`}>
        <span className="error-icon">
          {isNetworkError 
            ? React.createElement(FiWifi as any, {})
            : React.createElement(FiAlertCircle as any, {})}
        </span>
        <div className="error-content">
          <span className="error-text">{errorMessage}</span>
          {isNetworkError && (
            <button 
              type="button" 
              className="retry-button"
              onClick={() => handleSubmit({ preventDefault: () => {} } as React.FormEvent)}
            >
              {t('common.tryAgain')}
            </button>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-header">
          <h1 className="login-title">{t('auth.login')}</h1>
          <p className="login-subtitle">{t('auth.signInToAccount')}</p>
        </div>

        {getErrorDisplay()}

        <form onSubmit={handleSubmit} className="login-form">
          <div className="form-group">
            <label htmlFor="email" className="form-label">{t('auth.email')}</label>
            <div className="input-wrapper">
              {React.createElement(FiMail as any, { className: "input-icon" })}
              <input
                type="email"
                id="email"
                value={email}
                onChange={(e) => handleInputChange('email', e.target.value)}
                className={`form-input ${errors.email ? 'error' : ''}`}
                placeholder={t('auth.enterEmail')}
              />
            </div>
            {errors.email && <p className="error-message">{errors.email}</p>}
          </div>

          <div className="form-group">
            <label htmlFor="password" className="form-label">{t('auth.password')}</label>
            <div className="input-wrapper">
              {React.createElement(FiLock as any, { className: "input-icon" })}
              <input
                type={showPassword ? 'text' : 'password'}
                id="password"
                value={password}
                onChange={(e) => handleInputChange('password', e.target.value)}
                className={`form-input ${errors.password ? 'error' : ''}`}
                placeholder={t('auth.enterPassword')}
              />
              <button
                type="button"
                className="password-toggle"
                onClick={() => setShowPassword(!showPassword)}
              >
                {showPassword 
                  ? React.createElement(FiEyeOff as any, {}) 
                  : React.createElement(FiEye as any, {})}
              </button>
            </div>
            {errors.password && <p className="error-message">{errors.password}</p>}
          </div>

          <button type="submit" className="submit-button" disabled={isLoading}>
            {isLoading ? t('auth.signingIn') : t('auth.signIn')}
          </button>
        </form>

        <div className="login-footer">
          <p>{t('common.allRightsReserved', { year: new Date().getFullYear() })}</p>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
