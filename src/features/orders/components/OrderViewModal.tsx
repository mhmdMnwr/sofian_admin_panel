import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Order, OrderStatus, OrderItem, CustomerInfo, Product } from '../../../core/types';
import { formatDate } from '../../../core/utils/helpers';
import apiClient from '../../../core/api/apiClient';

interface OrderViewModalProps {
  isOpen: boolean;
  order: Order | null;
  onClose: () => void;
}

// Product cache to store fetched product titles
type ProductCache = Record<string, { title: string; units: number }>;

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

// Helper: Get product info from order item (with cache)
const getProductInfo = (item: OrderItem, productCache: ProductCache): { title: string; productUnits: number; needsFetch: boolean } => {
  if (item.productId && typeof item.productId === 'object') {
    const product = item.productId as { title: string; units?: number };
    return {
      title: product.title || '-',
      productUnits: product.units || item.units || 1,
      needsFetch: false,
    };
  }
  
  const productId = String(item.productId);
  
  // Check cache
  if (productCache[productId]) {
    return {
      title: productCache[productId].title,
      productUnits: productCache[productId].units,
      needsFetch: false,
    };
  }
  
  return {
    title: productId, // Show ID temporarily until fetched
    productUnits: item.units || 1,
    needsFetch: true,
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
  const [productCache, setProductCache] = useState<ProductCache>({});
  const [loadingProducts, setLoadingProducts] = useState(false);

  // Fetch missing product details when order changes
  useEffect(() => {
    if (!isOpen || !order) return;

    const fetchMissingProducts = async () => {
      // Find products that need to be fetched
      const productIdsToFetch: string[] = [];
      
      order.items.forEach((item) => {
        if (typeof item.productId === 'string') {
          const productId = item.productId;
          if (!productCache[productId]) {
            productIdsToFetch.push(productId);
          }
        }
      });

      if (productIdsToFetch.length === 0) return;

      setLoadingProducts(true);
      
      // Fetch each product
      const newCache: ProductCache = { ...productCache };
      
      await Promise.all(
        productIdsToFetch.map(async (productId) => {
          try {
            const response = await apiClient.get<{ status: string; data: Product }>(`/products/${productId}`);
            if (response.data.status === 'success' && response.data.data) {
              newCache[productId] = {
                title: response.data.data.title,
                units: response.data.data.units || 1,
              };
            }
          } catch (err) {
            console.error(`Failed to fetch product ${productId}:`, err);
            // Keep showing ID if fetch fails
            newCache[productId] = { title: productId, units: 1 };
          }
        })
      );
      
      setProductCache(newCache);
      setLoadingProducts(false);
    };

    fetchMissingProducts();
  }, [isOpen, order]); // eslint-disable-line react-hooks/exhaustive-deps

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
              {loadingProducts && <span className="loading-products"> - {t('common.loading', 'Loading...')}</span>}
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
                      const { title, productUnits } = getProductInfo(item, productCache);
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
