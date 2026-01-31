// User status enum
export type UserStatus = 'active' | 'inactive';

// User roles enum
export type UserRole = 'customer' | 'manager' | 'admin' | 'super_admin';

// User type
export interface User {
  _id: string;
  username: string;
  name?: string;
  status: UserStatus;
  role: UserRole;
  totalOrders: number;
  totalSpent: number;
  address: string;
  phone: string;
  createdAt?: string;
  updatedAt?: string;
}

// For backwards compatibility
export type Admin = User;

// Login credentials
export interface LoginCredentials {
  username: string;
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
  id: string;
  role: string;
  iat: number;
  exp: number;
}

// Product type
export interface Product {
  _id: string;
  title: string;
  price: number;
  image?: string;
  brand?: { _id: string; title: string; image?: string } | string;
  category?: { _id: string; title: string; image?: string } | string;
  units: number;
  totalSold?: number;
  totalRevenue?: number;
  state: 'available' | 'unavailable';
  createdAt?: string;
  updatedAt?: string;
}

// Products API response
export interface ProductsResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Product[];
  meta?: Pagination;
}

// Pagination info
export interface Pagination {
  page: number;
  limit: number;
  totalPages: number;
  totalItems: number;
}

// Category type
export interface Category {
  _id: string;
  title: string;
  image: string;
  createdAt?: string;
  updatedAt?: string;
}

// Categories API response
export interface CategoriesResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Category[];
  meta?: Pagination;
}

// Single Category API response
export interface CategoryResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Category;
}

// Brand type
export interface Brand {
  _id: string;
  title: string;
  image: string;
  createdAt?: string;
  updatedAt?: string;
}

// Brands API response
export interface BrandsResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Brand[];
  meta?: Pagination;
}

// Single Brand API response
export interface BrandResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Brand;
}

// Order status enum - matches backend OrderStatus values (capitalized)
export type OrderStatus = 'Pending' | 'Processing' | 'Shipped' | 'Delivered' | 'Cancelled';

// Order item type
export interface OrderItem {
  productId: string | { _id: string; title: string; price: number; image?: string; units?: number };
  quantity: number;
  units: number;
  price: number;
}

// Customer info type (populated from customerId)
export interface CustomerInfo {
  _id: string;
  username?: string;
  phone?: string;
  address?: string;
}

// Order type
export interface Order {
  _id: string;
  customerId: string | User | CustomerInfo;
  items: OrderItem[];
  totalAmount: number;
  status: OrderStatus;
  shippingAddress?: string;
  notes?: string;
  comment?: string;
  createdAt?: string;
  updatedAt?: string;
}

// Orders API response
export interface OrdersResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Order[];
  meta?: Pagination;
}

// Single Order API response
export interface OrderResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message: string;
  data: Order;
}

// Users API response
export interface UsersResponse {
  statusCode: number;
  status: 'success' | 'fail' | 'error';
  message?: string;
  data: User[];
  meta?: Pagination;
}
