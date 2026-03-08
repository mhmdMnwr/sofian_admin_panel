import React from 'react';
import { useTranslation } from 'react-i18next';

interface OrderFiltersProps {
  searchUsername: string;
  selectedStatus: string;
  startDate: string;
  endDate: string;
  onSearchUsernameChange: (value: string) => void;
  onStatusChange: (value: string) => void;
  onStartDateChange: (value: string) => void;
  onEndDateChange: (value: string) => void;
  onSearch: () => void;
}

const OrderFilters: React.FC<OrderFiltersProps> = ({
  searchUsername,
  selectedStatus,
  startDate,
  endDate,
  onSearchUsernameChange,
  onStatusChange,
  onStartDateChange,
  onEndDateChange,
  onSearch,
}) => {
  const { t } = useTranslation();

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      onSearch();
    }
  };

  return (
    <div className="orders-filter-bar">
      <div className="filter-item filter-item--search">
        <input
          type="text"
          placeholder={t('orders.searchByUsername', 'Search by username...')}
          value={searchUsername}
          onChange={(e) => onSearchUsernameChange(e.target.value)}
          className="filter-input"
          onKeyPress={handleKeyPress}
        />
      </div>

      <div className="filter-item">
        <select
          value={selectedStatus}
          onChange={(e) => onStatusChange(e.target.value)}
          className="filter-select"
        >
          <option value="">{t('orders.allStatuses', 'All Statuses')}</option>
          <option value="Pending">{t('orders.pending', 'Pending')}</option>
          <option value="Processing">{t('orders.processing', 'Processing')}</option>
          <option value="Shipped">{t('orders.shipped', 'Shipped')}</option>
          <option value="Delivered">{t('orders.delivered', 'Delivered')}</option>
          <option value="Cancelled">{t('orders.cancelled', 'Cancelled')}</option>
        </select>
      </div>

      <div className="filter-item">
        <input
          type="date"
          value={startDate}
          onChange={(e) => onStartDateChange(e.target.value)}
          className="filter-input filter-input--date"
          title={t('orders.startDate', 'Start Date')}
        />
      </div>

      <div className="filter-item">
        <input
          type="date"
          value={endDate}
          onChange={(e) => onEndDateChange(e.target.value)}
          className="filter-input filter-input--date"
          title={t('orders.endDate', 'End Date')}
        />
      </div>

      <button onClick={onSearch} className="filter-search-btn">
        <svg
          width="18"
          height="18"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
        >
          <circle cx="11" cy="11" r="8"></circle>
          <path d="m21 21-4.35-4.35"></path>
        </svg>
        {t('orders.search', 'Search')}
      </button>
    </div>
  );
};

export default OrderFilters;
