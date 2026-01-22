import React, { useState, useEffect } from 'react';
import { FiMail, FiLock, FiEye, FiEyeOff } from 'react-icons/fi';
import { useAppDispatch, useAppSelector } from '../../core/hooks/reduxHooks';
import { login, clearError } from '../../core/store/slices/authSlice';
import { isValidEmail } from '../../core/utils/helpers';
import './LoginPage.css';

const LoginPage: React.FC = () => {
  const dispatch = useAppDispatch();
  const { isLoading, error } = useAppSelector((state) => state.auth);

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errors, setErrors] = useState({ email: '', password: '' });

  useEffect(() => {
    return () => { dispatch(clearError()); };
  }, [dispatch]);

  const validate = (): boolean => {
    const newErrors = { email: '', password: '' };
    if (!email) newErrors.email = 'Email is required';
    else if (!isValidEmail(email)) newErrors.email = 'Please enter a valid email';
    if (!password) newErrors.password = 'Password is required';
    else if (password.length < 6) newErrors.password = 'Password must be at least 6 characters';
    setErrors(newErrors);
    return !newErrors.email && !newErrors.password;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    try {
      await dispatch(login({ email, password })).unwrap();
      console.log('Login successful!');
    } catch (err) {
      console.error('Login failed:', err);
    }
  };

  const handleInputChange = (field: 'email' | 'password', value: string) => {
    if (field === 'email') setEmail(value);
    else setPassword(value);
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: '' }));
    if (error) dispatch(clearError());
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-header">
          <h1 className="login-title">Login</h1>
          <p className="login-subtitle">Sign in to your account</p>
        </div>

        {error && <div className="error-alert">{error}</div>}

        <form onSubmit={handleSubmit} className="login-form">
          <div className="form-group">
            <label htmlFor="email" className="form-label">Email</label>
            <div className="input-wrapper">
              {React.createElement(FiMail as any, { className: "input-icon" })}
              <input
                type="email"
                id="email"
                value={email}
                onChange={(e) => handleInputChange('email', e.target.value)}
                className={`form-input ${errors.email ? 'error' : ''}`}
                placeholder="Enter your email"
              />
            </div>
            {errors.email && <p className="error-message">{errors.email}</p>}
          </div>

          <div className="form-group">
            <label htmlFor="password" className="form-label">Password</label>
            <div className="input-wrapper">
              {React.createElement(FiLock as any, { className: "input-icon" })}
              <input
                type={showPassword ? 'text' : 'password'}
                id="password"
                value={password}
                onChange={(e) => handleInputChange('password', e.target.value)}
                className={`form-input ${errors.password ? 'error' : ''}`}
                placeholder="Enter your password"
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
            {isLoading ? 'Signing in...' : 'Sign In'}
          </button>
        </form>

        <div className="login-footer">
          <p>© 2025 Sofian Admin Panel. All rights reserved.</p>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
