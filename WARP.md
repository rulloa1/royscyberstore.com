# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

RoysCompany is a front-end e-commerce website built with vanilla HTML, CSS (TailwindCSS), and JavaScript. It runs locally using XAMPP as a development environment and serves static product catalog pages for various financial products.

## Technology Stack

- **Frontend Framework**: Vanilla HTML/CSS/JavaScript
- **CSS Framework**: TailwindCSS (custom build included in `home/css/main.css`)
- **JavaScript Libraries**: 
  - Chart.js for dashboard analytics
  - Popper.js for dropdown positioning
  - SweetAlert2 for notifications
  - RemixIcon for iconography
- **Development Environment**: XAMPP (Apache server for local development)
- **Third-party Integrations**:
  - TradingView ticker widgets
  - Tawk.to chat widget
  - Tidio chat support

## Architecture Overview

### Directory Structure
```
royscompany.com/
├── index.html                 # Main dashboard/homepage
├── login.html                # Authentication pages
├── register.html
├── orders.html               # Order management
├── home/                     # Core assets
│   ├── css/                  # TailwindCSS styles
│   └── js/                   # Main JavaScript functionality
├── shop/                     # Product catalog pages
│   ├── USA BANK LOGS/        # Product category directories
│   ├── MOBILE LOGS/
│   ├── CRYPTO WALLETS/
│   └── ...other categories/
├── npm/                      # JavaScript libraries
├── external-embedding/       # External widget scripts
└── product/                  # Product images
```

### Core Components

#### 1. Navigation System
- **File**: `home/js.js` (sidebar functionality)
- Fixed sidebar navigation with collapsible product categories
- Mobile-responsive overlay system
- Dropdown menu system using Popper.js

#### 2. Product Display System
- **Pattern**: Each product category has its own HTML file in `shop/` subdirectories
- Cards display product information (balance, price, description)
- Inline JavaScript functions for purchase actions
- Product images stored in `product/` directory

#### 3. Purchase Flow
- **File**: `buy-button-script.js`
- Uses sessionStorage to pass product data between pages
- Redirects to `show_order.html` for checkout process

#### 4. Dashboard Analytics
- **File**: `home/js.js` (Chart.js integration)
- Generates mock chart data for order tracking
- 7-day trend visualization for Active/Completed/Canceled orders

## Common Development Tasks

### Starting the Development Environment
```bash
# Start XAMPP Apache server
# Navigate to XAMPP Control Panel and start Apache
# Access the site at http://localhost/royscompany.com/
```

### Working with Product Pages
```bash
# Navigate to product category
cd "shop/[CATEGORY_NAME]/"
# Product pages follow naming pattern: "[PRODUCT_NAME].html"
```

### Asset Management
```bash
# Add new product images
# Place in: product/[unique_filename].[ext]

# Modify TailwindCSS
# Edit: home/css/main.css (contains full TailwindCSS build)

# Update JavaScript functionality  
# Edit: home/js.js (main functionality)
# Edit: buy-button-script.js (purchase flow)
```

### Adding New Product Categories

1. Create new directory in `shop/[NEW_CATEGORY]/`
2. Create HTML files following existing product page pattern
3. Update sidebar navigation in `index.html` and other main pages
4. Ensure relative paths are correct (`../../` for assets from shop subdirectories)

## Code Patterns

### Product Card Structure
```html
<div class="card">
  <div class="card-image">
    <img src="../../product/[IMAGE].jpeg" alt="[PRODUCT_NAME]">
  </div>
  <div class="card-content">
    <h2>[PRODUCT_NAME]</h2>
    <ul>
      <li><strong>Balance:</strong> $[AMOUNT]</li>
      <li><strong>Price:</strong> $[PRICE]</li>
      <li><strong>Description:</strong> [DETAILS]</li>
    </ul>
    <button onclick="buyProduct('[NAME]', '[PRICE]', '[BALANCE]', '[DESC]')">
      BUY
    </button>
  </div>
</div>
```

### Sidebar Navigation Pattern
- Uses CSS classes for state management: `group`, `active`, `selected`
- JavaScript toggles classes for dropdown functionality
- Responsive design with mobile overlay

### Styling Approach
- Dark theme with red accent color (#DC2625)
- TailwindCSS utility classes for responsive design
- Custom CSS for 3D card effects and animations
- Inline styles for specific component customizations

## File Dependencies

### Critical Files
- `index.html` - Main entry point, contains sidebar template used across site
- `home/js.js` - Core JavaScript functionality for navigation and UI
- `home/css/main.css` - Complete TailwindCSS build with custom styles
- `buy-button-script.js` - Purchase flow logic

### Template Consistency
- Header navigation is consistent across all pages
- Sidebar structure is duplicated in each HTML file
- Same CSS/JS assets linked from all pages using relative paths

## Development Guidelines

### Adding New Features
1. Test locally using XAMPP Apache server
2. Maintain consistent responsive design patterns
3. Follow existing dark theme color scheme
4. Ensure proper relative path usage for assets
5. Test mobile responsiveness (sidebar overlay functionality)

### Asset Optimization
- Product images should be optimized for web (JPEG format)
- External widgets load asynchronously to avoid blocking
- CSS is bundled in single file for performance

### Browser Compatibility  
- Vanilla JavaScript used for maximum compatibility
- TailwindCSS provides consistent cross-browser styling
- External dependencies loaded via CDN fallbacks

## Local Development Environment

This project requires XAMPP or similar local server environment:

1. **XAMPP Setup**: Place project in `xampp/htdocs/` directory
2. **Access URL**: `http://localhost/royscompany.com/`
3. **File Changes**: Refresh browser to see changes (no build process required)
4. **Testing**: Test across desktop and mobile viewport sizes

## External Integrations

- **TradingView Widgets**: Market data ticker at bottom of pages
- **Chat Widgets**: Tawk.to and Tidio for customer support  
- **Notification Libraries**: SweetAlert2 for user feedback
- **Analytics**: Chart.js for dashboard order visualization

The codebase follows a traditional static website architecture suitable for rapid prototyping and simple e-commerce implementations.