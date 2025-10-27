part of 'order_details_widgets.dart';

/// Header widget with title and close button.
class OrderDetailsHeader extends StatelessWidget {
  final String? orderId;

  const OrderDetailsHeader({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppLocalizations.of(context)!.order_details} #${orderId ?? ''}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

/// Customer information section.
class OrderDetailsCustomerInfo extends StatelessWidget {
  final Client? client;

  const OrderDetailsCustomerInfo({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.customer_info,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        verticalSpace(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLine(
                    label: '${AppLocalizations.of(context)!.name} :',
                    value: client?.name ?? '',
                  ),
                  _InfoLine(
                    label: '${AppLocalizations.of(context)!.email} :',
                    value: client?.email ?? '',
                  ),
                  _InfoLine(
                    label: '${AppLocalizations.of(context)!.phone_number} :',
                    value: client?.phone ?? '',
                  ),
                ],
              ),
            ),
            horizontalSpace(40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLine(
                    label: '${AppLocalizations.of(context)!.address} :',
                    value: client?.address ?? '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Order information section.
class OrderDetailsOrderInfo extends StatelessWidget {
  final String? date;

  const OrderDetailsOrderInfo({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.order_info,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        verticalSpace(8),
        _InfoLine(
          label: '${AppLocalizations.of(context)!.date} :',
          value: date ?? '',
        ),
      ],
    );
  }
}

/// Internal info line widget.
class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
