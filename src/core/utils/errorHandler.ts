import { AxiosError } from 'axios';

// Error codes from backend
export enum ErrorCode {
  // Authentication errors
  INVALID_CREDENTIALS = 'INVALID_CREDENTIALS',
  USER_NOT_FOUND = 'USER_NOT_FOUND',
  USER_INACTIVE = 'USER_INACTIVE',
  PASSWORD_MISMATCH = 'PASSWORD_MISMATCH',
  EMAIL_ALREADY_EXISTS = 'EMAIL_ALREADY_EXISTS',
  RESOURCE_IN_USE = 'RESOURCE_IN_USE',
  TOKEN_EXPIRED = 'TOKEN_EXPIRED',
  TOKEN_INVALID = 'TOKEN_INVALID',
  UNAUTHORIZED = 'UNAUTHORIZED',
  
  // Validation errors
  VALIDATION_ERROR = 'VALIDATION_ERROR',
  INVALID_EMAIL = 'INVALID_EMAIL',
  WEAK_PASSWORD = 'WEAK_PASSWORD',
  MISSING_FIELDS = 'MISSING_FIELDS',
  
  // Server errors
  INTERNAL_SERVER_ERROR = 'INTERNAL_SERVER_ERROR',
  SERVICE_UNAVAILABLE = 'SERVICE_UNAVAILABLE',
  
  // Network errors
  NETWORK_ERROR = 'NETWORK_ERROR',
  TIMEOUT_ERROR = 'TIMEOUT_ERROR',
  
  // Unknown
  UNKNOWN_ERROR = 'UNKNOWN_ERROR',
}

// Error response structure from backend
export interface ApiErrorResponse {
  status: 'error' | 'fail';
  message: string;
  code?: number;
  data?: any;
  errors?: Record<string, string>;
}

// Application error structure
export interface AppError {
  code: ErrorCode | string;
  message: string;
  statusCode?: number;
  field?: string;
  details?: Record<string, string>;
}

// Map error codes to translation keys
export const ERROR_TRANSLATION_KEYS: Record<string, string> = {
  [ErrorCode.INVALID_CREDENTIALS]: 'errors.invalidCredentials',
  [ErrorCode.USER_NOT_FOUND]: 'errors.userNotFound',
  [ErrorCode.USER_INACTIVE]: 'errors.userInactive',
  [ErrorCode.PASSWORD_MISMATCH]: 'errors.passwordMismatch',
  [ErrorCode.EMAIL_ALREADY_EXISTS]: 'errors.emailAlreadyExists',
  [ErrorCode.RESOURCE_IN_USE]: 'errors.resourceInUse',
  [ErrorCode.TOKEN_EXPIRED]: 'errors.tokenExpired',
  [ErrorCode.TOKEN_INVALID]: 'errors.tokenInvalid',
  [ErrorCode.UNAUTHORIZED]: 'errors.unauthorized',
  [ErrorCode.VALIDATION_ERROR]: 'errors.validationError',
  [ErrorCode.INVALID_EMAIL]: 'errors.invalidEmail',
  [ErrorCode.WEAK_PASSWORD]: 'errors.weakPassword',
  [ErrorCode.MISSING_FIELDS]: 'errors.missingFields',
  [ErrorCode.INTERNAL_SERVER_ERROR]: 'errors.internalServerError',
  [ErrorCode.SERVICE_UNAVAILABLE]: 'errors.serviceUnavailable',
  [ErrorCode.NETWORK_ERROR]: 'errors.networkError',
  [ErrorCode.TIMEOUT_ERROR]: 'errors.timeoutError',
  [ErrorCode.UNKNOWN_ERROR]: 'errors.unknownError',
};

// Fallback error messages (used when i18n is not available)
const FALLBACK_ERROR_MESSAGES: Record<string, string> = {
  [ErrorCode.INVALID_CREDENTIALS]: 'Invalid username or password. Please check your credentials and try again.',
  [ErrorCode.USER_NOT_FOUND]: 'No account found with this username.',
  [ErrorCode.USER_INACTIVE]: 'Your account is inactive. Please contact an administrator.',
  [ErrorCode.PASSWORD_MISMATCH]: 'Incorrect password. Please try again.',
  [ErrorCode.EMAIL_ALREADY_EXISTS]: 'An account with this email already exists.',
  [ErrorCode.RESOURCE_IN_USE]: 'This item cannot be deleted because it is being used by other resources.',
  [ErrorCode.TOKEN_EXPIRED]: 'Your session has expired. Please login again.',
  [ErrorCode.TOKEN_INVALID]: 'Invalid authentication. Please login again.',
  [ErrorCode.UNAUTHORIZED]: 'You are not authorized to perform this action.',
  [ErrorCode.VALIDATION_ERROR]: 'Please check your input and try again.',
  [ErrorCode.INVALID_EMAIL]: 'Please enter a valid email address.',
  [ErrorCode.WEAK_PASSWORD]: 'Password must be at least 6 characters long.',
  [ErrorCode.MISSING_FIELDS]: 'Please fill in all required fields.',
  [ErrorCode.INTERNAL_SERVER_ERROR]: 'Something went wrong on our end. Please try again later.',
  [ErrorCode.SERVICE_UNAVAILABLE]: 'Service is temporarily unavailable. Please try again later.',
  [ErrorCode.NETWORK_ERROR]: 'Unable to connect to the server. Please check your internet connection.',
  [ErrorCode.TIMEOUT_ERROR]: 'Request timed out. Please try again.',
  [ErrorCode.UNKNOWN_ERROR]: 'An unexpected error occurred. Please try again.',
};

// Get the translation key for an error code
export const getErrorTranslationKey = (code: string): string => {
  return ERROR_TRANSLATION_KEYS[code] || ERROR_TRANSLATION_KEYS[ErrorCode.UNKNOWN_ERROR];
};

// Get fallback error message (without i18n)
export const getErrorMessage = (code: string): string => {
  return FALLBACK_ERROR_MESSAGES[code] || FALLBACK_ERROR_MESSAGES[ErrorCode.UNKNOWN_ERROR];
};

// Parse Axios error to AppError
export const parseApiError = (error: unknown): AppError => {
  // Handle Axios errors
  if (isAxiosError(error)) {
    const axiosError = error as AxiosError<ApiErrorResponse>;
    
    // Network error (no response)
    if (!axiosError.response) {
      if (axiosError.code === 'ECONNABORTED') {
        return {
          code: ErrorCode.TIMEOUT_ERROR,
          message: getErrorMessage(ErrorCode.TIMEOUT_ERROR),
        };
      }
      return {
        code: ErrorCode.NETWORK_ERROR,
        message: getErrorMessage(ErrorCode.NETWORK_ERROR),
      };
    }
    
    const { status, data } = axiosError.response;
    
    // Handle specific HTTP status codes
    switch (status) {
      case 400:
        return {
          code: ErrorCode.VALIDATION_ERROR,
          message: data?.message || getErrorMessage(ErrorCode.VALIDATION_ERROR),
          statusCode: status,
          details: data?.errors,
        };
      
      case 401:
        return {
          code: ErrorCode.UNAUTHORIZED,
          message: data?.message || getErrorMessage(ErrorCode.UNAUTHORIZED),
          statusCode: status,
        };
      
      case 403:
        return {
          code: ErrorCode.UNAUTHORIZED,
          message: data?.message || 'Access denied. You don\'t have permission to perform this action.',
          statusCode: status,
        };
      
      case 404:
        return {
          code: ErrorCode.USER_NOT_FOUND,
          message: data?.message || 'The requested resource was not found.',
          statusCode: status,
        };
      
      case 409:
        return {
          code: ErrorCode.EMAIL_ALREADY_EXISTS,
          message: data?.message || getErrorMessage(ErrorCode.EMAIL_ALREADY_EXISTS),
          statusCode: status,
        };
      
      case 422:
        return {
          code: ErrorCode.VALIDATION_ERROR,
          message: data?.message || getErrorMessage(ErrorCode.VALIDATION_ERROR),
          statusCode: status,
          details: data?.errors,
        };
      
      case 500:
      case 502:
      case 503:
        return {
          code: ErrorCode.INTERNAL_SERVER_ERROR,
          message: getErrorMessage(ErrorCode.INTERNAL_SERVER_ERROR),
          statusCode: status,
        };
      
      default:
        return {
          code: ErrorCode.UNKNOWN_ERROR,
          message: data?.message || getErrorMessage(ErrorCode.UNKNOWN_ERROR),
          statusCode: status,
        };
    }
  }
  
  // Handle standard Error objects
  if (error instanceof Error) {
    return {
      code: ErrorCode.UNKNOWN_ERROR,
      message: error.message || getErrorMessage(ErrorCode.UNKNOWN_ERROR),
    };
  }
  
  // Handle string errors
  if (typeof error === 'string') {
    return {
      code: ErrorCode.UNKNOWN_ERROR,
      message: error,
    };
  }
  
  // Fallback
  return {
    code: ErrorCode.UNKNOWN_ERROR,
    message: getErrorMessage(ErrorCode.UNKNOWN_ERROR),
  };
};

// Type guard for Axios errors
export const isAxiosError = (error: unknown): error is AxiosError => {
  return (error as AxiosError)?.isAxiosError === true;
};

// Extract error message for display (simplified)
export const extractErrorMessage = (error: unknown): string => {
  const appError = parseApiError(error);
  return appError.message;
};

// Check if error is a network error
export const isNetworkError = (error: unknown): boolean => {
  const appError = parseApiError(error);
  return appError.code === ErrorCode.NETWORK_ERROR || appError.code === ErrorCode.TIMEOUT_ERROR;
};

// Check if error requires re-authentication
export const isAuthError = (error: unknown): boolean => {
  const appError = parseApiError(error);
  return appError.code === ErrorCode.UNAUTHORIZED || 
         appError.code === ErrorCode.TOKEN_EXPIRED || 
         appError.code === ErrorCode.TOKEN_INVALID;
};
