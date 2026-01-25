import React from 'react';
import { useTranslation } from 'react-i18next';
import { useAppSelector } from '../../core/hooks/reduxHooks';
import { selectCurrentUser } from '../../core/store/slices/authSlice';
import { MainLayout } from '../../components/layout';
import './DashboardPage.css';

const DashboardPage: React.FC = () => {
  const { t } = useTranslation();
  const user = useAppSelector(selectCurrentUser);

  // Get current hour for greeting
  const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return t('dashboard.goodMorning', 'Good Morning');
    if (hour < 18) return t('dashboard.goodAfternoon', 'Good Afternoon');
    return t('dashboard.goodEvening', 'Good Evening');
  };

  return (
    <MainLayout>
      <div className="dashboard-page">
        <div className="welcome-container">
          <div className="welcome-content">
            <div className="welcome-icon">
              <span className="welcome-wave">👋</span>
            </div>
            <h1 className="welcome-greeting">{getGreeting()}</h1>
            <h2 className="welcome-title">
              {t('dashboard.welcomeBack', 'Welcome back')}, <span className="welcome-name">{user?.firstName || 'User'}</span>
            </h2>
            <p className="welcome-subtitle">
              {t('dashboard.selectPage', 'Select a page from the sidebar to get started')}
            </p>
            <div className="welcome-divider"></div>
            <p className="welcome-date">
              {new Date().toLocaleDateString(undefined, { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
              })}
            </p>
          </div>
        </div>
      </div>
    </MainLayout>
  );
};

export default DashboardPage;
