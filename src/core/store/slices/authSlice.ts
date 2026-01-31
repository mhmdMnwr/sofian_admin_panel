import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { User, LoginCredentials, AuthResponse, UserResponse } from '../../types';
import { get, post } from '../../api/apiClient';
import { API_CONFIG, STORAGE_KEYS } from '../../constants';
import { parseApiError, AppError, ErrorCode, isNetworkError } from '../../utils/errorHandler';
import { tokenManager } from '../../utils/tokenManager';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: AppError | null;
  errorMessage: string | null;
}

const initialState: AuthState = {
  user: null,
  token: null,
  isAuthenticated: false,
  isLoading: false,
  error: null,
  errorMessage: null,
};

// Login action
export const login = createAsyncThunk<AuthResponse, LoginCredentials, { rejectValue: AppError }>
(
  'auth/login',
  async (credentials, { rejectWithValue, dispatch }) => {
    try {
      // Validate credentials before sending
      if (!credentials.username || !credentials.password) {
        return rejectWithValue({
          code: ErrorCode.MISSING_FIELDS,
          message: 'Username and password are required.',
        });
      }

      const response = await post<AuthResponse>(API_CONFIG.ENDPOINTS.LOGIN, credentials);
      
      // Validate response structure
      if (!response.data?.accessToken) {
        return rejectWithValue({
          code: ErrorCode.UNKNOWN_ERROR,
          message: 'Invalid response from server. Please try again.',
        });
      }

      // Store tokens using tokenManager
      tokenManager.saveTokens(response.data.accessToken, response.data.refreshToken);
      
      // Fetch user data from /users/me
      dispatch(fetchCurrentUser());
      
      return response;
    } catch (error: unknown) {
      const appError = parseApiError(error);
      
      // Extract error details from API response
      const axiosError = error as { response?: { data?: { message?: string; code?: string } } };
      const serverMessage = axiosError?.response?.data?.message || '';
      const serverMessageLower = serverMessage.toLowerCase();
      const serverCode = axiosError?.response?.data?.code || '';
      
      // Handle specific login error cases
      // Case 1: User not found
      if (serverMessageLower.includes('not found') || serverMessageLower.includes('user not found') || 
          serverMessageLower.includes('no user') || serverCode === 'USER_NOT_FOUND') {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.USER_NOT_FOUND,
          message: serverMessage || 'No account found with this username.',
        });
      }
      
      // Case 2: User is inactive
      if (serverMessageLower.includes('inactive') || serverMessageLower.includes('deactivated') || 
          serverMessageLower.includes('disabled') || serverCode === 'USER_INACTIVE') {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.USER_INACTIVE,
          message: serverMessage || 'Your account is inactive. Please contact an administrator.',
        });
      }
      
      // Case 3: Password mismatch / Invalid credentials
      if (appError.statusCode === 401 || appError.statusCode === 400 ||
          serverMessageLower.includes('password') || serverMessageLower.includes('credentials') ||
          serverMessageLower.includes('invalid') || serverCode === 'INVALID_CREDENTIALS') {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.INVALID_CREDENTIALS,
          message: serverMessage || 'Invalid username or password. Please check your credentials and try again.',
        });
      }
      
      if (isNetworkError(error)) {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.NETWORK_ERROR,
          message: 'Unable to connect to the server. Please check your internet connection and try again.',
        });
      }
      
      // Return the appError with the server message if available
      return rejectWithValue({
        ...appError,
        message: serverMessage || appError.message || 'Login failed. Please try again.',
      });
    }
  }
);

// Fetch current user action
export const fetchCurrentUser = createAsyncThunk<UserResponse, void, { rejectValue: AppError }>
(
  'auth/fetchCurrentUser',
  async (_, { rejectWithValue }) => {
    try {
      const response = await get<UserResponse>(API_CONFIG.ENDPOINTS.ME);
      
      if (!response.data) {
        return rejectWithValue({
          code: ErrorCode.UNKNOWN_ERROR,
          message: 'Failed to fetch user data.',
        });
      }
      
      localStorage.setItem(STORAGE_KEYS.USER_DATA, JSON.stringify(response.data));
      return response;
    } catch (error: unknown) {
      const appError = parseApiError(error);
      return rejectWithValue(appError);
    }
  }
);

// Logout action
export const logout = createAsyncThunk<void, void>('auth/logout', async () => {
  tokenManager.clearTokens();
});

// Check session on app startup
export const checkSession = createAsyncThunk<UserResponse | null, void, { rejectValue: AppError }>(
  'auth/checkSession',
  async (_, { rejectWithValue }) => {
    try {
      // Initialize token manager
      tokenManager.initialize();
      
      // Check if we have a valid session
      if (!tokenManager.hasValidSession()) {
        return null;
      }
      
      // If token is expired, try to refresh
      if (tokenManager.isTokenExpired()) {
        const newToken = await tokenManager.refreshAccessToken();
        if (!newToken) {
          return null;
        }
      }
      
      // Fetch current user to validate session
      const response = await get<UserResponse>(API_CONFIG.ENDPOINTS.ME);
      
      if (response.data) {
        localStorage.setItem(STORAGE_KEYS.USER_DATA, JSON.stringify(response.data));
        return response;
      }
      
      return null;
    } catch (error: unknown) {
      // Session invalid, clear tokens
      tokenManager.clearTokens();
      return rejectWithValue(parseApiError(error));
    }
  }
);

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    clearError: (state) => {
      state.error = null;
      state.errorMessage = null;
    },
    setError: (state, action: PayloadAction<string>) => {
      state.errorMessage = action.payload;
      state.error = {
        code: ErrorCode.UNKNOWN_ERROR,
        message: action.payload,
      };
    },
    setAuthenticated: (state, action: PayloadAction<boolean>) => {
      state.isAuthenticated = action.payload;
    },
    setUser: (state, action: PayloadAction<User>) => {
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    restoreSession: (state) => {
      try {
        tokenManager.initialize();
        const token = tokenManager.getAccessToken();
        const userData = localStorage.getItem(STORAGE_KEYS.USER_DATA);
        if (token && userData && tokenManager.hasValidSession()) {
          state.token = token;
          state.user = JSON.parse(userData);
          state.isAuthenticated = true;
        }
      } catch (error) {
        // If parsing fails, clear corrupted data
        tokenManager.clearTokens();
        state.error = {
          code: ErrorCode.UNKNOWN_ERROR,
          message: 'Session data corrupted. Please login again.',
        };
        state.errorMessage = 'Session data corrupted. Please login again.';
      }
    },
  },
  extraReducers: (builder) => {
    builder
      // Login
      .addCase(login.pending, (state) => {
        state.isLoading = true;
        state.error = null;
        state.errorMessage = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.isLoading = false;
        // Don't set isAuthenticated here - let the component handle navigation
        // isAuthenticated will be set by fetchCurrentUser or manually after navigation
        state.token = action.payload.data.accessToken;
        state.error = null;
        state.errorMessage = null;
      })
      .addCase(login.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload || { code: ErrorCode.UNKNOWN_ERROR, message: 'Login failed. Please try again.' };
        state.errorMessage = action.payload?.message || 'Login failed. Please try again.';
      })
      // Fetch Current User
      .addCase(fetchCurrentUser.fulfilled, (state, action) => {
        state.user = action.payload.data;
      })
      .addCase(fetchCurrentUser.rejected, (state) => {
        // User fetch failed, but we're still authenticated with token
        state.user = null;
      })
      // Logout
      .addCase(logout.fulfilled, (state) => {
        state.isAuthenticated = false;
        state.user = null;
        state.token = null;
        state.error = null;
        state.errorMessage = null;
      })
      // Check Session
      .addCase(checkSession.pending, (state) => {
        state.isLoading = true;
      })
      .addCase(checkSession.fulfilled, (state, action) => {
        state.isLoading = false;
        if (action.payload?.data) {
          state.user = action.payload.data;
          state.token = tokenManager.getAccessToken();
          state.isAuthenticated = true;
        } else {
          state.isAuthenticated = false;
          state.user = null;
          state.token = null;
        }
      })
      .addCase(checkSession.rejected, (state) => {
        state.isLoading = false;
        state.isAuthenticated = false;
        state.user = null;
        state.token = null;
      });
  },
});

export const { clearError, setError, setAuthenticated, setUser, restoreSession } = authSlice.actions;
export default authSlice.reducer;

// Selector helpers
export const selectAuthError = (state: { auth: AuthState }) => state.auth.error;
export const selectAuthErrorMessage = (state: { auth: AuthState }) => state.auth.errorMessage;
export const selectIsAuthenticated = (state: { auth: AuthState }) => state.auth.isAuthenticated;
export const selectCurrentUser = (state: { auth: AuthState }) => state.auth.user;
export const selectAuthLoading = (state: { auth: AuthState }) => state.auth.isLoading;
