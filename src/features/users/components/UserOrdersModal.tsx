import React from 'react';
import { useTranslation } from 'react-i18next';
import { User, Order, OrderStatus } from '../../../core/types';
import { Pagination } from '../../../components/common';
import { formatDate } from '../../../core/utils/helpers';

interface UserOrdersModalProps {
  isOpen: boolean;
  user: User | null;
  orders: Order[];
  loading: boolean;
  error: string | null;
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
  onClose: () => void;
}

const UserOrdersModal: React.FC<UserOrdersModalProps> = ({
  isOpen,
  user,
  orders,
  loading,
  error,
  currentPage,
  totalPages,
  onPageChange,
  onClose,
}) => {
  const { t } = useTranslation();

  if (!isOpen || !user) return null;

  const formatCurrency = (amount: number): string => {
    return `${amount.toFixed(2)} DA`;
  };

  const getStatusClass = (status: OrderStatus): string => {
    const statusClasses: Record<string, string> = {
      Pending: 'status--pending',
      Processing: 'status--processing',
      Shipped: 'status--shipped',
      Delivered: 'status--delivered',
      Cancelled: 'status--cancelled',
    };
    return statusClasses[status] || 'status--pending';
  };

  const getStatusText = (status: OrderStatus): string => {
    const statusTexts: Record<string, string> = {
      Pending: t('orders.pending', 'Pending'),
      Processing: t('orders.processing', 'Processing'),
      Shipped: t('orders.shipped', 'Shipped'),
      Delivered: t('orders.delivered', 'Delivered'),
      Cancelled: t('orders.cancelled', 'Cancelled'),
    };
    return statusTexts[status] || status;
  };

  return (
    <div className="user-modal-overlay" onClick={onClose}>
      <div className="user-modal user-modal--large user-orders-modal" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="user-modal-header">
          <h2 className="user-modal-title">
            {t('users.ordersFor', 'Orders for {{name}}', { name: user.username })}
          </h2>
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
          {/* Loading State */}
          {loading && (
            <div className="user-orders-loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          )}

          {/* Error State */}
          {error && !loading && (
            <div className="user-orders-error">
              <p>{error}</p>
            </div>
          )}

          {/* Empty State */}
          {!loading && !error && orders.length === 0 && (
            <div className="user-orders-empty">
              <svg
                width="48"
                height="48"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.5"
              >
                <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"></path>
                <rect x="9" y="3" width="6" height="4" rx="1"></rect>
              </svg>
              <p>{t('users.noOrders', 'No orders found for this customer')}</p>
            </div>
          )}

          {/* Orders Table */}
          {!loading && !error && orders.length > 0 && (
            <>
              <div className="user-orders-table-container">
                <table className="user-orders-table">
                  <thead>
                    <tr>
                      <th>{t('orders.orderId', 'Order ID')}</th>
                      <th>{t('orders.items', 'Items')}</th>
                      <th>{t('orders.totalPrice', 'Total')}</th>
                      <th>{t('orders.status', 'Status')}</th>
                      <th>{t('orders.date', 'Date')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {orders.map((order) => (
                      <tr key={order._id}>
                        <td>#{order._id.slice(-8)}</td>
                        <td>{order.items.length}</td>
                        <td>{formatCurrency(order.totalAmount)}</td>
                        <td>
                          <span className={`order-status-badge ${getStatusClass(order.status)}`}>
                            {getStatusText(order.status)}
                          </span>
                        </td>
                        <td>{formatDate(order.createdAt)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Pagination */}
              {totalPages > 1 && (
                <div className="user-orders-pagination">
                  <Pagination
                    currentPage={currentPage}
                    totalPages={totalPages}
                    onPageChange={onPageChange}
                  />
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default UserOrdersModal;
