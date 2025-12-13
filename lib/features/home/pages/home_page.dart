import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/features/auth/provider/auth_notifier.dart';
import 'package:inventory_flutter/features/home/widgets/quick_actions.dart';
import 'package:inventory_flutter/features/home/widgets/recent_activity_item.dart';
import 'package:inventory_flutter/features/home/widgets/summary_card.dart';
import 'package:inventory_flutter/features/inventory/controller/inventory_controller.dart';
import 'package:inventory_flutter/features/inventory/pages/add_inventory_page.dart';
import 'package:inventory_flutter/features/inventory/pages/inventory_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = FirebaseAuth.instance.currentUser;
    final controller = InventoryController();
    final userProvider = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------
              // HELLO USER
              // ----------------------------------------------------------
              Text(
                "Hello,",
                style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
              Text(
                "${userProvider?.email ?? 'User'} 👋",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------------------
              // SUMMARY CARDS (Total Items & Total Stock)
              // ----------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: controller.totalItemCount(),
                      builder: (context, snapshot) {
                        final totalItems = snapshot.data ?? 0;
                        return SummaryCard(
                          value: "$totalItems",
                          label: "Total Items",
                          icon: Icons.inventory_2_outlined,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: controller.totalStockCount(),
                      builder: (context, snapshot) {
                        final totalStock = snapshot.data ?? 0;
                        return SummaryCard(
                          value: "$totalStock",
                          label: "Total Stock",
                          icon: Icons.numbers,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------------
              // OPTIONAL ILLUSTRATION
              // ----------------------------------------------------------
              Center(
                child: Icon(
                  Icons.inventory_outlined,
                  size: 80,
                  color: AppColors.primaryBlue,
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------------------
              // QUICK ACTIONS (Add Inventory / View Inventory)
              // ----------------------------------------------------------
              QuickActions(
                onAddInventory: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddInventoryPage()),
                  );
                },
                onViewInventory: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InventoryPage()),
                  );
                },
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------------
              // RECENT ACTIVITY (REALTIME)
              // ----------------------------------------------------------
              const Text(
                "Recent Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("activity_logs")
                      .orderBy("timestamp", descending: true)
                      .limit(5)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Text(
                        "No activity yet",
                        style: TextStyle(color: AppColors.textGrey),
                      );
                    }

                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data();
                        final action = data['action'] ?? '';
                        final item = data['item'] ?? '-';
                        final ts = (data['timestamp'] as Timestamp?)?.toDate();

                        return RecentActivityItem(
                          title: "${capitalize(action)}: $item",
                          time: timeAgo(ts),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// --------------------------------------------------------------
// HELPER FUNCTIONS (Time Ago + Capitalize)
// --------------------------------------------------------------
//

String timeAgo(DateTime? date) {
  if (date == null) return "just now";

  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) return "just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
  if (diff.inHours < 24) return "${diff.inHours} hours ago";
  if (diff.inDays < 7) return "${diff.inDays} days ago";

  return "${(diff.inDays / 7).floor()} weeks ago";
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
