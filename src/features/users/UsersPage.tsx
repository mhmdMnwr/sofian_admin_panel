import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { Pagination, ConfirmModal } from '../../components/common';
import { UserFilters, UserTable, UserInfoModal, UserOrdersModal } from './components';
import apiClient from '../../core/api/apiClient';
import { User, UsersResponse, Order, OrdersResponse } from '../../core/types';
import './UsersPage.css';

// Constants
const ITEMS_PER_PAGE = 10;

const UsersPage: React.FC = () => {
  const { t } = useTranslation();

  // Data state
  const [users, setUsers] = useState<User[]>([]);

  // Loading & error state
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalUsers, setTotalUsers] = useState(0);

  // Filter state
  const [searchName, setSearchName] = useState('');
  const [selectedStatus, setSelectedStatus] = useState('');

  // Info modal state
  const [isInfoModalOpen, setIsInfoModalOpen] = useState(false);
  const [viewingUser, setViewingUser] = useState<User | null>(null);

  // Orders modal state
  const [isOrdersModalOpen, setIsOrdersModalOpen] = useState(false);
  const [ordersUser, setOrdersUser] = useState<User | null>(null);
  const [userOrders, setUserOrders] = useState<Order[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [ordersError, setOrdersError] = useState<string | null>(null);
  const [ordersCurrentPage, setOrdersCurrentPage] = useState(1);
  const [ordersTotalPages, setOrdersTotalPages] = useState(1);

  // Toggle status state
  const [togglingUserId, setTogglingUserId] = useState<string | null>(null);
  const [isToggleModalOpen, setIsToggleModalOpen] = useState(false);
  const [userToToggle, setUserToToggle] = useState<User | null>(null);

  // Fetch users
  const fetchUsers = useCallback(
    async (page: number = currentPage) => {
      try {
        setLoading(true);
        setError(null);

        const params: Record<string, string | number> = {
          page,
          limit: ITEMS_PER_PAGE,
          role: 'customer',
        };

        if (searchName) params.name = searchName;
        if (selectedStatus) params.status = selectedStatus;

        const response = await apiClient.get<UsersResponse>('/users', { params });

        if (response.data.status === 'success') {
          const fetchedUsers = response.data.data || [];
          setUsers(fetchedUsers);

          const meta = response.data.meta;
          if (meta) {
            setTotalUsers(meta.totalItems ?? fetchedUsers.length);
            setTotalPages(
              meta.totalPages ??
                Math.ceil((meta.totalItems ?? fetchedUsers.length) / ITEMS_PER_PAGE)
            );
            setCurrentPage(meta.page ?? page);
          } else {
            setTotalUsers(fetchedUsers.length);
            setTotalPages(1);
            setCurrentPage(page);
          }
        }
      } catch (err) {
        setError(t('errors.unknownError', 'An error occurred while fetching users'));
        console.error('Error fetching users:', err);
      } finally {
        setLoading(false);
      }
    },
    [t, searchName, selectedStatus, currentPage]
  );

  // Fetch user orders
  const fetchUserOrders = useCallback(
    async (username: string, page: number = 1) => {
      try {
        setOrdersLoading(true);
        setOrdersError(null);

        const params: Record<string, string | number> = {
          page,
          limit: 10,
          name: username,
          populate: 'items.productId',
        };

        const response = await apiClient.get<OrdersResponse>('/orders', { params });

        if (response.data.status === 'success') {
          const fetchedOrders = response.data.data || [];
          setUserOrders(fetchedOrders);

          const meta = response.data.meta;
          if (meta) {
            setOrdersTotalPages(meta.totalPages ?? 1);
            setOrdersCurrentPage(meta.page ?? page);
          } else {
            setOrdersTotalPages(1);
            setOrdersCurrentPage(page);
          }
        }
      } catch (err) {
        setOrdersError(t('errors.unknownError', 'An error occurred while fetching orders'));
        console.error('Error fetching user orders:', err);
      } finally {
        setOrdersLoading(false);
      }
    },
    [t]
  );

  // Initial load
  useEffect(() => {
    fetchUsers(1);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // Event handlers
  const handleSearch = () => {
    setCurrentPage(1);
    fetchUsers(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    fetchUsers(page);
  };

  // Info modal handlers
  const handleViewInfo = (user: User) => {
    setViewingUser(user);
    setIsInfoModalOpen(true);
  };

  const closeInfoModal = () => {
    setIsInfoModalOpen(false);
    setViewingUser(null);
  };

  // Orders modal handlers
  const handleViewOrders = (user: User) => {
    setOrdersUser(user);
    setUserOrders([]);
    setOrdersCurrentPage(1);
    setOrdersTotalPages(1);
    setIsOrdersModalOpen(true);
    fetchUserOrders(user.username, 1);
  };

  const closeOrdersModal = () => {
    setIsOrdersModalOpen(false);
    setOrdersUser(null);
    setUserOrders([]);
    setOrdersError(null);
  };

  const handleOrdersPageChange = (page: number) => {
    if (ordersUser) {
      setOrdersCurrentPage(page);
      fetchUserOrders(ordersUser.username, page);
    }
  };

  // Toggle status handlers
  const handleToggleStatusClick = (user: User) => {
    setUserToToggle(user);
    setIsToggleModalOpen(true);
  };

  const closeToggleModal = () => {
    setIsToggleModalOpen(false);
    setUserToToggle(null);
  };

  const handleConfirmToggleStatus = async () => {
    if (!userToToggle) return;

    try {
      setTogglingUserId(userToToggle._id);
      closeToggleModal();

      const response = await apiClient.patch(`/users/toggleStatus/${userToToggle._id}`);

      if (response.data.status === 'success') {
        // Update local state
        setUsers((prev) =>
          prev.map((u) =>
            u._id === userToToggle._id
              ? { ...u, status: u.status === 'active' ? 'inactive' : 'active' }
              : u
          )
        );
      }
    } catch (err) {
      console.error('Error toggling user status:', err);
      // Could show a toast/notification here
    } finally {
      setTogglingUserId(null);
    }
  };

  return (
    <MainLayout>
      <div className="users-page">
        {/* Header */}
        <div className="users-page__header">
          <div className="users-page__header-left">
            <h1 className="users-page__title">{t('users.title', 'Customers')}</h1>
            <span className="users-page__count">
              {t('users.totalCount', '{{count}} customers', { count: totalUsers })}
            </span>
          </div>
        </div>

        {/* Content */}
        <div className="users-page__content">
          {/* Filters */}
          <UserFilters
            searchName={searchName}
            selectedStatus={selectedStatus}
            onSearchNameChange={setSearchName}
            onStatusChange={setSelectedStatus}
            onSearch={handleSearch}
          />

          {/* Loading State */}
          {loading && (
            <div className="users-page__loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          )}

          {/* Error State */}
          {error && !loading && (
            <div className="users-page__error">
              <p>{error}</p>
              <button className="users-page__retry-btn" onClick={() => fetchUsers(currentPage)}>
                {t('common.retry', 'Retry')}
              </button>
            </div>
          )}

          {/* Table */}
          {!loading && !error && (
            <>
              <UserTable
                users={users}
                onViewInfo={handleViewInfo}
                onViewOrders={handleViewOrders}
                onToggleStatus={handleToggleStatusClick}
                togglingUserId={togglingUserId}
              />

              {/* Pagination */}
              {totalPages > 1 && (
                <div className="users-page__pagination">
                  <Pagination
                    currentPage={currentPage}
                    totalPages={totalPages}
                    onPageChange={handlePageChange}
                  />
                </div>
              )}
            </>
          )}
        </div>

        {/* Info Modal */}
        <UserInfoModal
          isOpen={isInfoModalOpen}
          user={viewingUser}
          onClose={closeInfoModal}
        />

        {/* Orders Modal */}
        <UserOrdersModal
          isOpen={isOrdersModalOpen}
          user={ordersUser}
          orders={userOrders}
          loading={ordersLoading}
          error={ordersError}
          currentPage={ordersCurrentPage}
          totalPages={ordersTotalPages}
          onPageChange={handleOrdersPageChange}
          onClose={closeOrdersModal}
        />

        {/* Toggle Status Confirmation Modal */}
        <ConfirmModal
          isOpen={isToggleModalOpen}
          title={t('users.toggleStatusTitle', 'Toggle Status')}
          message={
            userToToggle
              ? t(
                  'users.toggleStatusConfirmation',
                  'Are you sure you want to change {{name}}\'s status from {{currentStatus}} to {{newStatus}}?',
                  {
                    name: userToToggle.username,
                    currentStatus: userToToggle.status === 'active' ? t('users.active', 'Active') : t('users.inactive', 'Inactive'),
                    newStatus: userToToggle.status === 'active' ? t('users.inactive', 'Inactive') : t('users.active', 'Active'),
                  }
                )
              : ''
          }
          confirmText={t('common.confirm', 'Confirm')}
          cancelText={t('common.cancel', 'Cancel')}
          onConfirm={handleConfirmToggleStatus}
          onClose={closeToggleModal}
          variant="warning"
        />
      </div>
    </MainLayout>
  );
};

export default UsersPage;
