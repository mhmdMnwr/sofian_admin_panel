import React from 'react';
import { useTranslation } from 'react-i18next';
import { Order, OrderStatus, OrderItem, CustomerInfo } from '../../../core/types';
import { formatDate } from '../../../core/utils/helpers';

interface OrderViewModalProps {
  isOpen: boolean;
  order: Order | null;
  onClose: () => void;
}

// Helper: Get customer info from order
const getCustomerInfo = (order: Order): CustomerInfo => {
  if (order.customerId && typeof order.customerId === 'object') {
    const customer = order.customerId as CustomerInfo;
    return {
      _id: customer._id || '-',
      username: customer.username || '-',
      phone: customer.phone || '-',
      address: customer.address || '-',
    };
  }
  return {
    _id: String(order.customerId) || '-',
    username: '-',
    phone: '-',
    address: '-',
  };
};

// Helper: Get product info from order item
const getProductInfo = (item: OrderItem): { title: string; productUnits: number } => {
  if (item.productId && typeof item.productId === 'object') {
    const product = item.productId as { title: string; units?: number };
    return {
      title: product.title || '-',
      productUnits: product.units || item.units || 1,
    };
  }
  return {
    title: String(item.productId),
    productUnits: item.units || 1,
  };
};

// Helper: Format quantity as "X×units+rest = quantity" or "X×units = quantity"
const formatQuantityFull = (quantity: number, units: number): string => {
  if (units <= 1) return String(quantity);
  
  const packs = Math.floor(quantity / units);
  const rest = quantity % units;
  
  if (rest === 0) {
    return `${packs}×${units} = ${quantity}`;
  }
  return `${packs}×${units}+${rest} = ${quantity}`;
};

// Helper: Get status class and badge color
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

const OrderViewModal: React.FC<OrderViewModalProps> = ({ isOpen, order, onClose }) => {
  const { t } = useTranslation();

  if (!isOpen || !order) return null;

  const customer = getCustomerInfo(order);

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
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content modal-content--large order-view-modal" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="order-modal-header">
          <div className="order-modal-title-section">
            <h2 className="order-modal-title">{t('orders.viewOrder', 'View Order')}</h2>
            <span className="order-modal-id">#{order._id.slice(-8)}</span>
            <span className={`order-modal-status ${getStatusClass(order.status)}`}>
              {getStatusText(order.status)}
            </span>
          </div>
          <button onClick={onClose} className="modal-close-btn" type="button">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>

        {/* Body */}
        <div className="modal-body order-view-body">
          {/* Two Column Layout */}
          <div className="order-view-grid">
            {/* Left Column: Customer Info */}
            <div className="order-view-column">
              <div className="order-info-card">
                <h3 className="order-info-card-title">
                  {t('orders.customerInfo', 'Customer Information')}
                </h3>
                <div className="order-info-card-content">
                  <div className="info-row">
                    <span className="info-label">{t('orders.username', 'Username')}</span>
                    <span className="info-value">{customer.username}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">{t('orders.phone', 'Phone')}</span>
                    <span className="info-value">{customer.phone}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">{t('orders.address', 'Address')}</span>
                    <span className="info-value">{customer.address}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Right Column: Order Info */}
            <div className="order-view-column">
              <div className="order-info-card">
                <h3 className="order-info-card-title">
                  {t('orders.orderInfo', 'Order Information')}
                </h3>
                <div className="order-info-card-content">
                  <div className="info-row">
                    <span className="info-label">{t('orders.date', 'Date')}</span>
                    <span className="info-value">{formatDate(order.createdAt)}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">{t('orders.totalPrice', 'Total Price')}</span>
                    <span className="info-value info-value--price">
                      {(order.totalAmount ?? 0).toFixed(2)} DA
                    </span>
                  </div>
                  {order.comment && (
                    <div className="info-row info-row--comment">
                      <span className="info-label">{t('orders.comment', 'Comment')}</span>
                      <span className="info-value info-value--comment">{order.comment}</span>
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Items Section */}
          <div className="order-info-card order-info-card--full">
            <h3 className="order-info-card-title">
              {t('orders.items', 'Items')} ({order.items.length})
            </h3>
            <div className="order-info-card-content">
              <div className="order-items-container">
                <table className="order-items-table">
                  <thead>
                    <tr>
                      <th>{t('orders.product', 'Product')}</th>
                      <th>{t('orders.quantity', 'Quantity')}</th>
                      <th>{t('orders.price', 'Price')}</th>
                      <th>{t('orders.subtotal', 'Subtotal')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {order.items.map((item, index) => {
                      const { title, productUnits } = getProductInfo(item);
                      const subtotal = item.quantity * item.price;
                      
                      return (
                        <tr key={index}>
                          <td className="item-product">{title}</td>
                          <td className="item-quantity">
                            {formatQuantityFull(item.quantity, productUnits)}
                          </td>
                          <td className="item-price">{item.price.toFixed(2)} DA</td>
                          <td className="item-subtotal">{subtotal.toFixed(2)} DA</td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
};

export default OrderViewModal;
