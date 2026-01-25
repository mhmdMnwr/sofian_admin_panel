import React, { useState, useEffect, useCallback, useRef } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import apiClient from '../../core/api/apiClient';
import { Product, ProductsResponse } from '../../core/types';
import './ProductsPage.css';

interface FilterOption {
  _id: string;
  name: string;
}

interface NewProductForm {
  name: string;
  units_num: string;
  price: string;
  category: string;
  brand: string;
  state: string;
  image: File | null;
}

const initialFormState: NewProductForm = {
  name: '',
  units_num: '',
  price: '',
  category: '',
  brand: '',
  state: 'available',
  image: null,
};

const ProductsPage: React.FC = () => {
  const { t } = useTranslation();
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasMore, setHasMore] = useState(true);
  const [totalProducts, setTotalProducts] = useState(0);
  const itemsPerPage = 10;
  
  // Filter states
  const [searchName, setSearchName] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [selectedBrand, setSelectedBrand] = useState('');
  const [selectedState, setSelectedState] = useState('');
  
  // Filter options
  const [categories, setCategories] = useState<FilterOption[]>([]);
  const [brands, setBrands] = useState<FilterOption[]>([]);
  
  // Create product modal states
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [editingProductId, setEditingProductId] = useState<string | null>(null);
  const [formData, setFormData] = useState<NewProductForm>(initialFormState);
  const [formErrors, setFormErrors] = useState<Partial<Record<keyof NewProductForm, string>>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  
  // Delete confirmation state
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [deletingProductId, setDeletingProductId] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  
  // Use refs to avoid stale closures
  const currentPageRef = useRef(1);
  const loadingMoreRef = useRef(false);
  const hasMoreRef = useRef(true);
  const filtersRef = useRef({ name: '', category: '', brand: '', state: '' });
  
  const observerRef = useRef<IntersectionObserver | null>(null);
  const loadMoreRef = useRef<HTMLDivElement>(null);

  // Fetch categories and brands on mount
  useEffect(() => {
    const fetchFilters = async () => {
      try {
        const [categoriesRes, brandsRes] = await Promise.all([
          apiClient.get('/categories'),
          apiClient.get('/brands'),
        ]);
        
        if (categoriesRes.data.status === 'success') {
          setCategories(categoriesRes.data.data.categories || categoriesRes.data.data || []);
        }
        if (brandsRes.data.status === 'success') {
          setBrands(brandsRes.data.data.brands || brandsRes.data.data || []);
        }
      } catch (err) {
        console.error('Error fetching filters:', err);
      }
    };
    
    fetchFilters();
  }, []);

  const fetchProducts = useCallback(async (page: number, append: boolean = false) => {
    // Prevent duplicate requests
    if (loadingMoreRef.current) return;
    
    try {
      if (page === 1) {
        setLoading(true);
      } else {
        setLoadingMore(true);
        loadingMoreRef.current = true;
      }
      setError(null);
      
      // Build params with filters
      const params: Record<string, string | number> = {
        page: page,
        limit: itemsPerPage,
        sort: 'name',
      };
      
      if (filtersRef.current.name) params.name = filtersRef.current.name;
      if (filtersRef.current.category) params.category = filtersRef.current.category;
      if (filtersRef.current.brand) params.brand = filtersRef.current.brand;
      if (filtersRef.current.state) params.state = filtersRef.current.state;
      
      console.log(`Fetching page ${page} with filters:`, params);
      
      const response = await apiClient.get<ProductsResponse>('/products', { params });
      
      console.log('API Response:', response.data);
      
      if (response.data.status === 'success') {
        const newProducts = response.data.data.products;
        const total = response.data.data.totalProducts;
        
        if (total !== undefined) {
          setTotalProducts(total);
        }
        
        if (append) {
          setProducts(prev => {
            const updated = [...prev, ...newProducts];
            const moreAvailable = total !== undefined 
              ? updated.length < total 
              : newProducts.length === itemsPerPage;
            
            setHasMore(moreAvailable);
            hasMoreRef.current = moreAvailable;
            console.log(`Loaded ${updated.length} products, hasMore: ${moreAvailable}`);
            return updated;
          });
        } else {
          setProducts(newProducts);
          const moreAvailable = total !== undefined 
            ? newProducts.length < total 
            : newProducts.length === itemsPerPage;
          
          setHasMore(moreAvailable);
          hasMoreRef.current = moreAvailable;
        }
        
        currentPageRef.current = page;
      }
    } catch (err) {
      setError(t('errors.unknownError', 'An error occurred while fetching products'));
      console.error('Error fetching products:', err);
    } finally {
      setLoading(false);
      setLoadingMore(false);
      loadingMoreRef.current = false;
    }
  }, [t]);

  // Handle search/filter
  const handleSearch = useCallback(() => {
    filtersRef.current = {
      name: searchName,
      category: selectedCategory,
      brand: selectedBrand,
      state: selectedState,
    };
    currentPageRef.current = 1;
    setProducts([]);
    fetchProducts(1, false);
  }, [searchName, selectedCategory, selectedBrand, selectedState, fetchProducts]);

  // Initial load
  useEffect(() => {
    fetchProducts(1, false);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // Intersection Observer for infinite scroll
  useEffect(() => {
    if (loading) return;
    
    const handleIntersect = (entries: IntersectionObserverEntry[]) => {
      if (entries[0].isIntersecting && hasMoreRef.current && !loadingMoreRef.current) {
        const nextPage = currentPageRef.current + 1;
        console.log(`Intersection triggered, loading page ${nextPage}`); // Debug log
        fetchProducts(nextPage, true);
      }
    };
    
    observerRef.current = new IntersectionObserver(handleIntersect, { 
      threshold: 0.1,
      rootMargin: '100px' // Trigger earlier
    });
    
    if (loadMoreRef.current) {
      observerRef.current.observe(loadMoreRef.current);
    }
    
    return () => {
      if (observerRef.current) {
        observerRef.current.disconnect();
      }
    };
  }, [loading, fetchProducts]);

  const getStateClass = (state: string) => {
    return state === 'available' ? 'state--available' : 'state--unavailable';
  };

  const getStateText = (state: string) => {
    return state === 'available' 
      ? t('products.available', 'Available') 
      : t('products.notAvailable', 'Not available');
  };

  // Modal functions
  const openModal = () => {
    setIsModalOpen(true);
    setIsEditMode(false);
    setEditingProductId(null);
    setFormData(initialFormState);
    setFormErrors({});
    setImagePreview(null);
  };

  const closeModal = () => {
    setIsModalOpen(false);
    setIsEditMode(false);
    setEditingProductId(null);
    setFormData(initialFormState);
    setFormErrors({});
    setImagePreview(null);
  };

  // Edit product
  const handleEditProduct = (product: Product) => {
    setIsEditMode(true);
    setEditingProductId(product._id);
    setFormData({
      name: product.name,
      units_num: String(product.units_num ?? 0),
      price: String(product.price),
      category: product.category || '',
      brand: product.brand || '',
      state: product.state,
      image: null,
    });
    setImagePreview(product.image || null);
    setFormErrors({});
    setIsModalOpen(true);
  };

  // Delete product
  const handleDeleteProduct = (productId: string) => {
    setDeletingProductId(productId);
    setIsDeleteModalOpen(true);
  };

  const confirmDelete = async () => {
    if (!deletingProductId) return;
    
    setIsDeleting(true);
    try {
      const response = await apiClient.delete(`/products/${deletingProductId}`);
      
      if (response.data.status === 'success') {
        setIsDeleteModalOpen(false);
        setDeletingProductId(null);
        // Remove product from list
        setProducts(prev => prev.filter(p => p._id !== deletingProductId));
        setTotalProducts(prev => prev - 1);
      }
    } catch (err: any) {
      console.error('Error deleting product:', err);
      alert(err.response?.data?.message || t('errors.unknownError', 'An error occurred'));
    } finally {
      setIsDeleting(false);
    }
  };

  const cancelDelete = () => {
    setIsDeleteModalOpen(false);
    setDeletingProductId(null);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    // Clear error when user types
    if (formErrors[name as keyof NewProductForm]) {
      setFormErrors(prev => ({ ...prev, [name]: undefined }));
    }
  };

  const handleImageChange = (file: File | null) => {
    if (file) {
      // Validate file type
      if (!file.type.startsWith('image/')) {
        setFormErrors(prev => ({ ...prev, image: t('products.invalidImageType', 'Please select a valid image file') }));
        return;
      }
      // Validate file size (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        setFormErrors(prev => ({ ...prev, image: t('products.imageTooLarge', 'Image must be less than 5MB') }));
        return;
      }
      
      setFormData(prev => ({ ...prev, image: file }));
      setFormErrors(prev => ({ ...prev, image: undefined }));
      
      // Create preview
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
    const errors: Partial<Record<keyof NewProductForm, string>> = {};
    
    if (!formData.name.trim()) {
      errors.name = t('products.nameRequired', 'Product name is required');
    }
    if (!formData.units_num || parseInt(formData.units_num) < 0) {
      errors.units_num = t('products.unitsRequired', 'Number of units is required');
    }
    if (!formData.price || parseFloat(formData.price) <= 0) {
      errors.price = t('products.priceRequired', 'Price per unit is required');
    }
    if (!formData.state) {
      errors.state = t('products.stateRequired', 'State is required');
    }
    
    setFormErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) return;
    
    setIsSubmitting(true);
    
    try {
      let response;
      const isEdit = isEditMode && editingProductId;
      const endpoint = isEdit ? `/products/${editingProductId}` : '/products';
      const method = isEdit ? 'patch' : 'post';
      
      if (formData.image) {
        // Use FormData when uploading an image
        const submitData = new FormData();
        submitData.append('name', formData.name.trim());
        submitData.append('units_num', formData.units_num);
        submitData.append('price', formData.price);
        submitData.append('state', formData.state);
        
        if (formData.category) {
          submitData.append('category', formData.category);
        }
        if (formData.brand) {
          submitData.append('brand', formData.brand);
        }
        submitData.append('image', formData.image);
        
        response = await apiClient[method](endpoint, submitData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });
      } else {
        // Use JSON when no image
        const submitData: Record<string, string | number> = {
          name: formData.name.trim(),
          units_num: parseInt(formData.units_num),
          price: parseFloat(formData.price),
          state: formData.state,
        };
        
        if (formData.category) {
          submitData.category = formData.category;
        }
        if (formData.brand) {
          submitData.brand = formData.brand;
        }
        
        response = await apiClient[method](endpoint, submitData);
      }
      
      if (response.data.status === 'success') {
        closeModal();
        // Refresh the products list
        currentPageRef.current = 1;
        setProducts([]);
        fetchProducts(1, false);
      }
    } catch (err: any) {
      console.error('Error saving product:', err);
      setFormErrors(prev => ({ 
        ...prev, 
        name: err.response?.data?.message || t('errors.unknownError', 'An error occurred') 
      }));
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <MainLayout>
      <div className="products-page">
        <div className="products-page__header">
          <div className="products-page__header-left">
            <h1 className="products-page__title">{t('products.title', 'Products')}</h1>
            {totalProducts > 0 && (
              <span className="products-page__count">
                {products.length} / {totalProducts} {t('products.items', 'items')}
              </span>
            )}
          </div>
          <button onClick={openModal} className="products-page__create-btn">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            {t('products.createProduct', 'Create Product')}
          </button>
        </div>

        <div className="products-page__content">
          {loading ? (
            <div className="products-page__loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          ) : error ? (
            <div className="products-page__error">
              <p>{error}</p>
              <button onClick={() => fetchProducts(1, false)} className="products-page__retry-btn">
                {t('common.tryAgain', 'Try Again')}
              </button>
            </div>
          ) : (
            <>
              {/* Search and Filter Bar */}
              <div className="products-filter-bar">
                <div className="filter-item filter-item--search">
                  <input
                    type="text"
                    placeholder={t('products.searchByName', 'Search by name...')}
                    value={searchName}
                    onChange={(e) => setSearchName(e.target.value)}
                    className="filter-input"
                  />
                </div>
                
                <div className="filter-item">
                  <select
                    value={selectedCategory}
                    onChange={(e) => setSelectedCategory(e.target.value)}
                    className="filter-select"
                  >
                    <option value="">{t('products.allCategories', 'All Categories')}</option>
                    {categories.map((cat) => (
                      <option key={cat._id} value={cat.name}>{cat.name}</option>
                    ))}
                  </select>
                </div>
                
                <div className="filter-item">
                  <select
                    value={selectedBrand}
                    onChange={(e) => setSelectedBrand(e.target.value)}
                    className="filter-select"
                  >
                    <option value="">{t('products.allBrands', 'All Brands')}</option>
                    {brands.map((brand) => (
                      <option key={brand._id} value={brand.name}>{brand.name}</option>
                    ))}
                  </select>
                </div>
                
                <div className="filter-item">
                  <select
                    value={selectedState}
                    onChange={(e) => setSelectedState(e.target.value)}
                    className="filter-select"
                  >
                    <option value="">{t('products.allStates', 'All States')}</option>
                    <option value="available">{t('products.available', 'Available')}</option>
                    <option value="not available">{t('products.notAvailable', 'Not available')}</option>
                  </select>
                </div>
                
                <button onClick={handleSearch} className="filter-search-btn">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <circle cx="11" cy="11" r="8"></circle>
                    <path d="m21 21-4.35-4.35"></path>
                  </svg>
                  {t('products.search', 'Search')}
                </button>
              </div>

              <div className="products-table-container">
                <table className="products-table">
                  <thead>
                    <tr>
                      <th>{t('products.productId', 'Product ID')}</th>
                      <th className="th-separator">{t('products.images', 'Images')}</th>
                      <th className="th-separator">{t('products.name', 'Name')}</th>
                      <th className="th-separator">{t('products.unitsNum', 'Units')}</th>
                      <th className="th-separator">{t('products.category', 'Category')}</th>
                      <th className="th-separator">{t('products.brand', 'Brand')}</th>
                      <th className="th-separator">{t('products.price', 'Price')}</th>
                      <th className="th-separator">{t('products.state', 'State')}</th>
                      <th className="th-separator">{t('products.actions', 'Actions')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {products.length > 0 ? (
                      products.map((product, index) => (
                        <tr key={product._id} className={index % 2 === 0 ? 'row-even' : 'row-odd'}>
                          <td className="product-id">#{product._id.slice(-8)}</td>
                          <td className="product-image-cell">
                            {product.image ? (
                              <img 
                                src={product.image} 
                                alt={product.name} 
                                className="product-image"
                              />
                            ) : (
                              <div className="product-image-placeholder">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                  <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                  <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                  <polyline points="21 15 16 10 5 21"></polyline>
                                </svg>
                              </div>
                            )}
                          </td>
                          <td className="product-name">{product.name}</td>
                          <td className="product-units">{product.units_num ?? 0}</td>
                          <td className="product-category">{product.category || '-'}</td>
                          <td className="product-brand">{product.brand || '-'}</td>
                          <td className="product-price">{product.price.toFixed(2)} DA</td>
                          <td>
                            <span className={`product-state ${getStateClass(product.state)}`}>
                              {getStateText(product.state)}
                            </span>
                          </td>
                          <td className="product-actions">
                            <button
                              className="action-btn action-btn--edit"
                              onClick={() => handleEditProduct(product)}
                              title={t('common.edit', 'Edit')}
                            >
                              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                              </svg>
                            </button>
                            <button
                              className="action-btn action-btn--delete"
                              onClick={() => handleDeleteProduct(product._id)}
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
                        <td colSpan={9} className="products-table__empty">
                          {t('products.noProducts', 'No products found')}
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {/* Infinite scroll trigger */}
              <div ref={loadMoreRef} className="products-page__load-more">
                {loadingMore && (
                  <div className="products-page__loading-more">
                    <div className="loading-spinner loading-spinner--small"></div>
                    <span>{t('common.loading', 'Loading...')}</span>
                  </div>
                )}
                {!hasMore && products.length > 0 && (
                  <div className="products-page__end-message">
                    {t('products.allLoaded', 'All products loaded')}
                  </div>
                )}
              </div>
            </>
          )}
        </div>
      </div>

      {/* Create/Edit Product Modal */}
      {isModalOpen && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2>{isEditMode ? t('products.editProduct', 'Edit Product') : t('products.createProduct', 'Create Product')}</h2>
              <button onClick={closeModal} className="modal-close-btn">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <line x1="18" y1="6" x2="6" y2="18"></line>
                  <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="modal-form">
              {/* Name Field */}
              <div className="form-group">
                <label htmlFor="name">
                  {t('products.name', 'Name')} <span className="required">*</span>
                </label>
                <input
                  type="text"
                  id="name"
                  name="name"
                  value={formData.name}
                  onChange={handleInputChange}
                  placeholder={t('products.enterName', 'Enter product name')}
                  className={formErrors.name ? 'error' : ''}
                />
                {formErrors.name && <span className="error-message">{formErrors.name}</span>}
              </div>

              {/* Units Number Field */}
              <div className="form-group">
                <label htmlFor="units_num">
                  {t('products.unitsNum', 'Units')} <span className="required">*</span>
                </label>
                <input
                  type="number"
                  id="units_num"
                  name="units_num"
                  value={formData.units_num}
                  onChange={handleInputChange}
                  placeholder={t('products.enterUnits', 'Enter number of units')}
                  min="0"
                  className={formErrors.units_num ? 'error' : ''}
                />
                {formErrors.units_num && <span className="error-message">{formErrors.units_num}</span>}
              </div>

              {/* Price Field */}
              <div className="form-group">
                <label htmlFor="price">
                  {t('products.pricePerUnit', 'Price per unit')} <span className="required">*</span>
                </label>
                <input
                  type="number"
                  id="price"
                  name="price"
                  value={formData.price}
                  onChange={handleInputChange}
                  placeholder={t('products.enterPrice', 'Enter price')}
                  min="0"
                  step="0.01"
                  className={formErrors.price ? 'error' : ''}
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
                  onChange={handleInputChange}
                >
                  <option value="">{t('products.selectCategory', 'Select category')}</option>
                  {categories.map((cat) => (
                    <option key={cat._id} value={cat.name}>{cat.name}</option>
                  ))}
                </select>
              </div>

              {/* Brand Field */}
              <div className="form-group">
                <label htmlFor="brand">{t('products.brand', 'Brand')}</label>
                <select
                  id="brand"
                  name="brand"
                  value={formData.brand}
                  onChange={handleInputChange}
                >
                  <option value="">{t('products.selectBrand', 'Select brand')}</option>
                  {brands.map((brand) => (
                    <option key={brand._id} value={brand.name}>{brand.name}</option>
                  ))}
                </select>
              </div>

              {/* State Field */}
              <div className="form-group">
                <label htmlFor="state">
                  {t('products.state', 'State')} <span className="required">*</span>
                </label>
                <select
                  id="state"
                  name="state"
                  value={formData.state}
                  onChange={handleInputChange}
                  className={formErrors.state ? 'error' : ''}
                >
                  <option value="available">{t('products.available', 'Available')}</option>
                  <option value="not available">{t('products.notAvailable', 'Not available')}</option>
                </select>
                {formErrors.state && <span className="error-message">{formErrors.state}</span>}
              </div>

              {/* Image Upload Field */}
              <div className="form-group">
                <label>{t('products.image', 'Image')}</label>
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
                      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
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
                    isEditMode ? t('products.saveChanges', 'Save Changes') : t('products.createProduct', 'Create Product')
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
              <h2>{t('products.deleteProduct', 'Delete Product')}</h2>
              <button onClick={cancelDelete} className="modal-close-btn">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <line x1="18" y1="6" x2="6" y2="18"></line>
                  <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
              </button>
            </div>
            <div className="modal-body">
              <p>{t('products.deleteConfirmation', 'Are you sure you want to delete this product? This action cannot be undone.')}</p>
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

export default ProductsPage;
