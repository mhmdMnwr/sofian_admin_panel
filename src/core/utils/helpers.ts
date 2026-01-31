// Email validation
export const isValidEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

// Username validation
export const isValidUsername = (username: string): boolean => {
  // Username must be at least 3 characters and contain only alphanumeric characters and underscores
  const usernameRegex = /^[a-zA-Z0-9_]{3,}$/;
  return usernameRegex.test(username);
};

// Format date for display
export const formatDate = (
  dateString?: string,
  options?: Intl.DateTimeFormatOptions
): string => {
  if (!dateString) return '-';

  const defaultOptions: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  };

  return new Date(dateString).toLocaleDateString('en-US', options || defaultOptions);
};
