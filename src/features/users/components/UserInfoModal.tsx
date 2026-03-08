import React from 'react';
import { useTranslation } from 'react-i18next';
import { User } from '../../../core/types';
import { formatDate } from '../../../core/utils/helpers';

interface UserInfoModalProps {
  isOpen: boolean;
  user: User | null;
  onClose: () => void;
}

const UserInfoModal: React.FC<UserInfoModalProps> = ({ isOpen, user, onClose }) => {
  const { t } = useTranslation();

  if (!isOpen || !user) return null;

  const formatCurrency = (amount: number): string => {
    return `${amount.toFixed(2)} DA`;
  };

  const getStatusText = (status: string): string => {
    return status === 'active'
      ? t('users.active', 'Active')
      : t('users.inactive', 'Inactive');
  };

  return (
    <div className="user-modal-overlay" onClick={onClose}>
      <div className="user-modal" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="user-modal-header">
          <h2 className="user-modal-title">{t('users.customerInfo', 'Customer Info')}</h2>
          <button className="user-modal-close" onClick={onClose}>
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <path d="M18 6L6 18"></path>
              <path d="M6 6l12 12"></path>
            </svg>
          </button>
        </div>

        {/* Body */}
        <div className="user-modal-body">
          <div className="user-info-grid">
            {/* Customer ID */}
            <div className="user-info-item">
              <span className="user-info-label">{t('users.customerId', 'Customer ID')}</span>
              <span className="user-info-value">#{user._id.slice(-8)}</span>
            </div>

            {/* Username */}
            <div className="user-info-item">
              <span className="user-info-label">{t('users.name', 'Name')}</span>
              <span className="user-info-value">{user.username}</span>
            </div>

            {/* Phone */}
            <div className="user-info-item">
              <span className="user-info-label">{t('users.phone', 'Phone')}</span>
              <span className="user-info-value">{user.phone || '-'}</span>
            </div>

            {/* Status */}
            <div className="user-info-item">
              <span className="user-info-label">{t('users.status', 'Status')}</span>
              <span className={`user-info-value status--${user.status}`}>
                {getStatusText(user.status)}
              </span>
            </div>

            {/* Total Orders */}
            <div className="user-info-item">
              <span className="user-info-label">{t('users.totalOrders', 'Total Orders')}</span>
              <span className="user-info-value user-info-value--highlight">
                {user.totalOrders}
              </span>
            </div>

            {/* Total Spent */}
            <div className="user-info-item">
              <span className="user-info-label">{t('users.totalSpent', 'Total Spent')}</span>
              <span className="user-info-value user-info-value--highlight">
                {formatCurrency(user.totalSpent)}
              </span>
            </div>

            {/* Address */}
            <div className="user-info-item user-info-item--full">
              <span className="user-info-label">{t('users.address', 'Address')}</span>
              <span className="user-info-value">{user.address || '-'}</span>
            </div>

            {/* Member Since */}
            <div className="user-info-item user-info-item--full">
              <span className="user-info-label">{t('users.memberSince', 'Member Since')}</span>
              <span className="user-info-value">{formatDate(user.createdAt)}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UserInfoModal;
