# Sofian Admin Panel - React Web Application

A modern, feature-rich admin panel built with React, TypeScript, Redux Toolkit, and React Router. This is a professional web implementation of the Sofian Admin Panel, originally developed in Flutter.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development](#development)
- [Architecture](#architecture)
- [Key Concepts](#key-concepts)
- [API Integration](#api-integration)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## ✨ Features

### Core Features
- **Authentication & Authorization**: Secure login system with JWT token management
- **Role-Based Access Control**: Support for Super Admin and Admin roles with granular permissions
- **Dashboard**: Comprehensive analytics with interactive charts and statistics
- **Product Management**: Full CRUD operations for products with image upload
- **Category Management**: Hierarchical category system
- **Brand Management**: Brand catalog with associated products
- **Order Management**: Order tracking with status updates and detailed views
- **Client Management**: Customer database with order history
- **Admin Management**: User management with role and permission assignment

### UI/UX Features
- **Dark/Light Theme**: Seamless theme switching with persistent preferences
- **Responsive Design**: Mobile-first approach with tablet and desktop optimizations
- **Internationalization**: Multi-language support (English & Arabic with RTL)
- **Modern UI Components**: Reusable, accessible components
- **Interactive Charts**: Data visualization with Recharts
- **Real-time Updates**: Automatic data refresh and notifications
- **Loading States**: Skeleton screens and loading indicators
- **Error Handling**: Comprehensive error messages and fallback UI

## 🛠️ Tech Stack

### Core Technologies
- **React 18**: Latest React features including hooks and concurrent rendering
- **TypeScript**: Type-safe development with enhanced IDE support
- **Redux Toolkit**: Modern Redux with simplified API and best practices
- **React Router v6**: Declarative routing with nested routes and layouts

### UI & Styling
- **CSS3**: Modern CSS with CSS Variables for theming
- **CSS Modules**: Scoped styles to prevent conflicts
- **Recharts**: Composable charting library for data visualization
- **React Icons**: Comprehensive icon library (Feather Icons)

### Development Tools
- **Create React App**: Zero-configuration setup
- **ESLint**: Code quality and consistency
- **TypeScript**: Static type checking

### HTTP & State Management
- **Axios**: Promise-based HTTP client with interceptors
- **Redux Toolkit**: Simplified Redux with Redux Thunk for async operations
- **React Redux**: Official React bindings for Redux

## 📁 Project Structure

```
sofian_admin_panel_react/
├── public/                      # Static public assets
│   ├── index.html              # HTML template
│   ├── manifest.json           # PWA manifest
│   └── favicon.ico             # Application favicon
│
├── src/
│   ├── core/                   # Core functionality and configurations
│   │   ├── api/               # API client configuration
│   │   │   └── apiClient.ts   # Axios instance with interceptors
│   │   │
│   │   ├── constants/         # Application constants
│   │   │   └── index.ts       # API endpoints, routes, configs
│   │   │
│   │   ├── hooks/             # Custom React hooks
│   │   │   └── reduxHooks.ts  # Typed Redux hooks
│   │   │
│   │   ├── store/             # Redux store configuration
│   │   │   ├── index.ts       # Store setup
│   │   │   └── slices/        # Redux slices
│   │   │       ├── authSlice.ts    # Authentication state
│   │   │       ├── themeSlice.ts   # Theme & locale state
│   │   │       └── uiSlice.ts      # UI state (sidebar, notifications)
│   │   │
│   │   ├── theme/             # Theme configuration
│   │   │   └── index.ts       # Colors, typography, spacing
│   │   │
│   │   ├── types/             # TypeScript type definitions
│   │   │   └── index.ts       # Interfaces and types
│   │   │
│   │   └── utils/             # Utility functions
│   │       └── helpers.ts     # Helper functions (formatting, validation)
│   │
│   ├── components/            # Reusable UI components
│   │   ├── common/           # Common components (Button, Input, etc.)
│   │   │
│   │   └── layout/           # Layout components
│   │       ├── Sidebar.tsx          # Navigation sidebar
│   │       ├── Sidebar.css
│   │       ├── Header.tsx           # Top header bar
│   │       ├── Header.css
│   │       ├── MainLayout.tsx       # Main layout wrapper
│   │       └── MainLayout.css
│   │
│   ├── features/              # Feature-based modules
│   │   ├── authentication/    # Login & auth
│   │   │   ├── LoginPage.tsx
│   │   │   └── LoginPage.css
│   │   │
│   │   ├── dashboard/         # Dashboard analytics
│   │   │   ├── DashboardPage.tsx
│   │   │   └── DashboardPage.css
│   │   │
│   │   ├── products/          # Product management
│   │   ├── categories/        # Category management
│   │   ├── brands/           # Brand management
│   │   ├── orders/           # Order management
│   │   ├── clients/          # Client management
│   │   └── admins/           # Admin user management
│   │
│   ├── assets/               # Static assets
│   │   ├── images/          # Images
│   │   └── fonts/           # Custom fonts
│   │
│   ├── App.tsx              # Root component
│   ├── App.css              # Global styles
│   ├── index.tsx            # Application entry point
│   └── index.css            # Base CSS
│
├── .gitignore               # Git ignore rules
├── package.json             # Dependencies and scripts
├── tsconfig.json           # TypeScript configuration
└── README.md               # Project documentation
```

## 🚀 Getting Started

### Prerequisites

- **Node.js**: Version 16.x or higher
- **npm**: Version 8.x or higher (comes with Node.js)
- **Git**: For version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/sofian_admin_panel_react.git
   cd sofian_admin_panel_react
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   REACT_APP_API_BASE_URL=https://api.example.com
   REACT_APP_ENV=development
   ```

4. **Start the development server**
   ```bash
   npm start
   ```

   The application will open at `http://localhost:3000`

## 💻 Development

### Available Scripts

```bash
# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test

# Eject from Create React App (⚠️ one-way operation)
npm run eject
```

### Development Workflow

1. **Create a new feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the established code structure
   - Add comments to complex logic
   - Keep components small and focused

3. **Test your changes**
   ```bash
   npm test
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: Description of your changes"
   ```

5. **Push to repository**
   ```bash
   git push origin feature/your-feature-name
   ```

### Code Style Guidelines

#### TypeScript/React
- Use functional components with hooks
- Define proper TypeScript interfaces for props and state
- Use meaningful variable and function names
- Keep components under 300 lines
- Extract complex logic into custom hooks

#### CSS
- Use CSS Modules or scoped styles
- Follow BEM naming convention when appropriate
- Use CSS variables for theming
- Keep mobile-first approach

#### Comments
- Add JSDoc comments to functions and components
- Explain WHY, not WHAT (code should be self-explanatory)
- Keep comments up-to-date with code changes

## 🏗️ Architecture

### State Management

The application uses **Redux Toolkit** for state management with the following structure:

#### Auth Slice
```typescript
// Manages authentication state
- user: Admin | null
- token: string | null
- isAuthenticated: boolean
- isLoading: boolean
- error: string | null
```

#### Theme Slice
```typescript
// Manages theme and locale preferences
- mode: 'light' | 'dark'
- locale: 'en' | 'ar'
- direction: 'ltr' | 'rtl'
```

#### UI Slice
```typescript
// Manages UI state
- sidebarCollapsed: boolean
- notifications: Notification[]
- globalLoading: boolean
```

### Routing

React Router v6 with nested routes:
```
/login                    → LoginPage
/                        → MainLayout (Protected)
  ├── /dashboard         → DashboardPage
  ├── /products          → ProductsPage
  ├── /categories        → CategoriesPage
  ├── /brands           → BrandsPage
  ├── /orders           → OrdersPage
  ├── /clients          → ClientsPage
  └── /admins           → AdminsPage
```

### API Architecture

**Axios Instance** with interceptors:
- Automatic token injection for authenticated requests
- Automatic token refresh on 401 errors
- Request/response transformation
- Error handling and logging

## 🔑 Key Concepts

### Permission-Based Routing

The application implements role-based access control (RBAC):

```typescript
// Permission types
enum PermissionType {
  DASHBOARD = 'dashboard',
  PRODUCTS = 'products',
  CATEGORIES = 'categories',
  // ... more permissions
}

// Super Admin has access to all features
// Regular Admin has limited access based on permissions array
```

### Theme System

Dynamic theming with CSS variables:
- Light and dark themes
- Persistent theme selection
- Automatic system preference detection
- Smooth theme transitions

### Internationalization

Multi-language support with RTL:
- English (LTR)
- Arabic (RTL)
- Persistent locale selection
- Direction-aware layouts

## 🔌 API Integration

### Authentication Flow

1. **Login**
   ```typescript
   POST /auth/login
   Body: { email, password }
   Response: { token, admin }
   ```

2. **Token Storage**
   - Stored in localStorage
   - Automatically included in request headers
   - Refreshed on expiration

3. **Logout**
   ```typescript
   POST /auth/logout
   // Clears local storage and redirects to login
   ```

### API Client Usage

```typescript
// Example: Fetch products
import { get } from './core/api/apiClient';
import { API_CONFIG } from './core/constants';

const fetchProducts = async () => {
  const data = await get(API_CONFIG.ENDPOINTS.PRODUCTS);
  return data;
};
```

## 🧪 Testing

### Unit Testing
```bash
npm test
```

### Test Structure
```typescript
// Component.test.tsx
import { render, screen } from '@testing-library/react';
import Component from './Component';

describe('Component', () => {
  it('renders correctly', () => {
    render(<Component />);
    expect(screen.getByText('Hello')).toBeInTheDocument();
  });
});
```

## 📦 Deployment

### Build for Production

```bash
npm run build
```

This creates an optimized production build in the `build/` directory.

### Deployment Platforms

#### Vercel (Recommended)
1. Install Vercel CLI: `npm i -g vercel`
2. Run: `vercel`
3. Follow the prompts

#### Netlify
1. Build: `npm run build`
2. Drag and drop `build/` folder to Netlify

#### Traditional Hosting
1. Build: `npm run build`
2. Upload `build/` contents to web server
3. Configure web server for SPA routing

### Environment Variables

Set these in your deployment platform:
```
REACT_APP_API_BASE_URL=https://api.production.com
REACT_APP_ENV=production
```

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Add tests if applicable**
5. **Submit a pull request**

### Pull Request Guidelines

- Clear description of changes
- Reference any related issues
- Include screenshots for UI changes
- Ensure all tests pass
- Follow code style guidelines

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- **Sofian Team** - Initial work

## 🙏 Acknowledgments

- Original Flutter implementation
- React and TypeScript communities
- All contributors and testers

## 📞 Support

For support, create an issue in the GitHub repository.

## 🗺️ Roadmap

- [ ] Complete all CRUD operations for all features
- [ ] Add real-time notifications with WebSocket
- [ ] Implement data export (CSV, PDF)
- [ ] Add advanced filtering and search
- [ ] Implement bulk operations
- [ ] Add activity logs and audit trail
- [ ] Progressive Web App (PWA) support
- [ ] Enhanced analytics and reporting
- [ ] Multi-factor authentication
- [ ] Email notifications

---

**Built with ❤️ using React and TypeScript**
