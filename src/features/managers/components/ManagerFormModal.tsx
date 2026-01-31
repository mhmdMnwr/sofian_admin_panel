import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Modal } from '../../../components/common';
import { User } from '../../../core/types';
import { ManagerFormData } from '../ManagersPage';

interface ManagerFormModalProps {
  isOpen: boolean;
  manager: User | null;
  onClose: () => void;
  onSubmit: (data: ManagerFormData) => void;
  isSubmitting?: boolean;
  error?: string | null;
}

const ManagerFormModal: React.FC<ManagerFormModalProps> = ({
  isOpen,
  manager,
  onClose,
  onSubmit,
  isSubmitting = false,
  error = null,
}) => {
  const { t } = useTranslation();
  const isEditing = !!manager;

  const [formData, setFormData] = useState<ManagerFormData>({
    username: '',
    password: '',
    phone: '',
    address: '',
  });

  // Reset form when modal opens or manager changes
  useEffect(() => {
    if (isOpen) {
      if (manager) {
        setFormData({
          username: manager.username || '',
          password: '',
          phone: manager.phone || '',
          address: manager.address || '',
        });
      } else {
        setFormData({
          username: '',
          password: '',
          phone: '',
          address: '',
        });
      }
    }
  }, [isOpen, manager]);

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSubmit(formData);
  };

  const isValid = () => {
    if (!formData.username.trim()) return false;
    // Password required only when creating
    if (!isEditing && !formData.password.trim()) return false;
    return true;
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={
        isEditing
          ? t('managers.editManager', 'Edit Manager')
          : t('managers.addManager', 'Add Manager')
      }
    >
      <form className="manager-form" onSubmit={handleSubmit}>
        {/* Error Message */}
        {error && <div className="manager-form__error">{error}</div>}

        {/* Username */}
        <div className="manager-form__group">
          <label className="manager-form__label manager-form__label--required">
            {t('managers.username', 'Username')}
          </label>
          <input
            type="text"
            name="username"
            className="manager-form__input"
            value={formData.username}
            onChange={handleChange}
            placeholder={t('managers.usernamePlaceholder', 'Enter username')}
            required
            autoFocus
          />
        </div>

        {/* Password */}
        <div className="manager-form__group">
          <label
            className={`manager-form__label ${
              !isEditing ? 'manager-form__label--required' : ''
            }`}
          >
            {t('managers.password', 'Password')}
          </label>
          <input
            type="password"
            name="password"
            className="manager-form__input"
            value={formData.password}
            onChange={handleChange}
            placeholder={
              isEditing
                ? t('managers.passwordPlaceholderEdit', 'Leave blank to keep current')
                : t('managers.passwordPlaceholder', 'Enter password')
            }
            required={!isEditing}
          />
          {isEditing && (
            <span className="manager-form__hint">
              {t('managers.passwordHint', 'Leave blank to keep the current password')}
            </span>
          )}
        </div>

        {/* Phone */}
        <div className="manager-form__group">
          <label className="manager-form__label">
            {t('managers.phone', 'Phone')}
          </label>
          <input
            type="text"
            name="phone"
            className="manager-form__input"
            value={formData.phone}
            onChange={handleChange}
            placeholder={t('managers.phonePlaceholder', 'Enter phone number')}
          />
        </div>

        {/* Address */}
        <div className="manager-form__group">
          <label className="manager-form__label">
            {t('managers.address', 'Address')}
          </label>
          <textarea
            name="address"
            className="manager-form__textarea"
            value={formData.address}
            onChange={handleChange}
            placeholder={t('managers.addressPlaceholder', 'Enter address')}
            rows={3}
          />
        </div>

        {/* Actions */}
        <div className="manager-form__actions">
          <button
            type="button"
            className="manager-form__btn manager-form__btn--cancel"
            onClick={onClose}
            disabled={isSubmitting}
          >
            {t('common.cancel', 'Cancel')}
          </button>
          <button
            type="submit"
            className="manager-form__btn manager-form__btn--submit"
            disabled={isSubmitting || !isValid()}
          >
            {isSubmitting
              ? t('common.saving', 'Saving...')
              : isEditing
              ? t('common.save', 'Save')
              : t('managers.create', 'Create')}
          </button>
        </div>
      </form>
    </Modal>
  );
};

export default ManagerFormModal;
