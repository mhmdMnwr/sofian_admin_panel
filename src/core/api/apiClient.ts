import axios from 'axios';
import { API_CONFIG } from '../constants';
import { tokenManager } from '../utils/tokenManager';

const apiClient = axios.create({
  baseURL: API_CONFIG.BASE_URL,
  timeout: API_CONFIG.TIMEOUT,
  headers: { 'Content-Type': 'application/json' },
});

// Add auth token to requests (using tokenManager)
apiClient.interceptors.request.use(async (config: any) => {
  // Get valid token (will refresh if expired)
  const token = await tokenManager.getValidAccessToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 errors and refresh token
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    
    // If 401 and we haven't already retried
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;
      
      try {
        // Try to refresh the token using tokenManager
        const newToken = await tokenManager.refreshAccessToken();
        
        if (newToken) {
          // Retry the original request with new token
          originalRequest.headers.Authorization = `Bearer ${newToken}`;
          return apiClient(originalRequest);
        } else {
          // Refresh failed, redirect to login
          tokenManager.clearTokens();
          window.location.href = '/login';
          return Promise.reject(error);
        }
      } catch (refreshError) {
        // Refresh failed, clear tokens and redirect to login
        tokenManager.clearTokens();
        window.location.href = '/login';
        return Promise.reject(refreshError);
      }
    }
    return Promise.reject(error);
  }
);

export const get = async <T>(url: string): Promise<T> => {
  const response = await apiClient.get<T>(url);
  return response.data;
};

export const post = async <T>(url: string, data?: any): Promise<T> => {
  const response = await apiClient.post<T>(url, data);
  return response.data;
};

export const put = async <T>(url: string, data?: any): Promise<T> => {
  const response = await apiClient.put<T>(url, data);
  return response.data;
};

export const del = async <T>(url: string): Promise<T> => {
  const response = await apiClient.delete<T>(url);
  return response.data;
};

export default apiClient;
