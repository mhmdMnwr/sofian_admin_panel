// Theme configuration
// All design tokens and theme values are defined here

export const colors = {
  // Primary colors
  primary: {
    main: '#4F46E5',
    dark: '#4338CA',
    light: '#6366F1',
    contrast: '#FFFFFF',
  },
  
  // Secondary colors
  secondary: {
    main: '#10B981',
    dark: '#059669',
    light: '#34D399',
    contrast: '#FFFFFF',
  },
  
  // Status colors
  error: {
    main: '#EF4444',
    dark: '#DC2626',
    light: '#FEE2E2',
    contrast: '#FFFFFF',
  },
  warning: {
    main: '#F59E0B',
    dark: '#D97706',
    light: '#FEF3C7',
    contrast: '#000000',
  },
  success: {
    main: '#10B981',
    dark: '#059669',
    light: '#D1FAE5',
    contrast: '#FFFFFF',
  },
  info: {
    main: '#3B82F6',
    dark: '#2563EB',
    light: '#DBEAFE',
    contrast: '#FFFFFF',
  },
  
  // Neutral colors
  grey: {
    50: '#F9FAFB',
    100: '#F3F4F6',
    200: '#E5E7EB',
    300: '#D1D5DB',
    400: '#9CA3AF',
    500: '#6B7280',
    600: '#4B5563',
    700: '#374151',
    800: '#1F2937',
    900: '#111827',
  },
};

export const lightTheme = {
  // Background colors
  bgDefault: colors.grey[50],
  bgPaper: '#FFFFFF',
  bgElevated: '#FFFFFF',
  
  // Text colors
  textPrimary: colors.grey[900],
  textSecondary: colors.grey[500],
  textDisabled: colors.grey[400],
  
  // Border colors
  border: colors.grey[300],
  borderLight: colors.grey[200],
  
  // Component colors
  primary: colors.primary.main,
  primaryDark: colors.primary.dark,
  error: colors.error.main,
  warning: colors.warning.main,
  success: colors.success.main,
  info: colors.info.main,
  
  // Shadows
  shadowSm: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
  shadowMd: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
  shadowLg: '0 10px 15px -3px rgba(0, 0, 0, 0.1)',
  shadowXl: '0 20px 25px -5px rgba(0, 0, 0, 0.1)',
};

export const darkTheme = {
  // Background colors
  bgDefault: colors.grey[900],
  bgPaper: colors.grey[800],
  bgElevated: colors.grey[700],
  
  // Text colors
  textPrimary: colors.grey[50],
  textSecondary: colors.grey[400],
  textDisabled: colors.grey[600],
  
  // Border colors
  border: colors.grey[700],
  borderLight: colors.grey[600],
  
  // Component colors
  primary: colors.primary.light,
  primaryDark: colors.primary.main,
  error: colors.error.main,
  warning: colors.warning.main,
  success: colors.success.main,
  info: colors.info.main,
  
  // Shadows
  shadowSm: '0 1px 2px 0 rgba(0, 0, 0, 0.3)',
  shadowMd: '0 4px 6px -1px rgba(0, 0, 0, 0.4)',
  shadowLg: '0 10px 15px -3px rgba(0, 0, 0, 0.5)',
  shadowXl: '0 20px 25px -5px rgba(0, 0, 0, 0.6)',
};

export const typography = {
  fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
  
  // Font sizes
  fontSize: {
    xs: '0.75rem',     // 12px
    sm: '0.875rem',    // 14px
    base: '1rem',      // 16px
    lg: '1.125rem',    // 18px
    xl: '1.25rem',     // 20px
    '2xl': '1.5rem',   // 24px
    '3xl': '1.875rem', // 30px
    '4xl': '2.25rem',  // 36px
  },
  
  // Font weights
  fontWeight: {
    normal: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
  },
  
  // Line heights
  lineHeight: {
    tight: 1.25,
    normal: 1.5,
    relaxed: 1.75,
  },
};

export const spacing = {
  0: '0',
  1: '0.25rem',   // 4px
  2: '0.5rem',    // 8px
  3: '0.75rem',   // 12px
  4: '1rem',      // 16px
  5: '1.25rem',   // 20px
  6: '1.5rem',    // 24px
  8: '2rem',      // 32px
  10: '2.5rem',   // 40px
  12: '3rem',     // 48px
  16: '4rem',     // 64px
};

export const borderRadius = {
  none: '0',
  sm: '0.25rem',  // 4px
  md: '0.5rem',   // 8px
  lg: '1rem',     // 16px
  xl: '1.5rem',   // 24px
  full: '9999px',
};

export const transitions = {
  fast: '150ms ease',
  normal: '200ms ease',
  slow: '300ms ease',
};

// CSS Variables generator
export const generateCSSVariables = (theme: typeof lightTheme): string => {
  return `
    --primary: ${theme.primary};
    --primary-dark: ${theme.primaryDark};
    --bg-default: ${theme.bgDefault};
    --bg-paper: ${theme.bgPaper};
    --bg-elevated: ${theme.bgElevated};
    --text-primary: ${theme.textPrimary};
    --text-secondary: ${theme.textSecondary};
    --text-disabled: ${theme.textDisabled};
    --border: ${theme.border};
    --border-light: ${theme.borderLight};
    --error: ${theme.error};
    --warning: ${theme.warning};
    --success: ${theme.success};
    --info: ${theme.info};
    --shadow-sm: ${theme.shadowSm};
    --shadow-md: ${theme.shadowMd};
    --shadow-lg: ${theme.shadowLg};
    --shadow-xl: ${theme.shadowXl};
  `;
};

export type Theme = typeof lightTheme;
export type ThemeMode = 'light' | 'dark';
