import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { Pagination, ConfirmModal } from '../../components/common';
import { ProductFilters, ProductTable, ProductFormModal, ProductFormData } from './components';
import apiClient from '../../core/api/apiClient';
import { Product, ProductsResponse } from '../../core/types';
import { uploadToCloudinary, getOptimizedImageUrl, deleteFromCloudinary } from '../../core/services/cloudinaryService';
import './ProductsPage.css';

// Types
interface FilterOption {
  _id: string;
  title: string;
}

// Constants
const ITEMS_PER_PAGE = 10;

const INITIAL_FORM_STATE: ProductFormData = {
  title: '',
  units: '',
  price: '',
  category: '',
  brand: '',
  state: 'available',
  image: null,
};

const ProductsPage: React.FC = () => {
  const { t } = useTranslation();

  // Data state
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<FilterOption[]>([]);
  const [brands, setBrands] = useState<FilterOption[]>([]);

  // Loading & error state
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalProducts, setTotalProducts] = useState(0);

  // Filter state
  const [searchName, setSearchName] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [selectedBrand, setSelectedBrand] = useState('');
  const [selectedState, setSelectedState] = useState('');

  // Form modal state
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [editingProductId, setEditingProductId] = useState<string | null>(null);
  const [formData, setFormData] = useState<ProductFormData>(INITIAL_FORM_STATE);
  const [formErrors, setFormErrors] = useState<Partial<Record<keyof ProductFormData, string>>>({});
  const [generalError, setGeneralError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  // Delete modal state
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [deletingProductId, setDeletingProductId] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  // Fetch filter options on mount
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

  // Fetch products
  const fetchProducts = useCallback(
    async (page: number = currentPage) => {
      try {
        setLoading(true);
        setError(null);

        const params: Record<string, string | number> = {
          page,
          limit: ITEMS_PER_PAGE,
          sort: 'title',
        };

        if (searchName) params.title = searchName;
        if (selectedCategory) params.category = selectedCategory;
        if (selectedBrand) params.brand = selectedBrand;
        if (selectedState) params.state = selectedState;

        const response = await apiClient.get<ProductsResponse>('/products', { params });

        if (response.data.status === 'success') {
          const fetchedProducts = response.data.data || [];
          setProducts(fetchedProducts);

          const meta = response.data.meta;
          if (meta) {
            setTotalProducts(meta.totalItems ?? fetchedProducts.length);
            setTotalPages(
              meta.totalPages ??
                Math.ceil((meta.totalItems ?? fetchedProducts.length) / ITEMS_PER_PAGE)
            );
            setCurrentPage(meta.page ?? page);
          } else {
            setTotalProducts(fetchedProducts.length);
            setTotalPages(1);
            setCurrentPage(page);
          }
        }
      } catch (err) {
        setError(t('errors.unknownError', 'An error occurred while fetching products'));
        console.error('Error fetching products:', err);
      } finally {
        setLoading(false);
      }
    },
    [t, searchName, selectedCategory, selectedBrand, selectedState, currentPage]
  );

  // Initial load
  useEffect(() => {
    fetchProducts(1);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // Event handlers
  const handleSearch = () => {
    setCurrentPage(1);
    fetchProducts(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    fetchProducts(page);
  };

  // Modal handlers
  const resetFormState = () => {
    setFormData(INITIAL_FORM_STATE);
    setFormErrors({});
    setGeneralError(null);
    setImagePreview(null);
    setIsEditMode(false);
    setEditingProductId(null);
  };

  const openCreateModal = () => {
    resetFormState();
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
    resetFormState();
  };

  const handleEditProduct = (product: Product) => {
    const categoryId =
      product.category && typeof product.category === 'object'
        ? product.category._id
        : product.category || '';
    const brandId =
      product.brand && typeof product.brand === 'object'
        ? product.brand._id
        : product.brand || '';

    setFormData({
      title: product.title,
      units: String(product.units ?? 0),
      price: String(product.price),
      category: categoryId,
      brand: brandId,
      state: product.state,
      image: null,
    });
    setImagePreview(product.image || null);
    setFormErrors({});
    setGeneralError(null);
    setIsEditMode(true);
    setEditingProductId(product._id);
    setIsModalOpen(true);
  };

  // Form handlers
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
    if (formErrors[name as keyof ProductFormData]) {
      setFormErrors((prev) => ({ ...prev, [name]: undefined }));
    }
  };

  const handleImageChange = (file: File | null) => {
    if (file) {
      if (!file.type.startsWith('image/')) {
        setFormErrors((prev) => ({
          ...prev,
          image: t('products.invalidImageType', 'Please select a valid image file'),
        }));
        return;
      }
      if (file.size > 5 * 1024 * 1024) {
        setFormErrors((prev) => ({
          ...prev,
          image: t('products.imageTooLarge', 'Image must be less than 5MB'),
        }));
        return;
      }

      setFormData((prev) => ({ ...prev, image: file }));
      setFormErrors((prev) => ({ ...prev, image: undefined }));

      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleRemoveImage = () => {
    setFormData((prev) => ({ ...prev, image: null }));
    setImagePreview(null);
  };

  const validateForm = (): boolean => {
    const errors: Partial<Record<keyof ProductFormData, string>> = {};

    if (!formData.title.trim()) {
      errors.title = t('products.titleRequired', 'Product title is required');
    }
    if (!formData.units || parseInt(formData.units) < 1) {
      errors.units = t('products.unitsRequired', 'Number of units is required (minimum 1)');
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
    setGeneralError(null);

    try {
      const isEdit = isEditMode && editingProductId;
      const endpoint = isEdit ? `/products/${editingProductId}` : '/products';
      const method = isEdit ? 'patch' : 'post';

      // Prepare submit data
      const submitData: Record<string, string | number | null> = {
        title: formData.title.trim(),
        units: parseInt(formData.units),
        price: parseFloat(formData.price),
        state: formData.state,
      };

      if (isEdit) {
        submitData.category = formData.category || null;
        submitData.brand = formData.brand || null;
      } else {
        submitData.categoryID = formData.category || null;
        submitData.brandID = formData.brand || null;
      }

      // Upload image to Cloudinary if a new image is selected
      if (formData.image) {
        // Delete old image from Cloudinary if updating
        if (isEdit && imagePreview) {
          await deleteFromCloudinary(imagePreview);
        }
        
        const uploadResult = await uploadToCloudinary(formData.image, 'products');
        
        if (!uploadResult.success) {
          setFormErrors((prev) => ({
            ...prev,
            image: uploadResult.error || t('errors.imageUploadFailed', 'Failed to upload image'),
          }));
          setIsSubmitting(false);
          return;
        }
        
        submitData.image = uploadResult.url || null;
      }

      const response = await apiClient[method](endpoint, submitData);

      if (response.data.status === 'success') {
        closeModal();
        setCurrentPage(1);
        fetchProducts(1);
      } else {
        setGeneralError(response.data.message || t('errors.unknownError', 'An error occurred'));
      }
    } catch (err: unknown) {
      console.error('Error saving product:', err);
      const errorMessage =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        t('errors.unknownError', 'An error occurred');
      setGeneralError(errorMessage);
    } finally {
      setIsSubmitting(false);
    }
  };

  // Delete handlers
  const handleDeleteProduct = (productId: string) => {
    setDeletingProductId(productId);
    setDeleteError(null);
    setIsDeleteModalOpen(true);
  };

  const confirmDelete = async () => {
    if (!deletingProductId) return;

    setIsDeleting(true);
    setDeleteError(null);

    try {
      // Find the product to get its image URL before deletion
      const productToDelete = products.find(p => p._id === deletingProductId);
      
      const response = await apiClient.delete(`/products/${deletingProductId}`);

      if (response.data.status === 'success') {
        // Delete image from Cloudinary if exists
        if (productToDelete?.image) {
          await deleteFromCloudinary(productToDelete.image);
        }
        
        setIsDeleteModalOpen(false);
        setDeletingProductId(null);
        setProducts((prev) => prev.filter((p) => p._id !== deletingProductId));
        setTotalProducts((prev) => prev - 1);
      } else {
        setDeleteError(response.data.message || t('errors.unknownError', 'An error occurred'));
      }
    } catch (err: unknown) {
      console.error('Error deleting product:', err);
      setDeleteError(
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
          t('errors.unknownError', 'An error occurred')
      );
    } finally {
      setIsDeleting(false);
    }
  };

  const cancelDelete = () => {
    setIsDeleteModalOpen(false);
    setDeletingProductId(null);
    setDeleteError(null);
  };

  // Render
  return (
    <MainLayout>
      <div className="products-page">
        {/* Header */}
        <div className="products-page__header">
          <div className="products-page__header-left">
            <h1 className="products-page__title">{t('products.title', 'Products')}</h1>
            {totalProducts > 0 && (
              <span className="products-page__count">
                {products.length} / {totalProducts} {t('products.items', 'items')}
              </span>
            )}
          </div>
          <button onClick={openCreateModal} className="products-page__create-btn">
            <svg
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <line x1="12" y1="5" x2="12" y2="19"></line>
              <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            {t('products.createProduct', 'Create Product')}
          </button>
        </div>

        {/* Content */}
        <div className="products-page__content">
          {loading ? (
            <div className="products-page__loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          ) : error ? (
            <div className="products-page__error">
              <p>{error}</p>
              <button onClick={() => fetchProducts(1)} className="products-page__retry-btn">
                {t('common.tryAgain', 'Try Again')}
              </button>
            </div>
          ) : (
            <>
              <ProductFilters
                searchName={searchName}
                selectedCategory={selectedCategory}
                selectedBrand={selectedBrand}
                selectedState={selectedState}
                categories={categories}
                brands={brands}
                onSearchNameChange={setSearchName}
                onCategoryChange={setSelectedCategory}
                onBrandChange={setSelectedBrand}
                onStateChange={setSelectedState}
                onSearch={handleSearch}
              />

              <ProductTable
                products={products}
                onEdit={handleEditProduct}
                onDelete={handleDeleteProduct}
              />

              <div className="products-page__footer">
                <Pagination
                  currentPage={currentPage}
                  totalPages={totalPages}
                  onPageChange={handlePageChange}
                />
              </div>
            </>
          )}
        </div>
      </div>

      {/* Product Form Modal */}
      <ProductFormModal
        isOpen={isModalOpen}
        isEditMode={isEditMode}
        formData={formData}
        formErrors={formErrors}
        generalError={generalError}
        isSubmitting={isSubmitting}
        imagePreview={imagePreview}
        categories={categories}
        brands={brands}
        onClose={closeModal}
        onSubmit={handleSubmit}
        onInputChange={handleInputChange}
        onImageChange={handleImageChange}
        onRemoveImage={handleRemoveImage}
      />

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={isDeleteModalOpen}
        onClose={cancelDelete}
        onConfirm={confirmDelete}
        title={t('products.deleteProduct', 'Delete Product')}
        message={t(
          'products.deleteConfirmation',
          'Are you sure you want to delete this product? This action cannot be undone.'
        )}
        confirmText={t('common.delete', 'Delete')}
        cancelText={t('common.cancel', 'Cancel')}
        isLoading={isDeleting}
        loadingText={t('common.deleting', 'Deleting...')}
        error={deleteError}
        variant="danger"
      />
    </MainLayout>
  );
};

export default ProductsPage;
