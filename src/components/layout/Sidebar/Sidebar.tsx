import React from 'react';
import { NavLink } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import './Sidebar.css';

// Import assets
import logo from '../../../assets/images/logo.svg';
import dashboardIcon from '../../../assets/icons/Dashboard.svg';
import categoriesIcon from '../../../assets/icons/categories.svg';
import productsIcon from '../../../assets/icons/products.svg';
import brandsIcon from '../../../assets/icons/brands.svg';
import ordersIcon from '../../../assets/icons/orders.svg';
import clientsIcon from '../../../assets/icons/clients.svg';

interface NavItem {
  path: string;
  labelKey: string;
  icon: string;
}

const navItems: NavItem[] = [
  { path: '/dashboard', labelKey: 'sidebar.dashboard', icon: dashboardIcon },
  { path: '/categories', labelKey: 'sidebar.categories', icon: categoriesIcon },
  { path: '/products', labelKey: 'sidebar.products', icon: productsIcon },
  { path: '/brands', labelKey: 'sidebar.brands', icon: brandsIcon },
  { path: '/orders', labelKey: 'sidebar.orders', icon: ordersIcon },
  { path: '/clients', labelKey: 'sidebar.clients', icon: clientsIcon },
];

interface SidebarProps {
  isCollapsed?: boolean;
  isMobileOpen?: boolean;
  onToggle?: () => void;
  onMobileClose?: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ 
  isCollapsed = false, 
  isMobileOpen = false,
  onMobileClose 
}) => {
  const { t } = useTranslation();

  const handleNavClick = () => {
    // Close mobile drawer when navigating
    if (onMobileClose) {
      onMobileClose();
    }
  };

  return (
    <>
      {/* Overlay for mobile */}
      {isMobileOpen && (
        <div className="sidebar__overlay" onClick={onMobileClose} />
      )}
      
      <aside className={`sidebar ${isCollapsed ? 'sidebar--collapsed' : ''} ${isMobileOpen ? 'sidebar--mobile-open' : ''}`}>
        {/* Logo Section */}
        <div className="sidebar__logo">
          <img src={logo} alt="Company Logo" className="sidebar__logo-image" />
        </div>

        {/* Navigation */}
        <nav className="sidebar__nav">
          <ul className="sidebar__nav-list">
            {navItems.map((item) => (
              <li key={item.path} className="sidebar__nav-item">
                <NavLink
                  to={item.path}
                  className={({ isActive }) =>
                    `sidebar__nav-link ${isActive ? 'sidebar__nav-link--active' : ''}`
                  }
                  onClick={handleNavClick}
                >
                  <img src={item.icon} alt="" className="sidebar__nav-icon" />
                  {!isCollapsed && (
                    <span className="sidebar__nav-label">{t(item.labelKey)}</span>
                  )}
                </NavLink>
              </li>
            ))}
          </ul>
        </nav>
      </aside>
    </>
  );
};

export default Sidebar;
