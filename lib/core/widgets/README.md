# Generic Table Architecture

This directory contains a refactored table system with separated concerns for better maintainability and scalability.

## Files Structure

### 1. `generic_table.dart` - Main Widget
- Contains the core table widget logic
- Handles widget composition and state management
- Imports and uses helper classes for styling and business logic

### 2. `table_styles.dart` - Styling & Design System
- Centralized styling configuration
- Responsive design calculations
- Color, dimension, and decoration definitions
- Typography and spacing management

### 3. `table_logic.dart` - Business Logic Helper
- Pure business logic functions
- Data processing and calculations
- Validation and utility methods
- RTL/LTR support logic

## Key Features

### ✅ Fixed Headers (Sticky Headers)
- Headers remain visible when scrolling vertically
- Headers scroll horizontally with content
- Separate scroll controllers for header and body

### ✅ Responsive Design
- Breakpoint-based styling (768px, 1200px)
- Adaptive font sizes and spacing
- No overflow on any screen size

### ✅ Dual Scrolling
- **Horizontal**: For tables with > 4 columns
- **Vertical**: For large datasets
- **Visible Scrollbars**: Always visible when needed

### ✅ Clean Architecture
- **Separation of Concerns**: Logic, styling, and UI are separated
- **Reusable Components**: Styles and logic can be reused
- **Easy Maintenance**: Changes to styling or logic are isolated

## Usage Example

```dart
GenericTable(
  headers: ['Name', 'Email', 'Phone', 'Status', 'Date'],
  data: [
    ['John Doe', 'john@example.com', '+1234567890', 'Active', '2025-01-01'],
    // ... more rows
  ],
  flexValues: [2, 3, 2, 1, 2],
  showEdit: true,
  showDelete: true,
  showView: true,
  onEdit: (index) => print('Edit row $index'),
  onDelete: (index) => print('Delete row $index'),
  onView: (index) => print('View row $index'),
)
```

## Responsive Behavior

### Small Screens (< 768px)
- Smaller font sizes
- Reduced padding
- Minimum column width: 120px

### Medium Screens (768px - 1200px)  
- Standard font sizes
- Normal padding
- Column width: 150-200px

### Large Screens (> 1200px)
- Larger font sizes
- Generous padding  
- Maximum column width: 250px

## Scrolling Behavior

### ≤ 4 Columns
- Responsive flex-based layout
- Only vertical scrolling if needed
- Full-width utilization

### > 4 Columns  
- Fixed-width columns
- Horizontal scrolling enabled
- Sticky headers
- Visible scrollbars

## Technical Implementation

### Fixed Headers Solution
```dart
Column(
  children: [
    // Fixed header (horizontally scrollable)
    SizedBox(
      height: 56,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HeaderWidget(),
      ),
    ),
    // Scrollable body (both directions)
    Expanded(
      child: SingleChildScrollView(...),
    ),
  ],
)
```

This architecture ensures maintainable, scalable, and responsive table functionality for web applications.