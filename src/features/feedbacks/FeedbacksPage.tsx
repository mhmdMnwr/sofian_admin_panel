import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { Pagination } from '../../components/common';
import apiClient from '../../core/api/apiClient';
import { formatDate } from '../../core/utils/helpers';
import './FeedbacksPage.css';

interface Feedback {
  _id: string;
  customer: {
    _id: string;
    username: string;
  } | null;
  comment: string;
  createdAt: string;
  updatedAt: string;
}

interface FeedbacksResponse {
  status: string;
  message: string;
  data: Feedback[];
  meta: {
    page: number;
    limit: number;
    totalPages: number;
    totalItems: number;
  };
}

const FeedbacksPage: React.FC = () => {
  const { t } = useTranslation();
  const [feedbacks, setFeedbacks] = useState<Feedback[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [totalFeedbacks, setTotalFeedbacks] = useState(0);
  
  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [itemsPerPage] = useState(10);

  const fetchFeedbacks = useCallback(async (page: number = currentPage) => {
    try {
      setLoading(true);
      setError(null);
      
      const params: Record<string, string | number> = {
        page,
        limit: itemsPerPage,
      };
      
      const response = await apiClient.get<FeedbacksResponse>('/feedbacks', { params });
      
      if (response.data.status === 'success') {
        const fetchedFeedbacks = response.data.data || [];
        setFeedbacks(fetchedFeedbacks);
        setTotalFeedbacks(response.data.meta?.totalItems || fetchedFeedbacks.length);
        setTotalPages(response.data.meta?.totalPages || 1);
        setCurrentPage(response.data.meta?.page || page);
      }
    } catch (err) {
      setError(t('errors.unknownError', 'An error occurred while fetching feedbacks'));
      console.error('Error fetching feedbacks:', err);
    } finally {
      setLoading(false);
    }
  }, [t, currentPage, itemsPerPage]);

  useEffect(() => {
    fetchFeedbacks(1);
  }, []);

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
    fetchFeedbacks(page);
  };

  return (
    <MainLayout>
      <div className="feedbacks-page">
        {/* Header */}
        <div className="feedbacks-page__header">
          <div className="feedbacks-page__header-left">
            <h1 className="feedbacks-page__title">{t('feedbacks.title', 'Feedbacks')}</h1>
            <span className="feedbacks-page__count">
              {t('feedbacks.totalCount', '{{count}} feedbacks', { count: totalFeedbacks })}
            </span>
          </div>
        </div>

        {/* Content */}
        <div className="feedbacks-page__content">
          {loading ? (
            <div className="feedbacks-page__loading">
              <div className="feedbacks-page__spinner"></div>
              <p>{t('common.loading', 'Loading...')}</p>
            </div>
          ) : error ? (
            <div className="feedbacks-page__error">
              <p>{error}</p>
              <button onClick={() => fetchFeedbacks(currentPage)} className="feedbacks-page__retry-btn">
                {t('common.tryAgain', 'Try Again')}
              </button>
            </div>
          ) : feedbacks.length === 0 ? (
            <div className="feedbacks-page__empty">
              <svg className="feedbacks-page__empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
              </svg>
              <p>{t('feedbacks.noFeedbacks', 'No feedbacks found')}</p>
            </div>
          ) : (
            <>
              <div className="feedbacks-list">
                {feedbacks.map((feedback) => (
                  <div key={feedback._id} className="feedback-card">
                    <div className="feedback-card__header">
                      <div className="feedback-card__user">
                        <div className="feedback-card__avatar">
                          {feedback.customer?.username?.charAt(0).toUpperCase() || '?'}
                        </div>
                        <div className="feedback-card__user-info">
                          <span className="feedback-card__username">
                            {feedback.customer?.username || t('feedbacks.anonymous', 'Anonymous')}
                          </span>
                          <span className="feedback-card__date">
                            {formatDate(feedback.createdAt)}
                          </span>
                        </div>
                      </div>
                    </div>
                    <div className="feedback-card__content">
                      <p className="feedback-card__comment">{feedback.comment}</p>
                    </div>
                  </div>
                ))}
              </div>

              {/* Pagination */}
              {totalPages > 1 && (
                <Pagination
                  currentPage={currentPage}
                  totalPages={totalPages}
                  onPageChange={handlePageChange}
                />
              )}
            </>
          )}
        </div>
      </div>
    </MainLayout>
  );
};

export default FeedbacksPage;
