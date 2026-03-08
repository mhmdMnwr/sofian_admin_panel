import { STORAGE_KEYS, API_CONFIG } from '../constants';
import axios from 'axios';

interface TokenPayload {
  exp: number;
  iat: number;
  userId: string;
  [key: string]: any;
}

interface TokenData {
  accessToken: string;
  refreshToken: string;
  expiresAt: number;
}

// In-memory cache for quick access
let cachedTokenData: TokenData | null = null;

// Decode JWT without external library
const decodeToken = (token: string): TokenPayload | null => {
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map((c) => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    );
    return JSON.parse(jsonPayload);
  } catch (error) {
    console.error('Failed to decode token:', error);
    return null;
  }
};

// Get expiration time from token
const getTokenExpiration = (token: string): number => {
  const payload = decodeToken(token);
  if (!payload?.exp) return 0;
  return payload.exp * 1000; // Convert to milliseconds
};

// Check if token is expired (with 30 second buffer)
const isTokenExpired = (expiresAt: number): boolean => {
  const bufferMs = 30 * 1000; // 30 seconds buffer
  return Date.now() >= expiresAt - bufferMs;
};

// Load tokens from localStorage to memory cache
const loadTokensFromStorage = (): TokenData | null => {
  try {
    const accessToken = localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN);
    const refreshToken = localStorage.getItem(STORAGE_KEYS.REFRESH_TOKEN);
    
    if (!accessToken || !refreshToken) {
      return null;
    }
    
    const expiresAt = getTokenExpiration(accessToken);
    
    cachedTokenData = {
      accessToken,
      refreshToken,
      expiresAt,
    };
    
    return cachedTokenData;
  } catch (error) {
    console.error('Failed to load tokens from storage:', error);
    return null;
  }
};

// Save tokens to both localStorage and memory cache
const saveTokens = (accessToken: string, refreshToken: string): void => {
  localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, accessToken);
  localStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, refreshToken);
  
  cachedTokenData = {
    accessToken,
    refreshToken,
    expiresAt: getTokenExpiration(accessToken),
  };
};

// Clear all tokens
const clearTokens = (): void => {
  localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
  localStorage.removeItem(STORAGE_KEYS.REFRESH_TOKEN);
  localStorage.removeItem(STORAGE_KEYS.USER_DATA);
  cachedTokenData = null;
};

// Refresh token flag to prevent multiple simultaneous refresh attempts
let isRefreshing = false;
let refreshPromise: Promise<string | null> | null = null;

// Refresh the access token
const refreshAccessToken = async (): Promise<string | null> => {
  // If already refreshing, wait for the existing promise
  if (isRefreshing && refreshPromise) {
    return refreshPromise;
  }
  
  isRefreshing = true;
  
  refreshPromise = (async () => {
    try {
      const tokenData = cachedTokenData || loadTokensFromStorage();
      
      if (!tokenData?.refreshToken) {
        throw new Error('No refresh token available');
      }
      
      const response = await axios.post(
        `${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.REFRESH_TOKEN}`,
        { refreshToken: tokenData.refreshToken }
      );
      
      const { accessToken, refreshToken } = response.data.data;
      
      saveTokens(accessToken, refreshToken);
      
      return accessToken;
    } catch (error) {
      console.error('Failed to refresh token:', error);
      clearTokens();
      return null;
    } finally {
      isRefreshing = false;
      refreshPromise = null;
    }
  })();
  
  return refreshPromise;
};

// Get a valid access token (refreshing if necessary)
const getValidAccessToken = async (): Promise<string | null> => {
  let tokenData = cachedTokenData || loadTokensFromStorage();
  
  if (!tokenData) {
    return null;
  }
  
  // If token is expired or about to expire, refresh it
  if (isTokenExpired(tokenData.expiresAt)) {
    const newToken = await refreshAccessToken();
    return newToken;
  }
  
  return tokenData.accessToken;
};

// Check if user has a valid session
const hasValidSession = (): boolean => {
  const tokenData = cachedTokenData || loadTokensFromStorage();
  
  if (!tokenData) {
    return false;
  }
  
  // Check if access token is valid
  if (!isTokenExpired(tokenData.expiresAt)) {
    return true;
  }
  
  // If access token is expired, check if we have a refresh token
  // The actual refresh will happen when making an API call
  return !!tokenData.refreshToken;
};

// Get current access token (without refreshing)
const getAccessToken = (): string | null => {
  const tokenData = cachedTokenData || loadTokensFromStorage();
  return tokenData?.accessToken || null;
};

// Get refresh token
const getRefreshToken = (): string | null => {
  const tokenData = cachedTokenData || loadTokensFromStorage();
  return tokenData?.refreshToken || null;
};

// Initialize token manager (call on app startup)
const initialize = (): void => {
  loadTokensFromStorage();
};

// Token manager export
export const tokenManager = {
  initialize,
  saveTokens,
  clearTokens,
  getAccessToken,
  getRefreshToken,
  getValidAccessToken,
  hasValidSession,
  refreshAccessToken,
  isTokenExpired: (token?: string) => {
    if (token) {
      return isTokenExpired(getTokenExpiration(token));
    }
    const tokenData = cachedTokenData || loadTokensFromStorage();
    return tokenData ? isTokenExpired(tokenData.expiresAt) : true;
  },
};

export default tokenManager;
