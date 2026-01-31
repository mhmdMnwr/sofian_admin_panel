import React from 'react';
import { useTranslation } from 'react-i18next';

interface FilterOption {
  _id: string;
  title: string;
}

interface ProductFiltersProps {
  searchName: string;
  selectedCategory: string;
  selectedBrand: string;
  selectedState: string;
  categories: FilterOption[];
  brands: FilterOption[];
  onSearchNameChange: (value: string) => void;
  onCategoryChange: (value: string) => void;
  onBrandChange: (value: string) => void;
  onStateChange: (value: string) => void;
  onSearch: () => void;
}

const ProductFilters: React.FC<ProductFiltersProps> = ({
  searchName,
  selectedCategory,
  selectedBrand,
  selectedState,
  categories,
  brands,
  onSearchNameChange,
  onCategoryChange,
  onBrandChange,
  onStateChange,
  onSearch,
}) => {
  const { t } = useTranslation();

  return (
    <div className="products-filter-bar">
      <div className="filter-item filter-item--search">
        <input
          type="text"
          placeholder={t('products.searchByName', 'Search by name...')}
          value={searchName}
          onChange={(e) => onSearchNameChange(e.target.value)}
          className="filter-input"
        />
      </div>

      <div className="filter-item">
        <select
          value={selectedCategory}
          onChange={(e) => onCategoryChange(e.target.value)}
          className="filter-select"
        >
          <option value="">{t('products.allCategories', 'All Categories')}</option>
          {categories.map((cat) => (
            <option key={cat._id} value={cat.title}>
              {cat.title}
            </option>
          ))}
        </select>
      </div>

      <div className="filter-item">
        <select
          value={selectedBrand}
          onChange={(e) => onBrandChange(e.target.value)}
          className="filter-select"
        >
          <option value="">{t('products.allBrands', 'All Brands')}</option>
          {brands.map((brand) => (
            <option key={brand._id} value={brand.title}>
              {brand.title}
            </option>
          ))}
        </select>
      </div>

      <div className="filter-item">
        <select
          value={selectedState}
          onChange={(e) => onStateChange(e.target.value)}
          className="filter-select"
        >
          <option value="">{t('products.allStates', 'All States')}</option>
          <option value="available">{t('products.available', 'Available')}</option>
          <option value="unavailable">{t('products.unavailable', 'Unavailable')}</option>
        </select>
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
        {t('products.search', 'Search')}
      </button>
    </div>
  );
};

export default ProductFilters;
