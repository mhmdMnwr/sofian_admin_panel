import React from 'react';
import { useTranslation } from 'react-i18next';
import { User } from '../../../core/types';

interface UserTableProps {
  users: User[];
  onViewInfo: (user: User) => void;
  onViewOrders: (user: User) => void;
  onToggleStatus: (user: User) => void;
  togglingUserId: string | null;
}

const UserTable: React.FC<UserTableProps> = ({
  users,
  onViewInfo,
  onViewOrders,
  onToggleStatus,
  togglingUserId,
}) => {
  const { t } = useTranslation();

  const getStatusText = (status: string): string => {
    return status === 'active'
      ? t('users.active', 'Active')
      : t('users.inactive', 'Inactive');
  };

  const formatCurrency = (amount: number): string => {
    return `${amount.toFixed(2)} DA`;
  };

  return (
    <div className="users-table-container">
      <table className="users-table">
        <thead>
          <tr>
            <th>{t('users.customerId', 'Customer ID')}</th>
            <th className="th-separator">{t('users.name', 'Name')}</th>
            <th className="th-separator">{t('users.orders', 'Orders')}</th>
            <th className="th-separator">{t('users.totalSpent', 'Total Spent')}</th>
            <th className="th-separator">{t('users.status', 'Status')}</th>
            <th className="th-separator">{t('users.actions', 'Actions')}</th>
          </tr>
        </thead>
        <tbody>
          {users.length > 0 ? (
            users.map((user, index) => (
              <tr key={user._id} className={index % 2 === 0 ? 'row-even' : 'row-odd'}>
                <td className="user-id">#{user._id.slice(-8)}</td>
                <td className="user-name">{user.username}</td>
                <td className="user-orders">{user.totalOrders}</td>
                <td className="user-spent">{formatCurrency(user.totalSpent)}</td>
                <td>
                  <button
                    className={`user-status-btn status--${user.status}`}
                    onClick={() => onToggleStatus(user)}
                    disabled={togglingUserId === user._id}
                    title={t('users.clickToToggle', 'Click to toggle status')}
                  >
                    {togglingUserId === user._id ? (
                      <div className="loading-spinner--small"></div>
                    ) : (
                      getStatusText(user.status)
                    )}
                  </button>
                </td>
                <td className="user-actions">
                  {/* View Info Button */}
                  <button
                    className="action-btn action-btn--info"
                    onClick={() => onViewInfo(user)}
                    title={t('users.viewInfo', 'View Info')}
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <circle cx="12" cy="12" r="10"></circle>
                      <path d="M12 16v-4"></path>
                      <path d="M12 8h.01"></path>
                    </svg>
                  </button>

                  {/* View Orders Button */}
                  <button
                    className="action-btn action-btn--orders"
                    onClick={() => onViewOrders(user)}
                    title={t('users.viewOrders', 'View Orders')}
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"></path>
                      <rect x="9" y="3" width="6" height="4" rx="1"></rect>
                      <path d="M9 12h6"></path>
                      <path d="M9 16h6"></path>
                    </svg>
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={6} className="users-table__empty">
                <p>{t('users.noUsers', 'No customers found')}</p>
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default UserTable;
