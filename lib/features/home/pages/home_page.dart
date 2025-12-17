import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_flutter/core/theme/colors.dart';
import 'package:inventory_flutter/features/auth/controller/auth_controller.dart';
import 'package:inventory_flutter/features/home/widgets/quick_actions.dart';
import 'package:inventory_flutter/features/home/widgets/recent_activity_item.dart';
import 'package:inventory_flutter/features/home/widgets/summary_card.dart';
import 'package:inventory_flutter/features/inventory/controller/inventory_controller.dart';
import 'package:inventory_flutter/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final authController = Get.find<AuthController>();
  final inventoryController = InventoryController(); // belum GetX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------------------------------------------
              // HELLO USER (GetX)
              // ----------------------------------------------------------
              Obx(() {
                final email =
                    authController.firebaseUser.value?.email ?? "User";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello,",
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                    ),
                    Text(
                      "$email 👋",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // ----------------------------------------------------------
              // SUMMARY CARDS
              // ----------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: inventoryController.totalItemCount(),
                      builder: (context, snapshot) {
                        return SummaryCard(
                          value: "${snapshot.data ?? 0}",
                          label: "Total Items",
                          icon: Icons.inventory_2_outlined,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: inventoryController.totalStockCount(),
                      builder: (context, snapshot) {
                        return SummaryCard(
                          value: "${snapshot.data ?? 0}",
                          label: "Total Stock",
                          icon: Icons.numbers,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: Icon(
                  Icons.inventory_outlined,
                  size: 80,
                  color: AppColors.primaryBlue,
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------------------
              // QUICK ACTIONS (GetX ROUTING)
              // ----------------------------------------------------------
              QuickActions(
                onAddInventory: () {
                  Get.toNamed(AppRoutes.addInventory);
                },
                onViewInventory: () {
                  Get.toNamed(AppRoutes.inventory);
                },
              ),

              const SizedBox(height: 24),

              // ----------------------------------------------------------
              // RECENT ACTIVITY
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

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

String timeAgo(DateTime? date) {
  if (date == null) return "just now";

  final diff = DateTime.now().difference(date);

  if (diff.inSeconds < 60) return "just now";
  if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
  if (diff.inHours < 24) return "${diff.inHours} hours ago";
  if (diff.inDays < 7) return "${diff.inDays} days ago";

  return "${(diff.inDays / 7).floor()} weeks ago";
}
