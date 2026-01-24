import React, { useEffect, useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Provider } from 'react-redux';
import { store } from './core/store';
import { useAppSelector, useAppDispatch } from './core/hooks/reduxHooks';
import { selectIsAuthenticated, selectAuthLoading, checkSession } from './core/store/slices/authSlice';
import LoginPage from './features/authentication/LoginPage';
import DashboardPage from './features/dashboard/DashboardPage';

// Session checker component
const SessionChecker: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const dispatch = useAppDispatch();
  const isLoading = useAppSelector(selectAuthLoading);
  const [isInitialized, setIsInitialized] = useState(false);

  useEffect(() => {
    const initSession = async () => {
      await dispatch(checkSession());
      setIsInitialized(true);
    };
    initSession();
  }, [dispatch]);

  if (!isInitialized || isLoading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh' }}>
        <div>Loading...</div>
      </div>
    );
  }

  return <>{children}</>;
};

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
  <SessionChecker>
    <Routes>
      <Route path="/login" element={<PublicRoute><LoginPage /></PublicRoute>} />
      <Route path="/dashboard" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  </SessionChecker>
);

const App: React.FC = () => (
  <Provider store={store}>
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  </Provider>
);

export default App;
