import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { User, LoginCredentials, AuthResponse, RegisterCredentials } from '../../types';
import { post } from '../../api/apiClient';
import { API_CONFIG, STORAGE_KEYS } from '../../constants';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  user: null,
  token: null,
  isAuthenticated: false,
  isLoading: false,
  error: null,
};

// Login action
export const login = createAsyncThunk<AuthResponse, LoginCredentials, { rejectValue: string }>(
  'auth/login',
  async (credentials, { rejectWithValue }) => {
    try {
      const response = await post<AuthResponse>(API_CONFIG.ENDPOINTS.LOGIN, credentials);
      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.accessToken);
      localStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, response.data.refreshToken);
      localStorage.setItem(STORAGE_KEYS.USER_DATA, JSON.stringify(response.data.user));
      return response;
    } catch (error: any) {
      return rejectWithValue(error.response?.data?.message || 'Login failed. Please try again.');
    }
  }
);

// Register action
export const register = createAsyncThunk<AuthResponse, RegisterCredentials, { rejectValue: string }>(
  'auth/register',
  async (credentials, { rejectWithValue }) => {
    try {
      const response = await post<AuthResponse>(API_CONFIG.ENDPOINTS.REGISTER, credentials);
      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, response.data.accessToken);
      localStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, response.data.refreshToken);
      localStorage.setItem(STORAGE_KEYS.USER_DATA, JSON.stringify(response.data.user));
      return response;
    } catch (error: any) {
      return rejectWithValue(error.response?.data?.message || 'Registration failed. Please try again.');
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
    },
    setUser: (state, action: PayloadAction<User>) => {
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    restoreSession: (state) => {
      const token = localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN);
      const userData = localStorage.getItem(STORAGE_KEYS.USER_DATA);
      if (token && userData) {
        state.token = token;
        state.user = JSON.parse(userData);
        state.isAuthenticated = true;
      }
    },
  },
  extraReducers: (builder) => {
    builder
      // Login
      .addCase(login.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.isLoading = false;
        state.isAuthenticated = true;
        state.user = action.payload.data.user;
        state.token = action.payload.data.accessToken;
      })
      .addCase(login.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload || 'Login failed';
      })
      // Register
      .addCase(register.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(register.fulfilled, (state, action) => {
        state.isLoading = false;
        state.isAuthenticated = true;
        state.user = action.payload.data.user;
        state.token = action.payload.data.accessToken;
      })
      .addCase(register.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload || 'Registration failed';
      })
      // Logout
      .addCase(logout.fulfilled, (state) => {
        state.isAuthenticated = false;
        state.user = null;
        state.token = null;
      });
  },
});

export const { clearError, setUser, restoreSession } = authSlice.actions;
export default authSlice.reducer;
