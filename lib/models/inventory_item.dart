class InventoryItem {
  final String id;
  final String name;
  final int qty;

  InventoryItem({required this.id, required this.name, required this.qty});

  factory InventoryItem.fromMap(String id, Map<String, dynamic> data) {
    return InventoryItem(
      id: id,
      name: data['name'] ?? '',
      qty: (data['qty'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'qty': qty};
  }
}
