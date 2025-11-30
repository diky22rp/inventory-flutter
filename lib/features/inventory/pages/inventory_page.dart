import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_flutter/features/inventory/controller/inventory_controller.dart';
import 'package:inventory_flutter/features/inventory/widgets/inventory_item.dart';

import 'add_inventory_page.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = InventoryController();

    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.itemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No inventory"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return InventoryItemTile(doc: docs[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddInventoryPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
