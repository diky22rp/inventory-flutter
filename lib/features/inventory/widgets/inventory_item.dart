import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/features/inventory/controller/inventory_controller.dart';
import 'package:inventory_flutter/features/inventory/pages/detail_inventory_page.dart';

class InventoryItemTile extends StatelessWidget {
  final DocumentSnapshot doc;

  const InventoryItemTile({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final name = data['name'] ?? '';
    final qty = data['qty'] ?? 0;

    return ListTile(
      leading: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.primaryBlue,
      ),
      title: Text(name, style: const TextStyle(color: AppColors.textDark)),
      subtitle: Text(
        "Qty: $qty",
        style: const TextStyle(color: AppColors.textGrey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: AppColors.danger),
        onPressed: () async {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'] ?? '-';

          await InventoryController().deleteItem(doc.id);
          await InventoryController().addLog("deleted", name);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailInventoryPage(doc: doc)),
        );
      },
    );
  }
}
