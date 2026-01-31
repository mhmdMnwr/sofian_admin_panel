import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Provider } from 'react-redux';
import { store } from './core/store';
import { useAppSelector } from './core/hooks/reduxHooks';
import { selectIsAuthenticated, checkSession } from './core/store/slices/authSlice';
import LoginPage from './features/authentication/LoginPage';
import DashboardPage from './features/dashboard/DashboardPage';
import ProductsPage from './features/products/ProductsPage';
import CategoriesPage from './features/categories/CategoriesPage';
import BrandsPage from './features/brands/BrandsPage';
import OrdersPage from './features/orders/OrdersPage';
import UsersPage from './features/users/UsersPage';
import ManagersPage from './features/managers/ManagersPage';
import FeedbacksPage from './features/feedbacks/FeedbacksPage';

// Check session ONCE at app startup - before React renders
store.dispatch(checkSession());

// Protected Route component
const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const isAuthenticated = useAppSelector(selectIsAuthenticated);
  return isAuthenticated ? <>{children}</> : <Navigate to="/login" replace />;
};

// Public Route component (redirect to dashboard if already logged in)
const PublicRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const isAuthenticated = useAppSelector(selectIsAuthenticated);
  return isAuthenticated ? <Navigate to="/dashboard" replace /> : <>{children}</>;
};

const AppRoutes: React.FC = () => (
  <Routes>
    <Route path="/login" element={<PublicRoute><LoginPage /></PublicRoute>} />
    <Route path="/dashboard" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
    <Route path="/products" element={<ProtectedRoute><ProductsPage /></ProtectedRoute>} />
    <Route path="/categories" element={<ProtectedRoute><CategoriesPage /></ProtectedRoute>} />
    <Route path="/brands" element={<ProtectedRoute><BrandsPage /></ProtectedRoute>} />
    <Route path="/orders" element={<ProtectedRoute><OrdersPage /></ProtectedRoute>} />
    <Route path="/clients" element={<ProtectedRoute><UsersPage /></ProtectedRoute>} />
    <Route path="/managers" element={<ProtectedRoute><ManagersPage /></ProtectedRoute>} />
    <Route path="/feedbacks" element={<ProtectedRoute><FeedbacksPage /></ProtectedRoute>} />
    <Route path="*" element={<Navigate to="/dashboard" replace />} />
  </Routes>
);

const App: React.FC = () => (
  <Provider store={store}>
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  </Provider>
);

export default App;
