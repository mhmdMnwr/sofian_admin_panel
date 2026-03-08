import React, { useState, useEffect, useCallback, useRef } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import apiClient from '../../core/api/apiClient';
import { Brand, BrandsResponse } from '../../core/types';
import { uploadToCloudinary, getOptimizedImageUrl, deleteFromCloudinary } from '../../core/services/cloudinaryService';
import './BrandsPage.css';

interface BrandForm {
  title: string;
  image: File | null;
}

const initialFormState: BrandForm = {
  title: '',
  image: null,
};

const BrandsPage: React.FC = () => {
  const { t } = useTranslation();
  const [brands, setBrands] = useState<Brand[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [totalBrands, setTotalBrands] = useState(0);
  
  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [itemsPerPage] = useState(10);
  
  // Search state
  const [searchTitle, setSearchTitle] = useState('');
  
  // Modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [editingBrandId, setEditingBrandId] = useState<string | null>(null);
  const [formData, setFormData] = useState<BrandForm>(initialFormState);
  const [formErrors, setFormErrors] = useState<Partial<Record<keyof BrandForm, string>>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  
  // Delete confirmation state
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [deletingBrandId, setDeletingBrandId] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  const fetchBrands = useCallback(async (page: number = currentPage) => {
    try {
      setLoading(true);
      setError(null);
      
      const params: Record<string, string | number> = {
        page,
        limit: itemsPerPage,
      };
      if (searchTitle) params.title = searchTitle;
      
      const response = await apiClient.get<BrandsResponse>('/brands', { params });
      
      if (response.data.status === 'success') {
        const fetchedBrands = response.data.data || [];
        setBrands(fetchedBrands);
        setTotalBrands(response.data.meta?.totalItems || fetchedBrands.length);
        setTotalPages(response.data.meta?.totalPages || 1);
        setCurrentPage(response.data.meta?.page || page);
      }
    } catch (err) {
      setError(t('errors.unknownError', 'An error occurred while fetching brands'));
      console.error('Error fetching brands:', err);
    } finally {
      setLoading(false);
    }
  }, [t, searchTitle, currentPage, itemsPerPage]);

  useEffect(() => {
    fetchBrands(1);
  }, []);

  const handleSearch = () => {
    setCurrentPage(1);
    fetchBrands(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    fetchBrands(page);
  };

  // Modal functions
  const openModal = () => {
    setIsModalOpen(true);
    setIsEditMode(false);
    setEditingBrandId(null);
    setFormData(initialFormState);
    setFormErrors({});
    setImagePreview(null);
  };

  const closeModal = () => {
    setIsModalOpen(false);
    setIsEditMode(false);
    setEditingBrandId(null);
    setFormData(initialFormState);
    setFormErrors({});
    setImagePreview(null);
  };

  const handleEditBrand = (brand: Brand) => {
    setIsEditMode(true);
    setEditingBrandId(brand._id);
    setFormData({
      title: brand.title,
      image: null,
    });
    setImagePreview(brand.image || null);
    setFormErrors({});
    setIsModalOpen(true);
  };

  const handleDeleteBrand = (brandId: string) => {
    setDeletingBrandId(brandId);
    setDeleteError(null);
    setIsDeleteModalOpen(true);
  };

  const confirmDelete = async () => {
    if (!deletingBrandId) return;
    
    setIsDeleting(true);
    setDeleteError(null);
    try {
      // Find the brand to get its image URL before deletion
      const brandToDelete = brands.find(b => b._id === deletingBrandId);
      
      const response = await apiClient.delete(`/brands/${deletingBrandId}`);
      
      if (response.data.status === 'success') {
        // Delete image from Cloudinary if exists
        if (brandToDelete?.image) {
          await deleteFromCloudinary(brandToDelete.image);
        }
        
        setIsDeleteModalOpen(false);
        setDeletingBrandId(null);
        setBrands(prev => prev.filter(b => b._id !== deletingBrandId));
        setTotalBrands(prev => prev - 1);
      }
    } catch (err: any) {
      console.error('Error deleting brand:', err);
      const serverMessage = err.response?.data?.message?.toLowerCase() || '';
      
      // Check if the brand is associated with products
      if (serverMessage.includes('product') || serverMessage.includes('associated') || 
          serverMessage.includes('in use') || serverMessage.includes('has products') ||
          err.response?.status === 400 || err.response?.status === 409) {
        setDeleteError(t('errors.brandHasProducts', 'This brand cannot be deleted because it has products associated with it. Please remove or reassign the products first.'));
      } else {
        setDeleteError(err.response?.data?.message || t('errors.unknownError', 'An error occurred'));
      }
    } finally {
      setIsDeleting(false);
    }
  };

  const cancelDelete = () => {
    setIsDeleteModalOpen(false);
    setDeletingBrandId(null);
    setDeleteError(null);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    if (formErrors[name as keyof BrandForm]) {
      setFormErrors(prev => ({ ...prev, [name]: undefined }));
    }
  };

  const handleImageChange = (file: File | null) => {
    if (file) {
      if (!file.type.startsWith('image/')) {
        setFormErrors(prev => ({ ...prev, image: t('brands.invalidImageType', 'Please select a valid image file') }));
        return;
      }
      if (file.size > 2 * 1024 * 1024) {
        setFormErrors(prev => ({ ...prev, image: t('brands.imageTooLarge', 'Image must be less than 2MB') }));
        return;
      }
      
      setFormData(prev => ({ ...prev, image: file }));
      setFormErrors(prev => ({ ...prev, image: undefined }));
      
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

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
    handleImageChange(file);
  };

  const handleFileInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0] || null;
    handleImageChange(file);
  };

  const removeImage = () => {
    setFormData(prev => ({ ...prev, image: null }));
    setImagePreview(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const validateForm = (): boolean => {
    const errors: Partial<Record<keyof BrandForm, string>> = {};
    
    if (!formData.title.trim()) {
      errors.title = t('brands.titleRequired', 'Brand title is required');
    }
    
    setFormErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) return;
    
    setIsSubmitting(true);
    
    try {
      const isEdit = isEditMode && editingBrandId;
      const endpoint = isEdit ? `/brands/${editingBrandId}` : '/brands';
      const method = isEdit ? 'patch' : 'post';
      
      // Prepare submit data
      const submitData: { title: string; image?: string } = {
        title: formData.title.trim(),
      };
      
      // Upload image to Cloudinary if a new image is selected
      if (formData.image) {
        // Delete old image from Cloudinary if updating
        if (isEdit && imagePreview) {
          await deleteFromCloudinary(imagePreview);
        }
        
        const uploadResult = await uploadToCloudinary(formData.image, 'brands');
        
        if (!uploadResult.success) {
          setFormErrors(prev => ({
            ...prev,
            image: uploadResult.error || t('errors.imageUploadFailed', 'Failed to upload image'),
          }));
          setIsSubmitting(false);
          return;
        }
        
        submitData.image = uploadResult.url;
      }
      
      const response = await apiClient[method](endpoint, submitData);
      
      if (response.data.status === 'success') {
        closeModal();
        fetchBrands();
      }
    } catch (err: any) {
      console.error('Error saving brand:', err);
      setFormErrors(prev => ({ 
        ...prev, 
        title: err.response?.data?.message || t('errors.unknownError', 'An error occurred') 
      }));
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <MainLayout>
      <div className="brands-page">
        <div className="brands-page__header">
          <div className="brands-page__header-left">
            <h1 className="brands-page__title">{t('brands.title', 'Brands')}</h1>
            {totalBrands > 0 && (
              <span className="brands-page__count">
                {brands.length} {t('brands.items', 'items')}
              </span>
            )}
          </div>
          <button onClick={openModal} className="brands-page__create-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            {t('brands.createBrand', 'Create Brand')}
          </button>
        </div>

        <div className="brands-page__content">
          {loading ? (
            <div className="brands-page__loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          ) : error ? (
            <div className="brands-page__error">
              <p>{error}</p>
              <button onClick={() => fetchBrands(1)} className="brands-page__retry-btn">
                {t('common.tryAgain', 'Try Again')}
              </button>
            </div>
          ) : (
            <>
              {/* Search Bar */}
              <div className="brands-filter-bar">
                <div className="filter-item filter-item--search">
                  <input
                    type="text"
                    placeholder={t('brands.searchByTitle', 'Search by title...')}
                    value={searchTitle}
                    onChange={(e) => setSearchTitle(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
                    className="filter-input"
                  />
                </div>
                
                <button onClick={handleSearch} className="filter-search-btn">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.35-4.35"></path>
                  </svg>
                  {t('common.search', 'Search')}
                </button>
              </div>

              <div className="brands-table-container">
                <table className="brands-table">
                  <thead>
                    <tr>
                      <th style={{width: '25%'}}>{t('brands.brandId', 'Brand ID')}</th>
                      <th className="th-separator" style={{width: '25%'}}>{t('brands.title', 'Title')}</th>
                      <th className="th-separator" style={{width: '25%'}}>{t('brands.image', 'Image')}</th>
                      <th className="th-separator" style={{width: '25%'}}>{t('brands.actions', 'Actions')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {brands.length > 0 ? (
                      brands.map((brand, index) => (
                        <tr key={brand._id} className={index % 2 === 0 ? 'row-even' : 'row-odd'}>
                          <td className="brand-id" style={{width: '25%'}}>#{brand._id.slice(-8)}</td>
                          <td className="brand-title" style={{width: '25%'}}>{brand.title}</td>
                          <td className="brand-image-cell" style={{width: '25%'}}>
                            {brand.image ? (
                              <img 
                                src={getOptimizedImageUrl(brand.image, { width: 96, height: 96, crop: 'fill' })} 
                                alt={brand.title} 
                                className="brand-image"
                              />
                            ) : (
                              <div className="brand-image-placeholder">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>
                                  <line x1="7" y1="7" x2="7.01" y2="7"></line>
                                </svg>
                              </div>
                            )}
                          </td>
                          <td className="brand-actions" style={{width: '25%'}}>
                            <button
                              className="action-btn action-btn--edit"
                              onClick={() => handleEditBrand(brand)}
                              title={t('common.edit', 'Edit')}
                            >
                              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                              </svg>
                            </button>
                            <button
                              className="action-btn action-btn--delete"
                              onClick={() => handleDeleteBrand(brand._id)}
                              title={t('common.delete', 'Delete')}
                            >
                              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                <line x1="10" y1="11" x2="10" y2="17"></line>
                                <line x1="14" y1="11" x2="14" y2="17"></line>
                              </svg>
                            </button>
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={4} className="brands-table__empty">
                          {t('brands.noBrands', 'No brands found')}
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {/* Pagination */}
              {totalPages > 1 && (
                <div className="pagination">
                  <button
                    className="pagination__btn pagination__btn--prev"
                    onClick={() => handlePageChange(currentPage - 1)}
                    disabled={currentPage === 1}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                    {t('pagination.previous', 'Previous')}
                  </button>
                  
                  <div className="pagination__pages">
                    {Array.from({ length: totalPages }, (_, i) => i + 1)
                      .filter(page => {
                        if (totalPages <= 7) return true;
                        if (page === 1 || page === totalPages) return true;
                        if (Math.abs(page - currentPage) <= 1) return true;
                        return false;
                      })
                      .map((page, index, arr) => (
                        <React.Fragment key={page}>
                          {index > 0 && arr[index - 1] !== page - 1 && (
                            <span className="pagination__ellipsis">...</span>
                          )}
                          <button
                            className={`pagination__page ${currentPage === page ? 'pagination__page--active' : ''}`}
                            onClick={() => handlePageChange(page)}
                          >
                            {page}
                          </button>
                        </React.Fragment>
                      ))}
                  </div>
                  
                  <button
                    className="pagination__btn pagination__btn--next"
                    onClick={() => handlePageChange(currentPage + 1)}
                    disabled={currentPage === totalPages}
                  >
                    {t('pagination.next', 'Next')}
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                  </button>
                </div>
              )}

              {/* Page info */}
              {totalBrands > 0 && (
                <div className="pagination-info">
                  {t('pagination.showing', 'Showing')} {(currentPage - 1) * itemsPerPage + 1} - {Math.min(currentPage * itemsPerPage, totalBrands)} {t('pagination.of', 'of')} {totalBrands} {t('pagination.items', 'items')}
                </div>
              )}
            </>
          )}
        </div>
      </div>

      {/* Create/Edit Brand Modal */}
      {isModalOpen && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2>{isEditMode ? t('brands.editBrand', 'Edit Brand') : t('brands.createBrand', 'Create Brand')}</h2>
              <button onClick={closeModal} className="modal-close-btn">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <line x1="18" y1="6" x2="6" y2="18"></line>
                  <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="modal-form">
              {/* Title Field */}
              <div className="form-group">
                <label htmlFor="title">
                  {t('brands.title', 'Title')} <span className="required">*</span>
                </label>
                <input
                  type="text"
                  id="title"
                  name="title"
                  value={formData.title}
                  onChange={handleInputChange}
                  placeholder={t('brands.enterTitle', 'Enter brand title')}
                  className={formErrors.title ? 'error' : ''}
                />
                {formErrors.title && <span className="error-message">{formErrors.title}</span>}
              </div>

              {/* Image Upload Field */}
              <div className="form-group">
                <label>{t('brands.image', 'Image')}</label>
                <div
                  className={`image-drop-zone ${isDragging ? 'dragging' : ''} ${imagePreview ? 'has-image' : ''}`}
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
                        onClick={(e) => { e.stopPropagation(); removeImage(); }}
                      >
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <line x1="18" y1="6" x2="6" y2="18"></line>
                          <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                      </button>
                    </div>
                  ) : (
                    <div className="drop-zone-content">
                      <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="17 8 12 3 7 8"></polyline>
                        <line x1="12" y1="3" x2="12" y2="15"></line>
                      </svg>
                      <p>{t('brands.dragDropImage', 'Drag & drop an image here')}</p>
                      <span>{t('brands.orClickToSelect', 'or click to select')}</span>
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
                <button type="button" onClick={closeModal} className="btn-cancel">
                  {t('common.cancel', 'Cancel')}
                </button>
                <button type="submit" className="btn-submit" disabled={isSubmitting}>
                  {isSubmitting ? (
                    <>
                      <div className="loading-spinner loading-spinner--small"></div>
                      {isEditMode ? t('common.saving', 'Saving...') : t('common.creating', 'Creating...')}
                    </>
                  ) : (
                    isEditMode ? t('brands.saveChanges', 'Save Changes') : t('brands.createBrand', 'Create Brand')
                  )}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {isDeleteModalOpen && (
        <div className="modal-overlay" onClick={cancelDelete}>
          <div className="modal-content modal-content--small" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2>{t('brands.deleteBrand', 'Delete Brand')}</h2>
              <button onClick={cancelDelete} className="modal-close-btn">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <line x1="18" y1="6" x2="6" y2="18"></line>
                  <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
              </button>
            </div>
            <div className="modal-body">
              <p>{t('brands.deleteConfirmation', 'Are you sure you want to delete this brand? This action cannot be undone.')}</p>
              {deleteError && (
                <div className="form-error-banner" style={{ marginTop: '16px' }}>
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                  </svg>
                  <span>{deleteError}</span>
                </div>
              )}
            </div>
            <div className="modal-actions">
              <button type="button" onClick={cancelDelete} className="btn-cancel">
                {t('common.cancel', 'Cancel')}
              </button>
              <button 
                type="button" 
                onClick={confirmDelete} 
                className="btn-submit btn-delete" 
                disabled={isDeleting}
              >
                {isDeleting ? (
                  <>
                    <div className="loading-spinner loading-spinner--small"></div>
                    {t('common.deleting', 'Deleting...')}
                  </>
                ) : (
                  t('common.delete', 'Delete')
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </MainLayout>
  );
};

export default BrandsPage;
