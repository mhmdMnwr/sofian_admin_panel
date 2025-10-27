part of 'order_details_widgets.dart';

/// Bottom section with status dropdown and total.
class OrderDetailsBottomSection extends StatelessWidget {
  final Status? selectedStatus;
  final List<Status> availableStatuses;
  final Function(Status?) onStatusChanged;
  final double total;

  const OrderDetailsBottomSection({
    super.key,
    required this.selectedStatus,
    required this.availableStatuses,
    required this.onStatusChanged,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Status>(
                  value: selectedStatus,
                  hint: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      AppLocalizations.of(context)!.update_state,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  icon: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  items: availableStatuses.map((status) {
                    return DropdownMenuItem<Status>(
                      value: status,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          statusText(context, status),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onStatusChanged,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
          horizontalSpace(40),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppLocalizations.of(context)!.total} :',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              horizontalSpace(12),
              Text(
                total.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
