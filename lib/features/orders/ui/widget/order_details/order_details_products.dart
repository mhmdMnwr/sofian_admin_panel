part of 'order_details_widgets.dart';

/// Products table with scrollable list.
class OrderDetailsProductsTable extends StatelessWidget {
  final List<OrderProducts> products;
  final Function(int) onIncrement;
  final Function(int) onDecrement;

  const OrderDetailsProductsTable({
    super.key,
    required this.products,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ProductsTableHeader(),
        verticalSpace(2),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                products.length,
                (index) => _ProductRow(
                  product: products[index],
                  index: index,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Products table header.
class _ProductsTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w600);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          horizontalSpace(12),
          Expanded(
            flex: 5,
            child: Text(
              AppLocalizations.of(context)!.product,
              style: labelStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.quantity,
                style: labelStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppLocalizations.of(context)!.unit_price,
              textAlign: TextAlign.right,
              style: labelStyle,
            ),
          ),
          horizontalSpace(12),
          Expanded(
            flex: 2,
            child: Text(
              AppLocalizations.of(context)!.total,
              textAlign: TextAlign.right,
              style: labelStyle,
            ),
          ),
          horizontalSpace(12),
        ],
      ),
    );
  }
}

/// Single product row.
class _ProductRow extends StatefulWidget {
  final OrderProducts product;
  final int index;
  final Function(int) onIncrement;
  final Function(int) onDecrement;

  const _ProductRow({
    required this.product,
    required this.index,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  bool _isEditing = false;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: _getQuantityText());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  String _getQuantityText() {
    final product = widget.product;
    // If it's a weight product (double)
    if (product.unitesQuantity != null && product.unitesQuantity! % 1 != 0) {
      return product.unitesQuantity!.toStringAsFixed(2);
    }
    // Otherwise show boxes+rest format
    final boxes = product.boxesQuantity ?? 0;
    final rest = product.unitesQuantity?.toInt() ?? 0;
    return '$boxes+$rest';
  }

  double _getTotalUnits() {
    final product = widget.product;
    // If it's a weight product
    if (product.unitesQuantity != null && product.unitesQuantity! % 1 != 0) {
      return product.unitesQuantity!;
    }
    // Calculate: boxes * unitPerBox + rest
    final boxes = product.boxesQuantity ?? 0;
    final rest = product.unitesQuantity?.toInt() ?? 0;
    final unitPerBox = product.unitPerBox ?? 1;
    return (boxes * unitPerBox + rest).toDouble();
  }

  String _getQuantityDisplay() {
    final product = widget.product;
    // If it's a weight product
    if (product.unitesQuantity != null && product.unitesQuantity! % 1 != 0) {
      return '${product.unitesQuantity!.toStringAsFixed(2)} kg';
    }
    // Show: boxes * unitPerBox + rest = total
    final boxes = product.boxesQuantity ?? 0;
    final rest = product.unitesQuantity?.toInt() ?? 0;
    final unitPerBox = product.unitPerBox ?? 1;
    final total = boxes * unitPerBox + rest;
    return '$boxes×$unitPerBox+$rest = $total';
  }

  void _handleQuantityEdit() {
    final text = _quantityController.text.trim();

    // Check if it's a weight (contains decimal point)
    if (text.contains('.')) {
      final weight = double.tryParse(text);
      if (weight != null && weight >= 0) {
        widget.product.unitesQuantity = weight;
        widget.product.boxesQuantity = 0;
      }
    } else if (text.contains('+')) {
      // Parse "boxes+rest" format
      final parts = text.split('+');
      if (parts.length == 2) {
        final boxes = int.tryParse(parts[0].trim());
        final rest = int.tryParse(parts[1].trim());
        if (boxes != null && rest != null && boxes >= 0 && rest >= 0) {
          widget.product.boxesQuantity = boxes;
          widget.product.unitesQuantity = rest.toDouble();
        }
      }
    } else {
      // Just a number, treat as rest
      final rest = int.tryParse(text);
      if (rest != null && rest >= 0) {
        widget.product.boxesQuantity = 0;
        widget.product.unitesQuantity = rest.toDouble();
      }
    }

    setState(() {
      _isEditing = false;
      _quantityController.text = _getQuantityText();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = widget.product.price ?? 0.0;
    final totalUnits = _getTotalUnits();
    final total = totalUnits * unitPrice;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          horizontalSpace(12),
          Expanded(
            flex: 5,
            child: Text(
              widget.product.productName ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: _isEditing
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 80.w,
                          child: TextField(
                            controller: _quantityController,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 4.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              isDense: true,
                            ),
                            onSubmitted: (_) => _handleQuantityEdit(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.check, size: 16),
                          onPressed: _handleQuantityEdit,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuantityButton(
                          icon: Icons.remove,
                          onTap: () {
                            widget.onDecrement(widget.index);
                            setState(() {
                              _quantityController.text = _getQuantityText();
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: InkWell(
                            onTap: () => setState(() => _isEditing = true),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                _getQuantityDisplay(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        _QuantityButton(
                          icon: Icons.add,
                          onTap: () {
                            widget.onIncrement(widget.index);
                            setState(() {
                              _quantityController.text = _getQuantityText();
                            });
                          },
                        ),
                      ],
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              unitPrice.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: Text(
              total.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          horizontalSpace(12),
        ],
      ),
    );
  }
}

/// Quantity increment/decrement button.
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Center(child: Icon(icon, size: 14, color: Colors.grey.shade700)),
      ),
    );
  }
}
