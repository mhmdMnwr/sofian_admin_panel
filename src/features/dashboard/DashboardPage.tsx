import React from 'react';
import { useTranslation } from 'react-i18next';
import { useAppDispatch, useAppSelector } from '../../core/hooks/reduxHooks';
import { logout, selectCurrentUser } from '../../core/store/slices/authSlice';
import './DashboardPage.css';

const DashboardPage: React.FC = () => {
  const { t } = useTranslation();
  const dispatch = useAppDispatch();
  const user = useAppSelector(selectCurrentUser);

  const handleLogout = () => {
    dispatch(logout());
  };

  return (
    <div className="dashboard-page">
      <div className="dashboard-header">
        <h1>{t('dashboard.title')}</h1>
        <button onClick={handleLogout} className="logout-button">
          {t('auth.logout')}
        </button>
      </div>
      <div className="dashboard-content">
        <p>{t('dashboard.welcome', { name: user?.firstName || 'User' })}</p>
      </div>
    </div>
  );
};

export default DashboardPage;
