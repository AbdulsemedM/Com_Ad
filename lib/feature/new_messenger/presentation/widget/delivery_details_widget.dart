import 'package:flutter/material.dart';
import '../../model/delivery_details_model.dart';
import 'package:shimmer/shimmer.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final String code;
  final bool isValidation;
  final String codeName;

  const StatusBadge({
    Key? key,
    required this.status,
    required this.code,
    this.isValidation = false,
    required this.codeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isValidation
        ? status == 'validated'
            ? Colors.green.shade100
            : Colors.orange.shade100
        : status == 'delivered'
            ? Colors.blue.shade100
            : Colors.purple.shade100;

    Color textColor = isValidation
        ? status == 'validated'
            ? Colors.green.shade700
            : Colors.orange.shade700
        : status == 'delivered'
            ? Colors.blue.shade700
            : Colors.purple.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            codeName,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final String contactPerson;
  final String phone;
  final IconData icon;

  const AddressCard({
    Key? key,
    required this.title,
    required this.address,
    required this.contactPerson,
    required this.phone,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              address,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              contactPerson,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              phone,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetailsCard extends StatelessWidget {
  final DeliveryDetailsModel details;

  const ItemDetailsCard({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildDetailRow('Name', details.itemModel!.itemName),
            _buildDetailRow('Quantity', details.itemModel!.quantity.toString()),
            _buildDetailRow('Reference', details.itemModel!.orderItemRef),
            // if (details.itemModel.briefDescription != null)
            _buildDetailRow('Description', details.itemModel!.briefDescription),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryDetailsShimmer extends StatelessWidget {
  const DeliveryDetailsShimmer({Key? key}) : super(key: key);

  Widget _buildShimmerContainer({
    double height = 20,
    double width = double.infinity,
    double borderRadius = 8,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header shimmer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerContainer(width: 120, height: 50),
                      _buildShimmerContainer(width: 120, height: 50),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildShimmerContainer(height: 80),
                ],
              ),
            ),

            // Item details shimmer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            _buildShimmerContainer(width: 80, height: 20),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildShimmerContainer(height: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Address cards shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: _buildShimmerContainer(height: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: _buildShimmerContainer(height: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
