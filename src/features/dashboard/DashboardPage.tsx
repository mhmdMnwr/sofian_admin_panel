import React, { useState, useEffect, useCallback } from 'react';
import { useTranslation } from 'react-i18next';
import { MainLayout } from '../../components/layout';
import { Pagination } from '../../components/common';
import apiClient from '../../core/api/apiClient';
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';
import './DashboardPage.css';

// Import icons
import revenueIcon from '../../assets/icons/revenue.svg';
import orderIcon from '../../assets/icons/order.svg';
import clientIcon from '../../assets/icons/client.svg';

// Types
interface TotalsData {
  revenue: { total: number; growth: number };
  orders: { total: number; growth: number };
  clients: { total: number; growth: number };
}

interface AnalyticsPoint {
  _id: string;
  value: number;
}

interface TopProduct {
  _id: string;
  title: string;
  value: number;
  percentage: number;
}

interface TopClient {
  name: string;
  value: number;
}

interface RevenueReportItem {
  _id: string;
  revenue: number;
  ordersCount: number;
}

// Chart colors for pie chart
const CHART_COLORS = ['#3b82f6', '#06b6d4', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899'];

const DashboardPage: React.FC = () => {
  const { t } = useTranslation();
  
  // State for totals
  const [totals, setTotals] = useState<TotalsData | null>(null);
  const [totalsLoading, setTotalsLoading] = useState(true);
  
  // State for analytics chart
  const [analyticsData, setAnalyticsData] = useState<AnalyticsPoint[]>([]);
  const [analyticsLoading, setAnalyticsLoading] = useState(true);
  const [analyticsType, setAnalyticsType] = useState<'revenue' | 'orders' | 'clients'>('revenue');
  const [analyticsRange, setAnalyticsRange] = useState<'week' | 'month' | 'year' | 'all'>('week');
  
  // State for top products
  const [topProducts, setTopProducts] = useState<TopProduct[]>([]);
  const [topProductsLoading, setTopProductsLoading] = useState(true);
  const [topProductsType, setTopProductsType] = useState<'quantity' | 'revenue'>('quantity');
  
  // State for revenue report
  const [revenueReport, setRevenueReport] = useState<RevenueReportItem[]>([]);
  const [revenueReportLoading, setRevenueReportLoading] = useState(true);
  const [revenueInterval, setRevenueInterval] = useState<'day' | 'month' | 'year'>('day');
  const [revenueCurrentPage, setRevenueCurrentPage] = useState(1);
  const [revenueTotalPages, setRevenueTotalPages] = useState(1);
  
  // State for top clients
  const [topClients, setTopClients] = useState<TopClient[]>([]);
  const [topClientsLoading, setTopClientsLoading] = useState(true);
  const [topClientsSortBy, setTopClientsSortBy] = useState<'orders' | 'revenue'>('orders');

  // Fetch totals with growth
  const fetchTotals = useCallback(async () => {
    try {
      setTotalsLoading(true);
      const response = await apiClient.get('/dashboard/getTotalsWithGrowth');
      if (response.data.status === 'success') {
        setTotals(response.data.data);
      }
    } catch (err) {
      console.error('Error fetching totals:', err);
    } finally {
      setTotalsLoading(false);
    }
  }, []);

  // Fetch analytics data
  const fetchAnalytics = useCallback(async () => {
    try {
      setAnalyticsLoading(true);
      const response = await apiClient.get('/dashboard/getAnalytics', {
        params: { range: analyticsRange, type: analyticsType }
      });
      if (response.data.status === 'success') {
        setAnalyticsData(response.data.data || []);
      }
    } catch (err) {
      console.error('Error fetching analytics:', err);
    } finally {
      setAnalyticsLoading(false);
    }
  }, [analyticsRange, analyticsType]);

  // Fetch top products
  const fetchTopProducts = useCallback(async () => {
    try {
      setTopProductsLoading(true);
      const response = await apiClient.get('/dashboard/getTopProductsAnalytics', {
        params: { limit: 5, type: topProductsType }
      });
      if (response.data.status === 'success') {
        setTopProducts(response.data.data || []);
      }
    } catch (err) {
      console.error('Error fetching top products:', err);
    } finally {
      setTopProductsLoading(false);
    }
  }, [topProductsType]);

  // Fetch revenue report
  const fetchRevenueReport = useCallback(async (page: number = 1) => {
    try {
      setRevenueReportLoading(true);
      const response = await apiClient.get('/dashboard/getRevenueReport', {
        params: { interval: revenueInterval, page, limit: 5 }
      });
      if (response.data.status === 'success') {
        setRevenueReport(response.data.data || []);
        setRevenueTotalPages(response.data.meta?.totalPages || 1);
        setRevenueCurrentPage(page);
      }
    } catch (err) {
      console.error('Error fetching revenue report:', err);
    } finally {
      setRevenueReportLoading(false);
    }
  }, [revenueInterval]);

  // Fetch top clients
  const fetchTopClients = useCallback(async () => {
    try {
      setTopClientsLoading(true);
      const response = await apiClient.get('/dashboard/getTopClients', {
        params: { sortBy: topClientsSortBy, limit: 5 }
      });
      if (response.data.status === 'success') {
        setTopClients(response.data.data || []);
      }
    } catch (err) {
      console.error('Error fetching top clients:', err);
    } finally {
      setTopClientsLoading(false);
    }
  }, [topClientsSortBy]);

  // Initial fetch
  useEffect(() => {
    fetchTotals();
  }, [fetchTotals]);

  useEffect(() => {
    fetchAnalytics();
  }, [fetchAnalytics]);

  useEffect(() => {
    fetchTopProducts();
  }, [fetchTopProducts]);

  useEffect(() => {
    fetchRevenueReport(1);
  }, [fetchRevenueReport]);

  useEffect(() => {
    fetchTopClients();
  }, [fetchTopClients]);

  // Format number with commas
  const formatNumber = (num: number): string => {
    return num.toLocaleString('en-US');
  };

  // Format currency
  const formatCurrency = (num: number): string => {
    return `${formatNumber(num)} DA`;
  };

  // Format date label based on interval
  const formatDateLabel = (dateStr: string): string => {
    if (!dateStr) return '';
    
    // Year format: YYYY
    if (dateStr.length === 4) {
      return dateStr;
    }
    
    // Month format: YYYY-MM
    if (dateStr.length === 7) {
      const [year, month] = dateStr.split('-');
      const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return `${monthNames[parseInt(month) - 1]} ${year}`;
    }
    
    // Day format: YYYY-MM-DD - include year for clarity
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  };

  // Custom tooltip for chart
  const CustomTooltip = ({ active, payload, label }: any) => {
    if (active && payload && payload.length) {
      return (
        <div className="dashboard-chart-tooltip">
          <p className="tooltip-label">{formatDateLabel(label)}</p>
          <p className="tooltip-value">
            {analyticsType === 'revenue' 
              ? formatCurrency(payload[0].value)
              : formatNumber(payload[0].value)}
          </p>
        </div>
      );
    }
    return null;
  };

  // Render growth indicator
  const renderGrowth = (growth: number) => {
    const isPositive = growth >= 0;
    return (
      <span className={`growth-indicator ${isPositive ? 'growth-positive' : 'growth-negative'}`}>
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" className="growth-icon">
          {isPositive ? (
            <path d="M7 17L17 7M17 7H10M17 7V14" />
          ) : (
            <path d="M7 7L17 17M17 17H10M17 17V10" />
          )}
        </svg>
        <span className="growth-value">{Math.abs(growth).toFixed(1)}%</span>
        <span className="growth-text">{t('dashboard.thanLastWeek', 'than last week')}</span>
      </span>
    );
  };

  return (
    <MainLayout>
      <div className="dashboard-page">
        {/* Header */}
        <div className="dashboard-header">
          <div className="dashboard-header-left">
            <h1 className="dashboard-title">{t('dashboard.title', 'Dashboard Overview')}</h1>
            <p className="dashboard-subtitle">
              {t('dashboard.subtitle', "Welcome back! Here's what's happening with your store today.")}
            </p>
          </div>
        </div>

        {/* Summary Cards */}
        <div className="dashboard-cards">
          {/* Revenue Card */}
          <div className="dashboard-card dashboard-card--revenue">
            <div className="card-left">
              <span className="card-label">{t('dashboard.revenue', 'Revenue')}</span>
              <div className="card-value-row">
                <span className="card-value">
                  {totalsLoading ? '...' : formatCurrency(totals?.revenue.total || 0)}
                </span>
                {!totalsLoading && renderGrowth(totals?.revenue.growth || 0)}
              </div>
            </div>
            <div className="card-icon">
              <img src={revenueIcon} alt="Revenue" />
            </div>
          </div>

          {/* Orders Card */}
          <div className="dashboard-card dashboard-card--orders">
            <div className="card-left">
              <span className="card-label">{t('dashboard.orders', 'Orders')}</span>
              <div className="card-value-row">
                <span className="card-value">
                  {totalsLoading ? '...' : formatNumber(totals?.orders.total || 0)}
                </span>
                {!totalsLoading && renderGrowth(totals?.orders.growth || 0)}
              </div>
            </div>
            <div className="card-icon">
              <img src={orderIcon} alt="Orders" />
            </div>
          </div>

          {/* Clients Card */}
          <div className="dashboard-card dashboard-card--clients">
            <div className="card-left">
              <span className="card-label">{t('dashboard.clients', 'Clients')}</span>
              <div className="card-value-row">
                <span className="card-value">
                  {totalsLoading ? '...' : formatNumber(totals?.clients.total || 0)}
                </span>
                {!totalsLoading && renderGrowth(totals?.clients.growth || 0)}
              </div>
            </div>
            <div className="card-icon">
              <img src={clientIcon} alt="Clients" />
            </div>
          </div>
        </div>

        {/* Charts Row */}
        <div className="dashboard-charts-row">
          {/* Main Analytics Chart */}
          <div className="dashboard-chart-container dashboard-chart-container--main">
            <div className="chart-header">
              <div className="chart-tabs">
                <button 
                  className={`chart-tab ${analyticsType === 'revenue' ? 'chart-tab--active' : ''}`}
                  onClick={() => setAnalyticsType('revenue')}
                >
                  {t('dashboard.revenue', 'Revenue')}
                </button>
                <button 
                  className={`chart-tab ${analyticsType === 'orders' ? 'chart-tab--active' : ''}`}
                  onClick={() => setAnalyticsType('orders')}
                >
                  {t('dashboard.orders', 'Orders')}
                </button>
                <button 
                  className={`chart-tab ${analyticsType === 'clients' ? 'chart-tab--active' : ''}`}
                  onClick={() => setAnalyticsType('clients')}
                >
                  {t('dashboard.clients', 'Clients')}
                </button>
              </div>
              <div className="chart-filter">
                <select 
                  value={analyticsRange} 
                  onChange={(e) => setAnalyticsRange(e.target.value as 'week' | 'month' | 'year' | 'all')}
                  className="chart-select"
                >
                  <option value="week">{t('dashboard.lastWeek', 'Last Week')}</option>
                  <option value="month">{t('dashboard.thisMonth', 'This Month')}</option>
                  <option value="year">{t('dashboard.thisYear', 'This Year')}</option>
                  <option value="all">{t('dashboard.allTime', 'All Time')}</option>
                </select>
              </div>
            </div>
            <div className="chart-body">
              {analyticsLoading ? (
                <div className="chart-loading">
                  <div className="chart-spinner"></div>
                </div>
              ) : analyticsData.length === 0 ? (
                <div className="chart-empty">
                  <p>{t('dashboard.noData', 'No data available')}</p>
                </div>
              ) : (
                <ResponsiveContainer width="100%" height={300}>
                  <AreaChart data={analyticsData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
                    <defs>
                      <linearGradient id="colorValue" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3}/>
                        <stop offset="95%" stopColor="#3b82f6" stopOpacity={0}/>
                      </linearGradient>
                    </defs>
                    <CartesianGrid strokeDasharray="3 3" stroke="var(--dashboard-grid-color)" />
                    <XAxis 
                      dataKey="_id" 
                      tickFormatter={formatDateLabel}
                      stroke="var(--dashboard-text-muted)"
                      fontSize={12}
                    />
                    <YAxis 
                      stroke="var(--dashboard-text-muted)"
                      fontSize={12}
                      tickFormatter={(value) => analyticsType === 'revenue' ? `${(value / 1000).toFixed(0)}k` : value}
                    />
                    <Tooltip content={<CustomTooltip />} />
                    <Area 
                      type="monotone" 
                      dataKey="value" 
                      stroke="#3b82f6" 
                      strokeWidth={2}
                      fillOpacity={1} 
                      fill="url(#colorValue)" 
                    />
                  </AreaChart>
                </ResponsiveContainer>
              )}
            </div>
          </div>

          {/* Top Products Pie Chart */}
          <div className="dashboard-chart-container dashboard-chart-container--pie">
            <div className="chart-header">
              <h3 className="chart-title">{t('dashboard.topProducts', 'Top 5 Selling Products')}</h3>
              <div className="chart-filter">
                <select 
                  value={topProductsType} 
                  onChange={(e) => setTopProductsType(e.target.value as 'quantity' | 'revenue')}
                  className="chart-select"
                >
                  <option value="quantity">{t('dashboard.byQuantity', 'By Quantity')}</option>
                  <option value="revenue">{t('dashboard.byRevenue', 'By Revenue')}</option>
                </select>
              </div>
            </div>
            <div className="chart-body chart-body--pie">
              {topProductsLoading ? (
                <div className="chart-loading">
                  <div className="chart-spinner"></div>
                </div>
              ) : topProducts.length === 0 ? (
                <div className="chart-empty">
                  <p>{t('dashboard.noData', 'No data available')}</p>
                </div>
              ) : (
                <div className="pie-chart-wrapper">
                  <ResponsiveContainer width="100%" height={220}>
                    <PieChart>
                      <Pie
                        data={topProducts as any[]}
                        cx="50%"
                        cy="50%"
                        innerRadius={50}
                        outerRadius={80}
                        paddingAngle={2}
                        dataKey="percentage"
                        nameKey="title"
                      >
                        {topProducts.map((_, index) => (
                          <Cell key={`cell-${index}`} fill={CHART_COLORS[index % CHART_COLORS.length]} />
                        ))}
                      </Pie>
                      <Tooltip 
                        formatter={(value) => [`${value}%`, '']}
                        contentStyle={{
                          backgroundColor: 'var(--dashboard-card-bg)',
                          border: '1px solid var(--dashboard-border)',
                          borderRadius: '8px'
                        }}
                      />
                    </PieChart>
                  </ResponsiveContainer>
                  <div className="pie-legend">
                    {topProducts.map((product, index) => (
                      <div key={product._id} className="pie-legend-item">
                        <span 
                          className="pie-legend-color" 
                          style={{ backgroundColor: CHART_COLORS[index % CHART_COLORS.length] }}
                        ></span>
                        <span className="pie-legend-label" title={product.title}>
                          {product.title.length > 15 ? `${product.title.substring(0, 15)}...` : product.title}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Bottom Row */}
        <div className="dashboard-bottom-row">
          {/* Revenue Report */}
          <div className="dashboard-table-container">
            <div className="table-header">
              <h3 className="table-title">{t('dashboard.revenueReport', 'Revenue Report')}</h3>
              <div className="table-filter">
                <select 
                  value={revenueInterval} 
                  onChange={(e) => {
                    setRevenueInterval(e.target.value as 'day' | 'month' | 'year');
                    setRevenueCurrentPage(1);
                  }}
                  className="chart-select"
                >
                  <option value="day">{t('dashboard.byDay', 'By Day')}</option>
                  <option value="month">{t('dashboard.byMonth', 'By Month')}</option>
                  <option value="year">{t('dashboard.byYear', 'By Year')}</option>
                </select>
              </div>
            </div>
            <div className="table-body">
              {revenueReportLoading ? (
                <div className="table-loading">
                  <div className="chart-spinner"></div>
                </div>
              ) : revenueReport.length === 0 ? (
                <div className="table-empty">
                  <p>{t('dashboard.noData', 'No data available')}</p>
                </div>
              ) : (
                <>
                  <table className="dashboard-table">
                    <thead>
                      <tr>
                        <th>{t('dashboard.date', 'Date')}</th>
                        <th>{t('dashboard.revenue', 'Revenue')}</th>
                        <th>{t('dashboard.ordersCount', 'Orders')}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {revenueReport.map((item) => (
                        <tr key={item._id}>
                          <td className="table-date">{formatDateLabel(item._id)}</td>
                          <td className="table-revenue">{formatCurrency(item.revenue)}</td>
                          <td className="table-orders">{item.ordersCount}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  {revenueTotalPages > 1 && (
                    <div className="table-pagination">
                      <Pagination
                        currentPage={revenueCurrentPage}
                        totalPages={revenueTotalPages}
                        onPageChange={(page) => fetchRevenueReport(page)}
                      />
                    </div>
                  )}
                </>
              )}
            </div>
          </div>

          {/* Active Clients */}
          <div className="dashboard-clients-container">
            <div className="clients-header">
              <h3 className="clients-title">{t('dashboard.activeClients', 'Active Clients')}</h3>
              <div className="clients-filter">
                <select 
                  value={topClientsSortBy} 
                  onChange={(e) => setTopClientsSortBy(e.target.value as 'orders' | 'revenue')}
                  className="chart-select"
                >
                  <option value="orders">{t('dashboard.byOrders', 'By Orders')}</option>
                  <option value="revenue">{t('dashboard.bySpending', 'By Spending')}</option>
                </select>
              </div>
            </div>
            <div className="clients-body">
              {topClientsLoading ? (
                <div className="clients-loading">
                  <div className="chart-spinner"></div>
                </div>
              ) : topClients.length === 0 ? (
                <div className="clients-empty">
                  <p>{t('dashboard.noData', 'No data available')}</p>
                </div>
              ) : (
                <div className="clients-list">
                  {topClients.map((client, index) => (
                    <div key={index} className="client-item">
                      <div className="client-avatar">
                        {client.name.charAt(0).toUpperCase()}
                      </div>
                      <div className="client-info">
                        <span className="client-name">{client.name}</span>
                      </div>
                      <div className="client-value">
                        {topClientsSortBy === 'revenue' 
                          ? formatCurrency(client.value)
                          : `${client.value} ${t('dashboard.ordersLabel', 'orders')}`}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </MainLayout>
  );
};

export default DashboardPage;
