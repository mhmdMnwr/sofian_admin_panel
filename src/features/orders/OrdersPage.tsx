import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { Pagination, ConfirmModal } from '../../components/common';
import { OrderFilters, OrderTable, OrderViewModal, OrderEditModal, EditableOrderItem } from './components';
import apiClient from '../../core/api/apiClient';
import { Order, OrdersResponse, OrderStatus } from '../../core/types';
import './OrdersPage.css';

// Constants
const ITEMS_PER_PAGE = 10;

const OrdersPage: React.FC = () => {
  const { t } = useTranslation();

  // Data state
  const [orders, setOrders] = useState<Order[]>([]);

  // Loading & error state
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalOrders, setTotalOrders] = useState(0);

  // Filter state
  const [searchUsername, setSearchUsername] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');

  // View modal state
  const [isViewModalOpen, setIsViewModalOpen] = useState(false);
  const [viewingOrder, setViewingOrder] = useState<Order | null>(null);

  // Edit modal state
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [editingOrder, setEditingOrder] = useState<Order | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [editError, setEditError] = useState<string | null>(null);

  // Delete modal state
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
  const [deletingOrderId, setDeletingOrderId] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  // Fetch orders
  const fetchOrders = useCallback(
    async (page: number = currentPage) => {
      try {
        setLoading(true);
        setError(null);

        const params: Record<string, string | number> = {
          page,
          limit: ITEMS_PER_PAGE,
          populate: 'items.productId,customerId',
        };

        if (searchUsername) params.username = searchUsername;
        if (selectedStatus) params.status = selectedStatus;
        if (startDate) params.startDate = startDate;
        if (endDate) params.endDate = endDate;

        const response = await apiClient.get<OrdersResponse>('/orders', { params });

        if (response.data.status === 'success') {
          const fetchedOrders = response.data.data || [];
          setOrders(fetchedOrders);

          const meta = response.data.meta;
          if (meta) {
            setTotalOrders(meta.totalItems ?? fetchedOrders.length);
            setTotalPages(
              meta.totalPages ??
                Math.ceil((meta.totalItems ?? fetchedOrders.length) / ITEMS_PER_PAGE)
            );
            setCurrentPage(meta.page ?? page);
          } else {
            setTotalOrders(fetchedOrders.length);
            setTotalPages(1);
            setCurrentPage(page);
          }
        }
      } catch (err) {
        setError(t('errors.unknownError', 'An error occurred while fetching orders'));
        console.error('Error fetching orders:', err);
      } finally {
        setLoading(false);
      }
    },
    [t, searchUsername, selectedStatus, startDate, endDate, currentPage]
  );

  // Initial load
  useEffect(() => {
    fetchOrders(1);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // Event handlers
  const handleSearch = () => {
    setCurrentPage(1);
    fetchOrders(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    fetchOrders(page);
  };

  // View modal handlers
  const handleViewOrder = (order: Order) => {
    setViewingOrder(order);
    setIsViewModalOpen(true);
  };

  const closeViewModal = () => {
    setIsViewModalOpen(false);
    setViewingOrder(null);
  };

  // Edit modal handlers
  const handleEditOrder = (order: Order) => {
    setEditingOrder(order);
    setEditError(null);
    setIsEditModalOpen(true);
  };

  const closeEditModal = () => {
    setIsEditModalOpen(false);
    setEditingOrder(null);
    setEditError(null);
  };

  const handleUpdateOrder = async (status: OrderStatus, items: EditableOrderItem[]) => {
    if (!editingOrder) return;

    setIsSubmitting(true);
    setEditError(null);

    try {
      // First, update the status if changed
      if (status !== editingOrder.status) {
        const statusResponse = await apiClient.patch(`/orders/updateStatus/${editingOrder._id}`, {
          status,
        });

        if (statusResponse.data.status !== 'success') {
          setEditError(statusResponse.data.message || t('errors.unknownError', 'An error occurred'));
          setIsSubmitting(false);
          return;
        }
      }

      // Check if items have changed (different count, quantities, prices, or products)
      const originalItems = editingOrder.items;
      const itemsChanged = 
        items.length !== originalItems.length ||
        items.some((item, index) => {
          const originalItem = originalItems[index];
          if (!originalItem) return true;
          const originalProductId = typeof originalItem.productId === 'object' 
            ? originalItem.productId._id 
            : originalItem.productId;
          return (
            item.productId !== originalProductId ||
            item.quantity !== originalItem.quantity || 
            item.price !== originalItem.price
          );
        });

      // Update items if changed
      if (itemsChanged) {
        const itemsPayload = items.map((item) => ({
          productId: item.productId,
          quantity: item.quantity,
          price: item.price,
        }));

        const contentResponse = await apiClient.patch(`/orders/updateContent/${editingOrder._id}`, {
          items: itemsPayload,
        });

        if (contentResponse.data.status !== 'success') {
          setEditError(contentResponse.data.message || t('errors.unknownError', 'An error occurred'));
          setIsSubmitting(false);
          return;
        }
      }

      closeEditModal();
      fetchOrders(currentPage);
    } catch (err: unknown) {
      console.error('Error updating order:', err);
      setEditError(
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
          t('errors.unknownError', 'An error occurred')
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  // Delete modal handlers
  const handleDeleteOrder = (orderId: string) => {
    setDeletingOrderId(orderId);
    setDeleteError(null);
    setIsDeleteModalOpen(true);
  };

  const confirmDelete = async () => {
    if (!deletingOrderId) return;

    setIsDeleting(true);
    setDeleteError(null);

    try {
      const response = await apiClient.delete(`/orders/${deletingOrderId}`);

      if (response.data.status === 'success') {
        setIsDeleteModalOpen(false);
        setDeletingOrderId(null);
        setOrders((prev) => prev.filter((o) => o._id !== deletingOrderId));
        setTotalOrders((prev) => prev - 1);
      } else {
        setDeleteError(response.data.message || t('errors.unknownError', 'An error occurred'));
      }
    } catch (err: unknown) {
      console.error('Error deleting order:', err);
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
    setDeletingOrderId(null);
    setDeleteError(null);
  };

  // Render
  return (
    <MainLayout>
      <div className="orders-page">
        {/* Header */}
        <div className="orders-page__header">
          <div className="orders-page__header-left">
            <h1 className="orders-page__title">{t('orders.title', 'Orders')}</h1>
            {totalOrders > 0 && (
              <span className="orders-page__count">
                {totalOrders} {t('orders.items', 'items')}
              </span>
            )}
          </div>
        </div>

        {/* Content */}
        <div className="orders-page__content">
          {loading ? (
            <div className="orders-page__loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          ) : error ? (
            <div className="orders-page__error">
              <p>{error}</p>
              <button onClick={() => fetchOrders(1)} className="orders-page__retry-btn">
                {t('common.tryAgain', 'Try Again')}
              </button>
            </div>
          ) : (
            <>
              <OrderFilters
                searchUsername={searchUsername}
                selectedStatus={selectedStatus}
                startDate={startDate}
                endDate={endDate}
                onSearchUsernameChange={setSearchUsername}
                onStatusChange={setSelectedStatus}
                onStartDateChange={setStartDate}
                onEndDateChange={setEndDate}
                onSearch={handleSearch}
              />

              <OrderTable
                orders={orders}
                onView={handleViewOrder}
                onEdit={handleEditOrder}
              />

              <div className="orders-page__footer">
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

      {/* View Order Modal */}
      <OrderViewModal
        isOpen={isViewModalOpen}
        order={viewingOrder}
        onClose={closeViewModal}
      />

      {/* Edit Order Modal */}
      <OrderEditModal
        isOpen={isEditModalOpen}
        order={editingOrder}
        isSubmitting={isSubmitting}
        error={editError}
        onClose={closeEditModal}
        onSubmit={handleUpdateOrder}
      />

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={isDeleteModalOpen}
        onClose={cancelDelete}
        onConfirm={confirmDelete}
        title={t('orders.deleteOrder', 'Delete Order')}
        message={t(
          'orders.deleteConfirmation',
          'Are you sure you want to delete this order? This action cannot be undone.'
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

export default OrdersPage;
