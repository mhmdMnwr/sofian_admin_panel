import React from 'react';
import { useTranslation } from 'react-i18next';
import { User } from '../../../core/types';

interface ManagerCardProps {
  manager: User;
  onEdit: (manager: User) => void;
  onToggleStatus: (manager: User) => void;
  isToggling?: boolean;
}

const ManagerCard: React.FC<ManagerCardProps> = ({
  manager,
  onEdit,
  onToggleStatus,
  isToggling = false,
}) => {
  const { t } = useTranslation();

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  return (
    <div className="manager-card">
      {/* Card Header */}
      <div className="manager-card__header">
        <h3 className="manager-card__username">{manager.username}</h3>
        <button
          className={`manager-card__status-badge manager-card__status-badge--${manager.status}`}
          onClick={() => onToggleStatus(manager)}
          disabled={isToggling}
          title={t('managers.clickToToggle', 'Click to toggle status')}
        >
          {isToggling
            ? t('common.loading', 'Loading...')
            : manager.status === 'active'
            ? t('managers.active', 'Active')
            : t('managers.inactive', 'Inactive')}
        </button>
      </div>

      {/* Card Info */}
      <div className="manager-card__info">
        {/* Phone */}
        <div className="manager-card__info-row">
          <div className="manager-card__info-icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
            </svg>
          </div>
          <div className="manager-card__info-content">
            <span className="manager-card__info-label">{t('managers.phone', 'Phone Num')}</span>
            <span className={`manager-card__info-value ${!manager.phone ? 'manager-card__info-value--empty' : ''}`}>
              {manager.phone || t('common.notProvided', 'Not provided')}
            </span>
          </div>
        </div>

        {/* Address */}
        <div className="manager-card__info-row">
          <div className="manager-card__info-icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
              <circle cx="12" cy="10" r="3"></circle>
            </svg>
          </div>
          <div className="manager-card__info-content">
            <span className="manager-card__info-label">{t('managers.address', 'Address')}</span>
            <span className={`manager-card__info-value ${!manager.address ? 'manager-card__info-value--empty' : ''}`}>
              {manager.address || t('common.notProvided', 'Not provided')}
            </span>
          </div>
        </div>

        {/* Join Date */}
        <div className="manager-card__info-row">
          <div className="manager-card__info-icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
              <line x1="16" y1="2" x2="16" y2="6"></line>
              <line x1="8" y1="2" x2="8" y2="6"></line>
              <line x1="3" y1="10" x2="21" y2="10"></line>
            </svg>
          </div>
          <div className="manager-card__info-content">
            <span className="manager-card__info-label">{t('managers.joinDate', 'Join Date')}</span>
            <span className="manager-card__info-value">
              {manager.createdAt ? formatDate(manager.createdAt) : t('common.notProvided', 'Not provided')}
            </span>
          </div>
        </div>
      </div>

      {/* Card Actions */}
      <div className="manager-card__actions">
        <button className="manager-card__edit-btn" onClick={() => onEdit(manager)}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
          </svg>
          {t('managers.edit', 'Edit')}
        </button>
      </div>
    </div>
  );
};

export default ManagerCard;
