import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryController {
  final CollectionReference<Map<String, dynamic>> _ref = FirebaseFirestore
      .instance
      .collection('inventory');

  // Stream untuk list
  Stream<QuerySnapshot<Map<String, dynamic>>> itemsStream() {
    return _ref.snapshots();
  }

  // Hitung total item (jumlah dokumen)
  Stream<int> totalItemCount() {
    return _ref.snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Hitung total stok (sum qty)
  Stream<int> totalStockCount() {
    return _ref.snapshots().map((snapshot) {
      int total = 0;
      for (var doc in snapshot.docs) {
        final qty = doc.data()['qty'];
        total += qty is int ? qty : (qty as num).toInt();
      }
      return total;
    });
  }

  Future<void> addItem(String name, int qty) async {
    await _ref.add({
      'name': name,
      'qty': qty,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteItem(String id) async {
    await _ref.doc(id).delete();
  }

  Future<void> addLog(String action, String itemName) async {
    await FirebaseFirestore.instance.collection('activity_logs').add({
      'action': action, // "added", "deleted"
      'item': itemName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
