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
                quantity: p.quantity,
                price: p.price,
              ),
            )
            .toList() ??
        [];
    selectedStatus = widget.order.status;
  }

  double get computedTotal => products.fold(
    0.0,
    (sum, p) => sum + (p.quantity ?? 0) * (p.price ?? 0.0),
  );

  void _incrementQuantity(int index) {
    setState(() {
      products[index].quantity = (products[index].quantity ?? 0) + 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final quantity = (products[index].quantity ?? 0) - 1;
      products[index].quantity = quantity < 0 ? 0 : quantity;
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
                child: AddButton(
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
