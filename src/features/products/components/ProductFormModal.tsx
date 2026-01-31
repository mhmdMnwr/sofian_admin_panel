import React, { useRef } from 'react';
import { useTranslation } from 'react-i18next';

interface FilterOption {
  _id: string;
  title: string;
}

export interface ProductFormData {
  title: string;
  units: string;
  price: string;
  category: string;
  brand: string;
  state: string;
  image: File | null;
}

interface ProductFormModalProps {
  isOpen: boolean;
  isEditMode: boolean;
  formData: ProductFormData;
  formErrors: Partial<Record<keyof ProductFormData, string>>;
  generalError: string | null;
  isSubmitting: boolean;
  imagePreview: string | null;
  categories: FilterOption[];
  brands: FilterOption[];
  onClose: () => void;
  onSubmit: (e: React.FormEvent) => void;
  onInputChange: (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => void;
  onImageChange: (file: File | null) => void;
  onRemoveImage: () => void;
}

const ProductFormModal: React.FC<ProductFormModalProps> = ({
  isOpen,
  isEditMode,
  formData,
  formErrors,
  generalError,
  isSubmitting,
  imagePreview,
  categories,
  brands,
  onClose,
  onSubmit,
  onInputChange,
  onImageChange,
  onRemoveImage,
}) => {
  const { t } = useTranslation();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isDragging, setIsDragging] = React.useState(false);

  if (!isOpen) return null;

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    const file = e.dataTransfer.files[0];
    onImageChange(file);
  };

  const handleFileInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0] || null;
    onImageChange(file);
  };

  const handleRemoveImage = () => {
    onRemoveImage();
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2>
            {isEditMode
              ? t('products.editProduct', 'Edit Product')
              : t('products.createProduct', 'Create Product')}
          </h2>
          <button onClick={onClose} className="modal-close-btn" type="button">
            <svg
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>

        <form onSubmit={onSubmit} className="modal-form">
          {/* General Error Message */}
          {generalError && (
            <div className="form-error-banner">
              <svg
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
              </svg>
              <span>{generalError}</span>
            </div>
          )}

          {/* Title Field */}
          <div className="form-group">
            <label htmlFor="title">{t('products.productTitle', 'Product Title')} *</label>
            <input
              type="text"
              id="title"
              name="title"
              value={formData.title}
              onChange={onInputChange}
              className={formErrors.title ? 'error' : ''}
              placeholder={t('products.enterTitle', 'Enter product title')}
            />
            {formErrors.title && <span className="error-message">{formErrors.title}</span>}
          </div>

          {/* Units Field */}
          <div className="form-group">
            <label htmlFor="units">{t('products.units', 'Number of Units')} *</label>
            <input
              type="number"
              id="units"
              name="units"
              value={formData.units}
              onChange={onInputChange}
              className={formErrors.units ? 'error' : ''}
              placeholder={t('products.enterUnits', 'Enter number of units')}
              min="1"
            />
            {formErrors.units && <span className="error-message">{formErrors.units}</span>}
          </div>

          {/* Price Field */}
          <div className="form-group">
            <label htmlFor="price">{t('products.pricePerUnit', 'Price per Unit')} *</label>
            <input
              type="number"
              id="price"
              name="price"
              value={formData.price}
              onChange={onInputChange}
              className={formErrors.price ? 'error' : ''}
              placeholder={t('products.enterPrice', 'Enter price')}
              step="0.01"
              min="0"
            />
            {formErrors.price && <span className="error-message">{formErrors.price}</span>}
          </div>

          {/* Category Field */}
          <div className="form-group">
            <label htmlFor="category">{t('products.category', 'Category')}</label>
            <select
              id="category"
              name="category"
              value={formData.category}
              onChange={onInputChange}
            >
              <option value="">{t('products.selectCategory', 'Select a category')}</option>
              {categories.map((cat) => (
                <option key={cat._id} value={cat._id}>
                  {cat.title}
                </option>
              ))}
            </select>
          </div>

          {/* Brand Field */}
          <div className="form-group">
            <label htmlFor="brand">{t('products.brand', 'Brand')}</label>
            <select id="brand" name="brand" value={formData.brand} onChange={onInputChange}>
              <option value="">{t('products.selectBrand', 'Select a brand')}</option>
              {brands.map((brand) => (
                <option key={brand._id} value={brand._id}>
                  {brand.title}
                </option>
              ))}
            </select>
          </div>

          {/* State Field */}
          <div className="form-group">
            <label htmlFor="state">{t('products.state', 'State')} *</label>
            <select
              id="state"
              name="state"
              value={formData.state}
              onChange={onInputChange}
              className={formErrors.state ? 'error' : ''}
            >
              <option value="available">{t('products.available', 'Available')}</option>
              <option value="unavailable">{t('products.unavailable', 'Unavailable')}</option>
            </select>
            {formErrors.state && <span className="error-message">{formErrors.state}</span>}
          </div>

          {/* Image Upload Field */}
          <div className="form-group">
            <label>{t('products.image', 'Image')}</label>
            <div
              className={`image-drop-zone ${isDragging ? 'dragging' : ''} ${
                imagePreview ? 'has-image' : ''
              }`}
              onDragOver={handleDragOver}
              onDragLeave={handleDragLeave}
              onDrop={handleDrop}
              onClick={() => fileInputRef.current?.click()}
            >
              {imagePreview ? (
                <div className="image-preview-container">
                  <img src={imagePreview} alt="Preview" className="image-preview" />
                  <button
                    type="button"
                    className="remove-image-btn"
                    onClick={(e) => {
                      e.stopPropagation();
                      handleRemoveImage();
                    }}
                  >
                    <svg
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <line x1="18" y1="6" x2="6" y2="18"></line>
                      <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                  </button>
                </div>
              ) : (
                <div className="drop-zone-content">
                  <svg
                    width="48"
                    height="48"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                  >
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                    <polyline points="17 8 12 3 7 8"></polyline>
                    <line x1="12" y1="3" x2="12" y2="15"></line>
                  </svg>
                  <p>{t('products.dragDropImage', 'Drag & drop an image here')}</p>
                  <span>{t('products.orClickToSelect', 'or click to select')}</span>
                </div>
              )}
              <input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                onChange={handleFileInputChange}
                style={{ display: 'none' }}
              />
            </div>
            {formErrors.image && <span className="error-message">{formErrors.image}</span>}
          </div>

          {/* Form Actions */}
          <div className="modal-actions">
            <button type="button" onClick={onClose} className="btn-cancel">
              {t('common.cancel', 'Cancel')}
            </button>
            <button type="submit" className="btn-submit" disabled={isSubmitting}>
              {isSubmitting ? (
                <>
                  <div className="loading-spinner loading-spinner--small"></div>
                  {isEditMode
                    ? t('common.saving', 'Saving...')
                    : t('common.creating', 'Creating...')}
                </>
              ) : isEditMode ? (
                t('products.saveChanges', 'Save Changes')
              ) : (
                t('products.createProduct', 'Create Product')
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ProductFormModal;
