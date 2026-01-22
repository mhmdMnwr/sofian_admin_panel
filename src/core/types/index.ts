// User type
export interface User {
  _id: string;
  firstName: string;
  lastName: string;
  email: string;
  role?: string;
}

// For backwards compatibility
export type Admin = User;

// Login credentials
export interface LoginCredentials {
  email: string;
  password: string;
}

// Register credentials
export interface RegisterCredentials {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

// API Response wrapper from backend
export interface ApiResponse<T> {
  status: 'success' | 'fail' | 'error';
  message?: string;
  code?: number;
  data: T;
}

// Auth data from server
export interface AuthData {
  user: User;
  accessToken: string;
  refreshToken: string;
}

// Auth response from server
export interface AuthResponse {
  status: 'success' | 'fail' | 'error';
  message?: string;
  data: AuthData;
}
