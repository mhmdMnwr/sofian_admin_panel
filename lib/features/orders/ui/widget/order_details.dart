import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_details_model.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_model.dart';
import 'package:sofian_admin_panel/features/orders/ui/widget/order_details/order_details_widgets.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

/// Dialog to view and edit order details.
class OrderDetailsDialog extends StatefulWidget {
  final OrderDetailsModel order;
  final void Function(Status? newStatus)? onStatusChanged;

  const OrderDetailsDialog({
    super.key,
    required this.order,
    this.onStatusChanged,
  });

  @override
  State<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  late List<OrderProducts> products;
  Status? selectedStatus;

  final List<Status> availableStatuses = [
    Status.pending,
    Status.processing,
    Status.shipped,
    Status.delivered,
    Status.canceled,
  ];

  @override
  void initState() {
    super.initState();
    products =
        widget.order.orderProducts
            ?.map(
              (p) => OrderProducts(
                productName: p.productName,
                boxesQuantity: p.boxesQuantity,
                unitesQuantity: p.unitesQuantity,
                price: p.price,
                unitPerBox: p.unitPerBox,
              ),
            )
            .toList() ??
        [];
    selectedStatus = widget.order.status;
  }

  double get computedTotal => products.fold(0.0, (sum, p) {
    final totalUnits = _getTotalUnits(p);
    return sum + totalUnits * (p.price ?? 0.0);
  });

  double _getTotalUnits(OrderProducts p) {
    // If it's a weight product (double quantity)
    if (p.unitesQuantity != null && p.unitesQuantity! % 1 != 0) {
      return p.unitesQuantity!;
    }
    // Otherwise calculate: boxes * unitPerBox + rest
    final boxes = p.boxesQuantity ?? 0;
    final rest = p.unitesQuantity?.toInt() ?? 0;
    final unitPerBox = p.unitPerBox ?? 1;
    return (boxes * unitPerBox + rest).toDouble();
  }

  void _incrementQuantity(int index) {
    setState(() {
      final product = products[index];
      // If it's a weight product, increment by 0.5
      if (product.unitesQuantity != null && product.unitesQuantity! % 1 != 0) {
        product.unitesQuantity = (product.unitesQuantity ?? 0) + 0.5;
      } else {
        // Increment rest units
        product.unitesQuantity = ((product.unitesQuantity ?? 0).toInt() + 1)
            .toDouble();
      }
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final product = products[index];
      // If it's a weight product, decrement by 0.5
      if (product.unitesQuantity != null && product.unitesQuantity! % 1 != 0) {
        final newValue = (product.unitesQuantity ?? 0) - 0.5;
        product.unitesQuantity = newValue < 0 ? 0 : newValue;
      } else {
        // Decrement rest units
        final newValue = (product.unitesQuantity ?? 0).toInt() - 1;
        if (newValue < 0 && (product.boxesQuantity ?? 0) > 0) {
          // Borrow from boxes
          product.boxesQuantity = (product.boxesQuantity ?? 0) - 1;
          product.unitesQuantity = ((product.unitPerBox ?? 1) - 1).toDouble();
        } else {
          product.unitesQuantity = (newValue < 0 ? 0 : newValue).toDouble();
        }
      }
    });
  }

  void _onStatusSelected(Status? status) {
    setState(() => selectedStatus = status);
    widget.onStatusChanged?.call(status);
  }

  void _onEditOrder() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),

      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderDetailsHeader(orderId: widget.order.orderId),
            verticalSpace(16),
            OrderDetailsCustomerInfo(client: widget.order.client),
            verticalSpace(16),
            OrderDetailsOrderInfo(date: widget.order.date),
            verticalSpace(16),
            Expanded(
              child: OrderDetailsProductsTable(
                products: products,
                onIncrement: _incrementQuantity,
                onDecrement: _decrementQuantity,
              ),
            ),
            verticalSpace(16),
            OrderDetailsBottomSection(
              selectedStatus: selectedStatus,
              availableStatuses: availableStatuses,
              onStatusChanged: _onStatusSelected,
              total: computedTotal,
            ),
            verticalSpace(16),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: AppLocalizations.of(context)!.edit,
                  horizontalPadding: 0,
                  onTap: _onEditOrder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the order details dialog.
Future<void> showOrderDetailsDialog(
  BuildContext context, {
  required OrderDetailsModel order,
  void Function(Status? newStatus)? onStatusChanged,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) =>
        OrderDetailsDialog(order: order, onStatusChanged: onStatusChanged),
  );
}
