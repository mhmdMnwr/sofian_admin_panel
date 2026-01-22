// API Configuration
export const API_CONFIG = {
  BASE_URL: process.env.REACT_APP_API_BASE_URL || 'http://localhost:4000',
  TIMEOUT: 30000,
  ENDPOINTS: {
    LOGIN: '/users/login',
    REGISTER: '/users/register',
    REFRESH_TOKEN: '/users/refresh-token',
    USERS: '/users',
  },
};

// Storage Keys
export const STORAGE_KEYS = {
  AUTH_TOKEN: 'auth_token',
  REFRESH_TOKEN: 'refresh_token',
  USER_DATA: 'user_data',
};
