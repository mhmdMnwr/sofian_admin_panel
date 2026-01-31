import React from 'react';
import { useTranslation } from 'react-i18next';
import Modal from './Modal';

interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  confirmText?: string;
  cancelText?: string;
  isLoading?: boolean;
  loadingText?: string;
  error?: string | null;
  variant?: 'danger' | 'warning' | 'default';
}

const ConfirmModal: React.FC<ConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText,
  cancelText,
  isLoading = false,
  loadingText,
  error,
  variant = 'danger',
}) => {
  const { t } = useTranslation();

  const footer = (
    <>
      <button type="button" onClick={onClose} className="btn-cancel">
        {cancelText || t('common.cancel', 'Cancel')}
      </button>
      <button
        type="button"
        onClick={onConfirm}
        className={`btn-submit ${variant === 'danger' ? 'btn-delete' : ''}`}
        disabled={isLoading}
      >
        {isLoading ? (
          <>
            <div className="loading-spinner loading-spinner--small"></div>
            {loadingText || t('common.loading', 'Loading...')}
          </>
        ) : (
          confirmText || t('common.confirm', 'Confirm')
        )}
      </button>
    </>
  );

  return (
    <Modal isOpen={isOpen} onClose={onClose} title={title} size="small" footer={footer}>
      <p>{message}</p>
      {error && (
        <div className="form-error-banner" style={{ marginTop: '16px' }}>
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
          <span>{error}</span>
        </div>
      )}
    </Modal>
  );
};

export default ConfirmModal;
