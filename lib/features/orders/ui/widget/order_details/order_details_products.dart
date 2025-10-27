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
class _ProductRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final quantity = product.quantity ?? 0;
    final unitPrice = product.price ?? 0.0;
    final total = quantity * unitPrice;

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
              product.productName ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QuantityButton(
                    icon: Icons.remove,
                    onTap: () => onDecrement(index),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _QuantityButton(
                    icon: Icons.add,
                    onTap: () => onIncrement(index),
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
