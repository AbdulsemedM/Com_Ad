import 'package:flutter/material.dart';
import '../../model/delivery_items_model.dart';

class DeliveryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const DeliveryFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (_) => onSelected(),
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
    );
  }
}

class DeliveryItemCard extends StatelessWidget {
  final DeliveryItemsModel delivery;

  const DeliveryItemCard({
    Key? key,
    required this.delivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(delivery.appName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${delivery.deliveryType}'),
            Text('Status: ${delivery.deliveryStatus}'),
            Text('Assigned: ${delivery.assignedDate}'),
          ],
        ),
        trailing: _getStatusIcon(delivery.validationStatus),
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == 'validated'
            ? Colors.green
            : status == 'pending'
                ? Colors.orange
                : Colors.red,
      ),
      child: Icon(
        status == 'validated'
            ? Icons.check
            : status == 'pending'
                ? Icons.pending
                : Icons.close,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
