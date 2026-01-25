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

// API Response wrapper from backend
export interface ApiResponse<T> {
  status: 'success' | 'fail' | 'error';
  message?: string;
  code?: number;
  data: T;
}

// Auth data from server (user is optional, may need to decode from JWT)
export interface AuthData {
  user?: User;
  accessToken: string;
  refreshToken: string;
}

// Auth response from server
export interface AuthResponse {
  status: 'success' | 'fail' | 'error';
  message?: string;
  data: AuthData;
}

// User response from /users/me
export interface UserResponse {
  status: 'success' | 'fail' | 'error';
  message?: string;
  data: User;
}

// JWT payload structure
export interface JwtPayload {
  email: string;
  id: string;
  role: string;
  iat: number;
  exp: number;
}

// Product type
export interface Product {
  _id: string;
  name: string;
  price: number;
  image?: string;
  brand?: string;
  category?: string;
  units_num?: number;
  state: 'available' | 'not available';
}

// Products API response
export interface ProductsResponse {
  status: 'success' | 'fail' | 'error';
  data: {
    products: Product[];
    totalProducts?: number;
  };
}
