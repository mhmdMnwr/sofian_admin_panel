import React from 'react';
import { useTranslation } from 'react-i18next';
import { Order, OrderStatus } from '../../../core/types';
import { formatDate } from '../../../core/utils/helpers';

interface OrderTableProps {
  orders: Order[];
  onView: (order: Order) => void;
  onEdit: (order: Order) => void;
}

// Helper functions
const getUsername = (order: Order): string => {
  if (order.customerId && typeof order.customerId === 'object') {
    const userObj = order.customerId as { username?: string; _id?: string };
    return userObj.username || userObj._id || '-';
  }
  return order.customerId ? String(order.customerId) : '-';
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

const OrderTable: React.FC<OrderTableProps> = ({ orders, onView, onEdit }) => {
  const { t } = useTranslation();

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
    <div className="orders-table-container">
      <table className="orders-table">
        <thead>
          <tr>
            <th>{t('orders.orderId', 'Order ID')}</th>
            <th className="th-separator">{t('orders.username', 'Username')}</th>
            <th className="th-separator">{t('orders.totalPrice', 'Total Price')}</th>
            <th className="th-separator">{t('orders.status', 'Status')}</th>
            <th className="th-separator">{t('orders.date', 'Date')}</th>
            <th className="th-separator">{t('orders.actions', 'Actions')}</th>
          </tr>
        </thead>
        <tbody>
          {orders.length > 0 ? (
            orders.map((order, index) => (
              <tr key={order._id} className={index % 2 === 0 ? 'row-even' : 'row-odd'}>
                <td className="order-id">#{order._id.slice(-8)}</td>
                <td className="order-username">{getUsername(order)}</td>
                <td className="order-total">{(order.totalAmount ?? 0).toFixed(2)} DA</td>
                <td>
                  <span className={`order-status ${getStatusClass(order.status)}`}>
                    {getStatusText(order.status)}
                  </span>
                </td>
                <td className="order-date">{formatDate(order.createdAt)}</td>
                <td className="order-actions">
                  <button
                    className="action-btn action-btn--view"
                    onClick={() => onView(order)}
                    title={t('common.view', 'View')}
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                      <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                  </button>
                  <button
                    className="action-btn action-btn--edit"
                    onClick={() => onEdit(order)}
                    title={t('common.edit', 'Edit')}
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                    </svg>
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={6} className="orders-table__empty">
                {t('orders.noOrders', 'No orders found')}
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default OrderTable;
