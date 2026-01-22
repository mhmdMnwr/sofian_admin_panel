import axios from 'axios';
import { API_CONFIG, STORAGE_KEYS } from '../constants';

const apiClient = axios.create({
  baseURL: API_CONFIG.BASE_URL,
  timeout: API_CONFIG.TIMEOUT,
  headers: { 'Content-Type': 'application/json' },
});

// Add auth token to requests
apiClient.interceptors.request.use((config: any) => {
  const token = localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN);
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
      
      const refreshToken = localStorage.getItem(STORAGE_KEYS.REFRESH_TOKEN);
      
      if (refreshToken) {
        try {
          // Try to refresh the token
          const response = await axios.post(
            `${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.REFRESH_TOKEN}`,
            { refreshToken }
          );
          
          const { accessToken, refreshToken: newRefreshToken } = response.data.data;
          
          localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, accessToken);
          localStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, newRefreshToken);
          
          // Retry the original request with new token
          originalRequest.headers.Authorization = `Bearer ${accessToken}`;
          return apiClient(originalRequest);
        } catch (refreshError) {
          // Refresh failed, clear tokens and redirect to login
          localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
          localStorage.removeItem(STORAGE_KEYS.REFRESH_TOKEN);
          localStorage.removeItem(STORAGE_KEYS.USER_DATA);
          window.location.href = '/login';
          return Promise.reject(refreshError);
        }
      } else {
        // No refresh token, redirect to login
        localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
        localStorage.removeItem(STORAGE_KEYS.USER_DATA);
        window.location.href = '/login';
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
