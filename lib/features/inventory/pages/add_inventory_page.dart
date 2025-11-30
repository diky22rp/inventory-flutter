import 'package:flutter/material.dart';
import 'package:inventory_flutter/core/widgets/custom_button.dart';
import 'package:inventory_flutter/core/widgets/custom_textfield.dart';
import 'package:inventory_flutter/features/inventory/controller/inventory_controller.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final nameC = TextEditingController();
  final qtyC = TextEditingController();
  bool isLoading = false;
  String? errorText;

  Future<void> _save() async {
    if (nameC.text.trim().isEmpty || qtyC.text.trim().isEmpty) {
      setState(() {
        errorText = "Name and quantity are required.";
      });
      return;
    }

    final qty = int.tryParse(qtyC.text.trim());
    if (qty == null) {
      setState(() {
        errorText = "Quantity must be a number.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      await InventoryController().addItem(nameC.text.trim(), qty);
      await InventoryController().addLog("added", nameC.text.trim());

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      print(e);
      setState(() {
        errorText = "Failed to save item.";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    qtyC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Inventory")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(controller: nameC, label: "Item Name"),
              const SizedBox(height: 16),
              CustomTextField(controller: qtyC, label: "Quantity"),
              const SizedBox(height: 12),
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(text: "Save", onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
