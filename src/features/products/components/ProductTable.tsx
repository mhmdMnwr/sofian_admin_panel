import React from 'react';
import { useTranslation } from 'react-i18next';
import { Product } from '../../../core/types';

interface ProductTableProps {
  products: Product[];
  onEdit: (product: Product) => void;
  onDelete: (productId: string) => void;
}

// Helper functions
const getStateClass = (state: string): string => {
  return state === 'available' ? 'state--available' : 'state--unavailable';
};

const getDisplayValue = (
  field: { _id?: string; title?: string } | string | null | undefined,
  fallback: string = '-'
): string => {
  if (!field) return fallback;
  if (typeof field === 'object' && field.title) return field.title;
  return String(field);
};

const ProductTable: React.FC<ProductTableProps> = ({ products, onEdit, onDelete }) => {
  const { t } = useTranslation();

  const getStateText = (state: string): string => {
    return state === 'available'
      ? t('products.available', 'Available')
      : t('products.unavailable', 'Unavailable');
  };

  if (products.length === 0) {
    return (
      <div className="products-table-container">
        <table className="products-table">
          <thead>
            <tr>
              <th>{t('products.productId', 'Product ID')}</th>
              <th className="th-separator">{t('products.title', 'Title')}</th>
              <th className="th-separator">{t('products.images', 'Images')}</th>
              <th className="th-separator">{t('products.unitsNum', 'Units')}</th>
              <th className="th-separator">{t('products.category', 'Category')}</th>
              <th className="th-separator">{t('products.brand', 'Brand')}</th>
              <th className="th-separator">{t('products.price', 'Price')}</th>
              <th className="th-separator">{t('products.state', 'State')}</th>
              <th className="th-separator">{t('products.actions', 'Actions')}</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colSpan={9} className="products-table__empty">
                {t('products.noProducts', 'No products found')}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="products-table-container">
      <table className="products-table">
        <thead>
          <tr>
            <th>{t('products.productId', 'Product ID')}</th>
            <th className="th-separator">{t('products.title', 'Title')}</th>
            <th className="th-separator">{t('products.images', 'Images')}</th>
            <th className="th-separator">{t('products.unitsNum', 'Units')}</th>
            <th className="th-separator">{t('products.category', 'Category')}</th>
            <th className="th-separator">{t('products.brand', 'Brand')}</th>
            <th className="th-separator">{t('products.price', 'Price')}</th>
            <th className="th-separator">{t('products.state', 'State')}</th>
            <th className="th-separator">{t('products.actions', 'Actions')}</th>
          </tr>
        </thead>
        <tbody>
          {products.map((product, index) => (
            <tr key={product._id} className={index % 2 === 0 ? 'row-even' : 'row-odd'}>
              <td className="product-id">#{product._id.slice(-8)}</td>
              <td className="product-name">{product.title}</td>
              <td className="product-image-cell">
                {product.image ? (
                  <img src={product.image} alt={product.title} className="product-image" />
                ) : (
                  <div className="product-image-placeholder">
                    <svg
                      width="24"
                      height="24"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                      <circle cx="8.5" cy="8.5" r="1.5"></circle>
                      <polyline points="21 15 16 10 5 21"></polyline>
                    </svg>
                  </div>
                )}
              </td>
              <td className="product-units">{product.units ?? 0}</td>
              <td className="product-category">{getDisplayValue(product.category)}</td>
              <td className="product-brand">{getDisplayValue(product.brand)}</td>
              <td className="product-price">{product.price.toFixed(2)} DA</td>
              <td>
                <span className={`product-state ${getStateClass(product.state)}`}>
                  {getStateText(product.state)}
                </span>
              </td>
              <td className="product-actions">
                <button
                  className="action-btn action-btn--edit"
                  onClick={() => onEdit(product)}
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
                <button
                  className="action-btn action-btn--delete"
                  onClick={() => onDelete(product._id)}
                  title={t('common.delete', 'Delete')}
                >
                  <svg
                    width="16"
                    height="16"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="2"
                  >
                    <polyline points="3 6 5 6 21 6"></polyline>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    <line x1="10" y1="11" x2="10" y2="17"></line>
                    <line x1="14" y1="11" x2="14" y2="17"></line>
                  </svg>
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ProductTable;
