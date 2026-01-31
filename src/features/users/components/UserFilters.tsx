import React from 'react';
import { useTranslation } from 'react-i18next';

interface UserFiltersProps {
  searchName: string;
  selectedStatus: string;
  onSearchNameChange: (value: string) => void;
  onStatusChange: (value: string) => void;
  onSearch: () => void;
}

const UserFilters: React.FC<UserFiltersProps> = ({
  searchName,
  selectedStatus,
  onSearchNameChange,
  onStatusChange,
  onSearch,
}) => {
  const { t } = useTranslation();

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      onSearch();
    }
  };

  return (
    <div className="users-filter-bar">
      <div className="users-filter-item users-filter-item--search">
        <input
          type="text"
          placeholder={t('users.searchByName', 'Search by name...')}
          value={searchName}
          onChange={(e) => onSearchNameChange(e.target.value)}
          className="users-filter-input"
          onKeyPress={handleKeyPress}
        />
      </div>

      <div className="users-filter-item">
        <select
          value={selectedStatus}
          onChange={(e) => onStatusChange(e.target.value)}
          className="users-filter-select"
        >
          <option value="">{t('users.allStatuses', 'All Statuses')}</option>
          <option value="active">{t('users.active', 'Active')}</option>
          <option value="inactive">{t('users.inactive', 'Inactive')}</option>
        </select>
      </div>

      <button onClick={onSearch} className="users-filter-search-btn">
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
        {t('users.search', 'Search')}
      </button>
    </div>
  );
};

export default UserFilters;
