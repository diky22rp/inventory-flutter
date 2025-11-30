import 'package:flutter/material.dart';
import 'package:inventory_flutter/core/theme/colors.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAddInventory;
  final VoidCallback onViewInventory;

  const QuickActions({
    super.key,
    required this.onAddInventory,
    required this.onViewInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            onPressed: onAddInventory,
            child: const Text("Add Inventory"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onViewInventory,
            child: const Text("View Inventory"),
          ),
        ),
      ],
    );
  }
}
