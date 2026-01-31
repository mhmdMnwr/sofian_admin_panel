import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { ConfirmModal } from '../../components/common';
import { ManagerCard, ManagerFormModal } from './components';
import apiClient from '../../core/api/apiClient';
import { User, UsersResponse } from '../../core/types';
import './ManagersPage.css';

export interface ManagerFormData {
  username: string;
  password: string;
  phone: string;
  address: string;
}

const ManagersPage: React.FC = () => {
  const { t } = useTranslation();

  // Data state
  const [managers, setManagers] = useState<User[]>([]);

  // Loading & error state
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Form modal state
  const [isFormModalOpen, setIsFormModalOpen] = useState(false);
  const [editingManager, setEditingManager] = useState<User | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);

  // Toggle status state
  const [isToggleModalOpen, setIsToggleModalOpen] = useState(false);
  const [managerToToggle, setManagerToToggle] = useState<User | null>(null);
  const [togglingManagerId, setTogglingManagerId] = useState<string | null>(null);

  // Fetch managers
  const fetchManagers = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const params = {
        role: 'manager',
        limit: 100, // Get all managers
      };

      const response = await apiClient.get<UsersResponse>('/users', { params });

      if (response.data.status === 'success') {
        setManagers(response.data.data || []);
      }
    } catch (err) {
      setError(t('errors.unknownError', 'An error occurred while fetching managers'));
      console.error('Error fetching managers:', err);
    } finally {
      setLoading(false);
    }
  }, [t]);

  // Initial load
  useEffect(() => {
    fetchManagers();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // Add manager handler
  const handleAddManager = () => {
    setEditingManager(null);
    setFormError(null);
    setIsFormModalOpen(true);
  };

  // Edit manager handler
  const handleEditManager = (manager: User) => {
    setEditingManager(manager);
    setFormError(null);
    setIsFormModalOpen(true);
  };

  // Close form modal
  const closeFormModal = () => {
    setIsFormModalOpen(false);
    setEditingManager(null);
    setFormError(null);
  };

  // Submit form (create or update)
  const handleFormSubmit = async (data: ManagerFormData) => {
    setIsSubmitting(true);
    setFormError(null);

    try {
      if (editingManager) {
        // Update existing manager
        const updateData: Record<string, string> = {
          username: data.username,
          phone: data.phone,
          address: data.address,
        };
        
        // Only include password if provided
        if (data.password) {
          updateData.password = data.password;
        }

        const response = await apiClient.patch(
          `/users/updateManager/${editingManager._id}`,
          updateData
        );

        if (response.data.status === 'success') {
          closeFormModal();
          fetchManagers();
        } else {
          setFormError(response.data.message || t('errors.unknownError', 'An error occurred'));
        }
      } else {
        // Create new manager
        const response = await apiClient.post('/users/createManagerByAdmin', {
          username: data.username,
          password: data.password,
          phone: data.phone,
          address: data.address,
        });

        if (response.data.status === 'success') {
          closeFormModal();
          fetchManagers();
        } else {
          setFormError(response.data.message || t('errors.unknownError', 'An error occurred'));
        }
      }
    } catch (err: unknown) {
      console.error('Error saving manager:', err);
      setFormError(
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
          t('errors.unknownError', 'An error occurred')
      );
    } finally {
      setIsSubmitting(false);
    }
  };

  // Toggle status handlers
  const handleToggleStatusClick = (manager: User) => {
    setManagerToToggle(manager);
    setIsToggleModalOpen(true);
  };

  const closeToggleModal = () => {
    setIsToggleModalOpen(false);
    setManagerToToggle(null);
  };

  const handleConfirmToggleStatus = async () => {
    if (!managerToToggle) return;

    try {
      setTogglingManagerId(managerToToggle._id);
      closeToggleModal();

      const response = await apiClient.patch(`/users/toggleStatus/${managerToToggle._id}`);

      if (response.data.status === 'success') {
        // Update local state
        setManagers((prev) =>
          prev.map((m) =>
            m._id === managerToToggle._id
              ? { ...m, status: m.status === 'active' ? 'inactive' : 'active' }
              : m
          )
        );
      }
    } catch (err) {
      console.error('Error toggling manager status:', err);
    } finally {
      setTogglingManagerId(null);
    }
  };

  return (
    <MainLayout>
      <div className="managers-page">
        {/* Header */}
        <div className="managers-page__header">
          <h1 className="managers-page__title">{t('managers.title', 'Sub - Admins')}</h1>
          <button className="managers-page__add-btn" onClick={handleAddManager}>
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
            >
              <path d="M12 5v14"></path>
              <path d="M5 12h14"></path>
            </svg>
            {t('managers.addManager', 'Add Manager')}
          </button>
        </div>

        {/* Content */}
        <div className="managers-page__content">
          {/* Loading State */}
          {loading && (
            <div className="managers-page__loading">
              <div className="loading-spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          )}

          {/* Error State */}
          {error && !loading && (
            <div className="managers-page__error">
              <p>{error}</p>
              <button className="managers-page__retry-btn" onClick={fetchManagers}>
                {t('common.retry', 'Retry')}
              </button>
            </div>
          )}

          {/* Empty State */}
          {!loading && !error && managers.length === 0 && (
            <div className="managers-page__empty">
              <svg
                width="64"
                height="64"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="1.5"
              >
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
              </svg>
              <p>{t('managers.noManagers', 'No managers found')}</p>
              <button className="managers-page__add-btn" onClick={handleAddManager}>
                {t('managers.addFirstManager', 'Add your first manager')}
              </button>
            </div>
          )}

          {/* Manager Cards Grid */}
          {!loading && !error && managers.length > 0 && (
            <div className="managers-grid">
              {managers.map((manager) => (
                <ManagerCard
                  key={manager._id}
                  manager={manager}
                  onEdit={handleEditManager}
                  onToggleStatus={handleToggleStatusClick}
                  isToggling={togglingManagerId === manager._id}
                />
              ))}
            </div>
          )}
        </div>

        {/* Form Modal (Create/Edit) */}
        <ManagerFormModal
          isOpen={isFormModalOpen}
          manager={editingManager}
          onClose={closeFormModal}
          onSubmit={handleFormSubmit}
          isSubmitting={isSubmitting}
          error={formError}
        />

        {/* Toggle Status Confirmation Modal */}
        <ConfirmModal
          isOpen={isToggleModalOpen}
          title={t('managers.toggleStatusTitle', 'Toggle Status')}
          message={
            managerToToggle
              ? t(
                  'managers.toggleStatusConfirmation',
                  'Are you sure you want to change {{name}}\'s status from {{currentStatus}} to {{newStatus}}?',
                  {
                    name: managerToToggle.username,
                    currentStatus: managerToToggle.status === 'active' ? t('managers.active', 'Active') : t('managers.inactive', 'Inactive'),
                    newStatus: managerToToggle.status === 'active' ? t('managers.inactive', 'Inactive') : t('managers.active', 'Active'),
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

export default ManagersPage;
