import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { User, LoginCredentials, AuthResponse, RegisterCredentials } from '../../types';
import { post } from '../../api/apiClient';
import { API_CONFIG, STORAGE_KEYS } from '../../constants';
import { parseApiError, AppError, ErrorCode, isNetworkError } from '../../utils/errorHandler';

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
export const login = createAsyncThunk<AuthResponse, LoginCredentials, { rejectValue: AppError }>(
  'auth/login',
  async (credentials, { rejectWithValue }) => {
    try {
      // Validate credentials before sending
      if (!credentials.email || !credentials.password) {
        return rejectWithValue({
          code: ErrorCode.MISSING_FIELDS,
          message: 'Email and password are required.',
        });
      }

      const response = await post<AuthResponse>(API_CONFIG.ENDPOINTS.LOGIN, credentials);
      
      // Validate response structure
      if (!response.data?.accessToken || !response.data?.user) {
        return rejectWithValue({
          code: ErrorCode.UNKNOWN_ERROR,
          message: 'Invalid response from server. Please try again.',
        });
      }

      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.accessToken);
      localStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, response.data.refreshToken);
      localStorage.setItem(STORAGE_KEYS.USER_DATA, JSON.stringify(response.data.user));
      return response;
    } catch (error: unknown) {
      const appError = parseApiError(error);
      
      // Provide more specific messages for login errors
      if (appError.statusCode === 401 || appError.statusCode === 400) {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.INVALID_CREDENTIALS,
          message: 'Invalid email or password. Please check your credentials and try again.',
        });
      }
      
      if (isNetworkError(error)) {
        return rejectWithValue({
          ...appError,
          message: 'Unable to connect to the server. Please check your internet connection and try again.',
        });
      }
      
      return rejectWithValue(appError);
    }
  }
);

// Register action
export const register = createAsyncThunk<AuthResponse, RegisterCredentials, { rejectValue: AppError }>(
  'auth/register',
  async (credentials, { rejectWithValue }) => {
    try {
      // Validate required fields
      if (!credentials.email || !credentials.password || !credentials.firstName || !credentials.lastName) {
        return rejectWithValue({
          code: ErrorCode.MISSING_FIELDS,
          message: 'All fields are required. Please fill in your first name, last name, email, and password.',
        });
      }

      // Validate password strength
      if (credentials.password.length < 6) {
        return rejectWithValue({
          code: ErrorCode.WEAK_PASSWORD,
          message: 'Password must be at least 6 characters long.',
        });
      }

      const response = await post<AuthResponse>(API_CONFIG.ENDPOINTS.REGISTER, credentials);
      
      // Validate response structure
      if (!response.data?.accessToken || !response.data?.user) {
        return rejectWithValue({
          code: ErrorCode.UNKNOWN_ERROR,
          message: 'Invalid response from server. Please try again.',
        });
      }

      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.accessToken);
      localStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, response.data.refreshToken);
      localStorage.setItem(STORAGE_KEYS.USER_DATA, JSON.stringify(response.data.user));
      return response;
    } catch (error: unknown) {
      const appError = parseApiError(error);
      
      // Provide more specific messages for registration errors
      if (appError.statusCode === 409) {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.EMAIL_ALREADY_EXISTS,
          message: 'An account with this email already exists. Please login or use a different email.',
        });
      }
      
      if (appError.statusCode === 400) {
        return rejectWithValue({
          ...appError,
          code: ErrorCode.VALIDATION_ERROR,
          message: appError.message || 'Invalid registration data. Please check your information and try again.',
        });
      }
      
      if (isNetworkError(error)) {
        return rejectWithValue({
          ...appError,
          message: 'Unable to connect to the server. Please check your internet connection and try again.',
        });
      }
      
      return rejectWithValue(appError);
    }
  }
);

// Logout action
export const logout = createAsyncThunk<void, void>('auth/logout', async () => {
  localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
  localStorage.removeItem(STORAGE_KEYS.REFRESH_TOKEN);
  localStorage.removeItem(STORAGE_KEYS.USER_DATA);
});

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
    setUser: (state, action: PayloadAction<User>) => {
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    restoreSession: (state) => {
      try {
        const token = localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN);
        const userData = localStorage.getItem(STORAGE_KEYS.USER_DATA);
        if (token && userData) {
          state.token = token;
          state.user = JSON.parse(userData);
          state.isAuthenticated = true;
        }
      } catch (error) {
        // If parsing fails, clear corrupted data
        localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
        localStorage.removeItem(STORAGE_KEYS.REFRESH_TOKEN);
        localStorage.removeItem(STORAGE_KEYS.USER_DATA);
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
        state.isAuthenticated = true;
        state.user = action.payload.data.user;
        state.token = action.payload.data.accessToken;
        state.error = null;
        state.errorMessage = null;
      })
      .addCase(login.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload || { code: ErrorCode.UNKNOWN_ERROR, message: 'Login failed. Please try again.' };
        state.errorMessage = action.payload?.message || 'Login failed. Please try again.';
      })
      // Register
      .addCase(register.pending, (state) => {
        state.isLoading = true;
        state.error = null;
        state.errorMessage = null;
      })
      .addCase(register.fulfilled, (state, action) => {
        state.isLoading = false;
        state.isAuthenticated = true;
        state.user = action.payload.data.user;
        state.token = action.payload.data.accessToken;
        state.error = null;
        state.errorMessage = null;
      })
      .addCase(register.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload || { code: ErrorCode.UNKNOWN_ERROR, message: 'Registration failed. Please try again.' };
        state.errorMessage = action.payload?.message || 'Registration failed. Please try again.';
      })
      // Logout
      .addCase(logout.fulfilled, (state) => {
        state.isAuthenticated = false;
        state.user = null;
        state.token = null;
        state.error = null;
        state.errorMessage = null;
      });
  },
});

export const { clearError, setError, setUser, restoreSession } = authSlice.actions;
export default authSlice.reducer;

// Selector helpers
export const selectAuthError = (state: { auth: AuthState }) => state.auth.error;
export const selectAuthErrorMessage = (state: { auth: AuthState }) => state.auth.errorMessage;
export const selectIsAuthenticated = (state: { auth: AuthState }) => state.auth.isAuthenticated;
export const selectCurrentUser = (state: { auth: AuthState }) => state.auth.user;
export const selectAuthLoading = (state: { auth: AuthState }) => state.auth.isLoading;
