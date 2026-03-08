import React from 'react';
import { useTranslation } from 'react-i18next';
import './Pagination.css';

interface PaginationProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
  maxVisiblePages?: number;
}

const Pagination: React.FC<PaginationProps> = ({
  currentPage,
  totalPages,
  onPageChange,
  maxVisiblePages = 5,
}) => {
  const { t } = useTranslation();

  // Calculate visible page range
  const getVisiblePages = (): number[] => {
    const pages: number[] = [];
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

    if (endPage - startPage + 1 < maxVisiblePages) {
      startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }

    return pages;
  };

  const visiblePages = getVisiblePages();
  const startPage = visiblePages[0] || 1;
  const endPage = visiblePages[visiblePages.length - 1] || 1;

  if (totalPages <= 1) {
    return null;
  }

  return (
    <div className="pagination-container">
      {totalPages > 1 && (
        <div className="pagination">
          <button
            className="pagination__btn"
            onClick={() => onPageChange(currentPage - 1)}
            disabled={currentPage === 1}
          >
            {t('pagination.previous', 'Previous')}
          </button>

          {startPage > 1 && (
            <>
              <button
                className="pagination__page"
                onClick={() => onPageChange(1)}
              >
                1
              </button>
              {startPage > 2 && (
                <span className="pagination__ellipsis">...</span>
              )}
            </>
          )}

          {visiblePages.map((page) => (
            <button
              key={page}
              className={`pagination__page ${
                page === currentPage ? 'pagination__page--active' : ''
              }`}
              onClick={() => onPageChange(page)}
            >
              {page}
            </button>
          ))}

          {endPage < totalPages && (
            <>
              {endPage < totalPages - 1 && (
                <span className="pagination__ellipsis">...</span>
              )}
              <button
                className="pagination__page"
                onClick={() => onPageChange(totalPages)}
              >
                {totalPages}
              </button>
            </>
          )}

          <button
            className="pagination__btn"
            onClick={() => onPageChange(currentPage + 1)}
            disabled={currentPage === totalPages}
          >
            {t('pagination.next', 'Next')}
          </button>
        </div>
      )}
    </div>
  );
};

export default Pagination;
