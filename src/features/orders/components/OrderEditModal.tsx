import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { Order, OrderStatus, OrderItem, CustomerInfo, Product } from '../../../core/types';
import { formatDate } from '../../../core/utils/helpers';
import apiClient from '../../../core/api/apiClient';

// Editable item type
export interface EditableOrderItem {
  productId: string;
  productTitle: string;
  productUnits: number;
  quantity: number;
  units: number;
  price: number;
  quantityInput: string;
  priceInput: string;
  isNew?: boolean;
}

interface OrderEditModalProps {
  isOpen: boolean;
  order: Order | null;
  isSubmitting: boolean;
  error: string | null;
  onClose: () => void;
  onSubmit: (status: OrderStatus, items: EditableOrderItem[]) => void;
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

// Helper: Parse quantity input
// "4" = 4 * units
// "+4" = just 4 units
// "4+2" or "4°2" = 4 * units + 2
// Also handles formatted display like "5×6+3 = 33" by extracting packs and rest
const parseQuantityInput = (input: string, units: number): number => {
  // Normalize: replace ° and × with markers we can parse
  let trimmed = input.trim();
  
  if (!trimmed) return 0;
  
  // Check if it's a formatted display string like "5×6+3 = 33" or "5×6 = 30"
  // Extract the result after = if present
  if (trimmed.includes('=')) {
    const resultPart = trimmed.split('=')[1];
    if (resultPart) {
      const result = parseInt(resultPart.trim(), 10);
      if (!isNaN(result)) return result;
    }
  }
  
  // Normalize separators
  trimmed = trimmed.replace(/[°×x]/gi, '+');
  
  // Case: "+4" - just adding units directly
  if (trimmed.startsWith('+')) {
    const num = parseInt(trimmed.substring(1), 10);
    return isNaN(num) ? 0 : num;
  }
  
  // Case: "4+2" - packs plus extra
  if (trimmed.includes('+')) {
    const parts = trimmed.split('+');
    if (parts.length === 2) {
      const packs = parseInt(parts[0], 10);
      const extra = parseInt(parts[1], 10);
      if (!isNaN(packs) && !isNaN(extra)) {
        return (packs * units) + extra;
      }
    }
    return 0;
  }
  
  // Case: "4" - multiply by units
  const num = parseInt(trimmed, 10);
  return isNaN(num) ? 0 : num * units;
};

// Helper: Format quantity for display in input (same format as view: X×units+rest = quantity)
const formatQuantityInput = (quantity: number, units: number): string => {
  if (units <= 1) return String(quantity);
  
  const packs = Math.floor(quantity / units);
  const rest = quantity % units;
  
  if (rest === 0) {
    return `${packs}×${units} = ${quantity}`;
  }
  return `${packs}×${units}+${rest} = ${quantity}`;
};

// Helper: Format quantity for display (format: X×units+rest = quantity or X×units = quantity)
const formatQuantityDisplay = (quantity: number, units: number): string => {
  if (units <= 1) return String(quantity);
  
  const packs = Math.floor(quantity / units);
  const rest = quantity % units;
  
  if (rest === 0) {
    return `${packs}×${units} = ${quantity}`;
  }
  return `${packs}×${units}+${rest} = ${quantity}`;
};

// Helper: Get status class
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

// Product cache type
type ProductCache = Record<string, { title: string; units: number }>;

// Helper: Convert order items to editable items
const orderItemsToEditable = (items: OrderItem[], productCache: ProductCache = {}): EditableOrderItem[] => {
  return items.map((item) => {
    const productId = typeof item.productId === 'object' ? item.productId._id : item.productId;
    
    // First try from populated object, then from cache
    let productTitle: string;
    let productUnits: number;
    
    if (typeof item.productId === 'object') {
      productTitle = item.productId.title;
      productUnits = item.productId.units || item.units || 1;
    } else if (productCache[productId]) {
      productTitle = productCache[productId].title;
      productUnits = productCache[productId].units || item.units || 1;
    } else {
      // Will be updated when product is fetched
      productTitle = `Product #${productId.slice(-6)}`;
      productUnits = item.units || 1;
    }
    
    return {
      productId,
      productTitle,
      productUnits,
      quantity: item.quantity,
      units: item.units || productUnits,
      price: item.price,
      quantityInput: formatQuantityInput(item.quantity, productUnits),
      priceInput: item.price.toFixed(2),
    };
  });
};

const OrderEditModal: React.FC<OrderEditModalProps> = ({
  isOpen,
  order,
  isSubmitting,
  error,
  onClose,
  onSubmit,
}) => {
  const { t } = useTranslation();
  
  const [editStatus, setEditStatus] = useState<OrderStatus>('Pending');
  const [editableItems, setEditableItems] = useState<EditableOrderItem[]>([]);
  const [itemErrors, setItemErrors] = useState<Record<number, string>>({});
  const [editingQuantityIndex, setEditingQuantityIndex] = useState<number | null>(null);
  const [quantityInputValue, setQuantityInputValue] = useState<string>('');
  
  // Product cache for fetched product details
  const [productCache, setProductCache] = useState<ProductCache>({});
  const [loadingProductDetails, setLoadingProductDetails] = useState(false);
  
  // Product search state
  const [showProductSearch, setShowProductSearch] = useState(false);
  const [productSearch, setProductSearch] = useState('');
  const [availableProducts, setAvailableProducts] = useState<Product[]>([]);
  const [loadingProducts, setLoadingProducts] = useState(false);

  // Fetch missing product details
  useEffect(() => {
    if (!isOpen || !order) return;
    
    // Find items that need product details fetched (productId is a string, not in cache)
    const missingProductIds = order.items
      .filter(item => {
        if (typeof item.productId === 'object') return false; // Already populated
        return !productCache[item.productId]; // Not in cache
      })
      .map(item => item.productId as string);
    
    // Get unique IDs using filter
    const uniqueIds = missingProductIds.filter((id, index) => missingProductIds.indexOf(id) === index);
    
    if (uniqueIds.length === 0) return;
    
    const fetchMissingProducts = async () => {
      setLoadingProductDetails(true);
      const newCache: ProductCache = { ...productCache };
      
      await Promise.all(
        uniqueIds.map(async (productId) => {
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
          }
        })
      );
      
      setProductCache(newCache);
      
      // Update editable items with new product info
      if (order) {
        setEditableItems(orderItemsToEditable(order.items, newCache));
      }
      
      setLoadingProductDetails(false);
    };
    
    fetchMissingProducts();
  }, [isOpen, order]);

  // Initialize state when order changes
  useEffect(() => {
    if (order) {
      setEditStatus(order.status);
      setEditableItems(orderItemsToEditable(order.items, productCache));
      setItemErrors({});
      setShowProductSearch(false);
      setProductSearch('');
    }
  }, [order, productCache]);

  // Fetch products for add
  const fetchProducts = useCallback(async (search: string = '') => {
    setLoadingProducts(true);
    try {
      const params: Record<string, string | number> = { limit: 20 };
      if (search) params.name = search;
      
      const response = await apiClient.get('/products', { params });
      if (response.data.status === 'success') {
        setAvailableProducts(response.data.data || []);
      }
    } catch (err) {
      console.error('Error fetching products:', err);
    } finally {
      setLoadingProducts(false);
    }
  }, []);

  // Fetch products when search opens
  useEffect(() => {
    if (showProductSearch) {
      fetchProducts(productSearch);
    }
  }, [showProductSearch, productSearch, fetchProducts]);

  // Calculate total
  const calculateTotal = useCallback((): number => {
    return editableItems.reduce((sum, item) => sum + (item.quantity * item.price), 0);
  }, [editableItems]);

  // Handle clicking on quantity text to start editing
  const handleQuantityClick = (index: number) => {
    setEditingQuantityIndex(index);
    setQuantityInputValue('');
    // Clear any previous error for this item
    if (itemErrors[index]) {
      setItemErrors((prev) => {
        const updated = { ...prev };
        delete updated[index];
        return updated;
      });
    }
  };

  // Handle quantity input change
  const handleQuantityInputChange = (value: string) => {
    setQuantityInputValue(value);
  };

  // Handle quantity input blur or enter
  const handleQuantityInputBlur = () => {
    if (editingQuantityIndex === null) return;
    
    const index = editingQuantityIndex;
    const item = editableItems[index];
    
    // If empty, just close without changing
    if (!quantityInputValue.trim()) {
      setEditingQuantityIndex(null);
      setQuantityInputValue('');
      return;
    }
    
    const parsedQuantity = parseQuantityInput(quantityInputValue, item.productUnits);
    
    if (parsedQuantity <= 0) {
      setItemErrors((prevErrors) => ({
        ...prevErrors,
        [index]: t('orders.invalidQuantity', 'Invalid quantity'),
      }));
      setEditingQuantityIndex(null);
      setQuantityInputValue('');
      return;
    }
    
    setEditableItems((prev) => {
      const updated = [...prev];
      updated[index] = {
        ...updated[index],
        quantity: parsedQuantity,
        quantityInput: formatQuantityInput(parsedQuantity, item.productUnits),
      };
      return updated;
    });
    
    setEditingQuantityIndex(null);
    setQuantityInputValue('');
  };

  // Handle quantity input key press
  const handleQuantityKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      handleQuantityInputBlur();
    } else if (e.key === 'Escape') {
      setEditingQuantityIndex(null);
      setQuantityInputValue('');
    }
  };

  // Handle price input change
  const handlePriceChange = (index: number, value: string) => {
    setEditableItems((prev) => {
      const updated = [...prev];
      updated[index] = { ...updated[index], priceInput: value };
      return updated;
    });
  };

  // Handle price input blur
  const handlePriceBlur = (index: number) => {
    setEditableItems((prev) => {
      const updated = [...prev];
      const item = updated[index];
      const parsedPrice = parseFloat(item.priceInput);
      
      if (isNaN(parsedPrice) || parsedPrice < 0) {
        updated[index] = { ...item, priceInput: item.price.toFixed(2) };
        return updated;
      }
      
      updated[index] = {
        ...item,
        price: parsedPrice,
        priceInput: parsedPrice.toFixed(2),
      };
      return updated;
    });
  };

  // Handle delete item
  const handleDeleteItem = (index: number) => {
    setEditableItems((prev) => prev.filter((_, i) => i !== index));
    // Clear any errors for this item and reindex
    setItemErrors((prev) => {
      const updated: Record<number, string> = {};
      Object.keys(prev).forEach((key) => {
        const keyNum = parseInt(key, 10);
        if (keyNum < index) {
          updated[keyNum] = prev[keyNum];
        } else if (keyNum > index) {
          updated[keyNum - 1] = prev[keyNum];
        }
      });
      return updated;
    });
  };

  // Handle add product
  const handleAddProduct = (product: Product) => {
    // Check if product already exists
    const existingIndex = editableItems.findIndex((item) => item.productId === product._id);
    if (existingIndex >= 0) {
      // Increment quantity
      setEditableItems((prev) => {
        const updated = [...prev];
        const item = updated[existingIndex];
        const newQuantity = item.quantity + item.productUnits;
        updated[existingIndex] = {
          ...item,
          quantity: newQuantity,
          quantityInput: formatQuantityInput(newQuantity, item.productUnits),
        };
        return updated;
      });
    } else {
      // Add new item
      const newItem: EditableOrderItem = {
        productId: product._id,
        productTitle: product.title,
        productUnits: product.units || 1,
        quantity: product.units || 1,
        units: product.units || 1,
        price: product.price,
        quantityInput: '1',
        priceInput: product.price.toFixed(2),
        isNew: true,
      };
      setEditableItems((prev) => [...prev, newItem]);
    }
    
    setShowProductSearch(false);
    setProductSearch('');
  };

  // Handle form submission
  const handleSubmit = () => {
    if (editableItems.length === 0) {
      return;
    }
    
    const errors: Record<number, string> = {};
    
    editableItems.forEach((item, index) => {
      if (item.quantity <= 0) {
        errors[index] = t('orders.invalidQuantity', 'Invalid quantity');
      }
    });
    
    if (Object.keys(errors).length > 0) {
      setItemErrors(errors);
      return;
    }
    
    onSubmit(editStatus, editableItems);
  };

  if (!isOpen || !order) return null;

  const customer = getCustomerInfo(order);
  const totalAmount = calculateTotal();

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

  // Filter out products already in the order
  const filteredProducts = availableProducts.filter(
    (product) => !editableItems.some((item) => item.productId === product._id)
  );

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content modal-content--large order-edit-modal" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="order-modal-header">
          <div className="order-modal-title-section">
            <h2 className="order-modal-title">{t('orders.editOrder', 'Edit Order')}</h2>
            <span className="order-modal-id">#{order._id.slice(-8)}</span>
          </div>
          <button onClick={onClose} className="modal-close-btn" type="button">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>

        {/* Body */}
        <div className="modal-body order-edit-body">
          {/* Error Banner */}
          {error && (
            <div className="form-error-banner">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
              </svg>
              <span>{error}</span>
            </div>
          )}

          {/* Two Column Layout */}
          <div className="order-edit-grid">
            {/* Left Column: Customer Info (Read-only) */}
            <div className="order-edit-column">
              <div className="order-info-card order-info-card--readonly">
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
                    <span className="info-label">{t('orders.date', 'Date')}</span>
                    <span className="info-value">{formatDate(order.createdAt)}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Right Column: Status Edit */}
            <div className="order-edit-column">
              <div className="order-info-card">
                <h3 className="order-info-card-title">
                  {t('orders.status', 'Status')}
                </h3>
                <div className="order-info-card-content">
                  <select
                    value={editStatus}
                    onChange={(e) => setEditStatus(e.target.value as OrderStatus)}
                    className={`status-select ${getStatusClass(editStatus)}`}
                  >
                    <option value="Pending">{getStatusText('Pending')}</option>
                    <option value="Processing">{getStatusText('Processing')}</option>
                    <option value="Shipped">{getStatusText('Shipped')}</option>
                    <option value="Delivered">{getStatusText('Delivered')}</option>
                    <option value="Cancelled">{getStatusText('Cancelled')}</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          {/* Items Section */}
          <div className="order-info-card order-info-card--full">
            <div className="order-info-card-header">
              <h3 className="order-info-card-title">
                {t('orders.items', 'Items')} ({editableItems.length})
                {loadingProductDetails && <span className="loading-products"> - {t('common.loading', 'Loading...')}</span>}
              </h3>
              <button 
                type="button" 
                className="btn-add-item"
                onClick={() => setShowProductSearch(!showProductSearch)}
              >
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <line x1="12" y1="5" x2="12" y2="19"></line>
                  <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                {t('orders.addItem', 'Add Item')}
              </button>
            </div>

            {/* Product Search Dropdown */}
            {showProductSearch && (
              <div className="product-search-panel">
                <input
                  type="text"
                  value={productSearch}
                  onChange={(e) => setProductSearch(e.target.value)}
                  placeholder={t('orders.searchProduct', 'Search products...')}
                  className="product-search-input"
                  autoFocus
                />
                <div className="product-search-results">
                  {loadingProducts ? (
                    <div className="product-search-loading">
                      <div className="loading-spinner loading-spinner--small"></div>
                    </div>
                  ) : filteredProducts.length > 0 ? (
                    filteredProducts.map((product) => (
                      <div 
                        key={product._id} 
                        className="product-search-item"
                        onClick={() => handleAddProduct(product)}
                      >
                        <span className="product-search-name">{product.title}</span>
                        <span className="product-search-info">
                          {product.units} {t('orders.unitsPerPack', 'units/pack')} • {product.price.toFixed(2)} DA
                        </span>
                      </div>
                    ))
                  ) : (
                    <div className="product-search-empty">
                      {t('orders.noProductsFound', 'No products found')}
                    </div>
                  )}
                </div>
              </div>
            )}

            <div className="order-info-card-content">
              {editableItems.length === 0 ? (
                <div className="empty-items-message">
                  {t('orders.noItems', 'No items in order. Add products above.')}
                </div>
              ) : (
                <div className="order-items-edit-container">
                  <table className="order-items-edit-table">
                    <thead>
                      <tr>
                        <th>{t('orders.product', 'Product')}</th>
                        <th>{t('orders.quantity', 'Quantity')}</th>
                        <th>{t('orders.price', 'Price')}</th>
                        <th>{t('orders.subtotal', 'Subtotal')}</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      {editableItems.map((item, index) => {
                        const subtotal = item.quantity * item.price;
                        const hasError = !!itemErrors[index];
                        const isEditingThis = editingQuantityIndex === index;
                        
                        return (
                          <tr key={`${item.productId}-${index}`} className={hasError ? 'row-error' : ''}>
                            <td className="item-product">{item.productTitle}</td>
                            <td className="item-quantity-edit">
                              {isEditingThis ? (
                                <input
                                  type="text"
                                  value={quantityInputValue}
                                  onChange={(e) => handleQuantityInputChange(e.target.value)}
                                  onBlur={handleQuantityInputBlur}
                                  onKeyDown={handleQuantityKeyDown}
                                  className={`quantity-input ${hasError ? 'error' : ''}`}
                                  autoFocus
                                />
                              ) : (
                                <span 
                                  className="quantity-text-clickable"
                                  onClick={() => handleQuantityClick(index)}
                                  title={t('orders.clickToEdit', 'Click to edit')}
                                >
                                  {formatQuantityDisplay(item.quantity, item.productUnits)}
                                </span>
                              )}
                              {hasError && (
                                <span className="error-message">{itemErrors[index]}</span>
                              )}
                            </td>
                            <td className="item-price-edit">
                              <div className="price-input-wrapper">
                                <input
                                  type="text"
                                  value={item.priceInput}
                                  onChange={(e) => handlePriceChange(index, e.target.value)}
                                  onBlur={() => handlePriceBlur(index)}
                                  className="price-input"
                                />
                                <span className="price-currency">DA</span>
                              </div>
                            </td>
                            <td className="item-subtotal">{subtotal.toFixed(2)} DA</td>
                            <td className="item-actions">
                              <button 
                                type="button" 
                                className="btn-delete-item"
                                onClick={() => handleDeleteItem(index)}
                                title={t('common.delete', 'Delete')}
                              >
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <polyline points="3 6 5 6 21 6"></polyline>
                                  <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                </svg>
                              </button>
                            </td>
                          </tr>
                        );
                      })}
                    </tbody>
                  </table>
                </div>
              )}
              
              {/* Total Row */}
              <div className="order-total-row">
                <span className="order-total-label">{t('orders.total', 'Total')}:</span>
                <span className="order-total-value">{totalAmount.toFixed(2)} DA</span>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="modal-actions">
          <button type="button" onClick={onClose} className="btn-cancel" disabled={isSubmitting}>
            {t('common.cancel', 'Cancel')}
          </button>
          <button
            type="button"
            onClick={handleSubmit}
            className="btn-submit"
            disabled={isSubmitting || editableItems.length === 0 || Object.keys(itemErrors).length > 0}
          >
            {isSubmitting ? (
              <>
                <div className="loading-spinner loading-spinner--small"></div>
                {t('common.saving', 'Saving...')}
              </>
            ) : (
              t('orders.saveChanges', 'Save Changes')
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default OrderEditModal;
