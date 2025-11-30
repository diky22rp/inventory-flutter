import 'package:flutter/material.dart';
import 'package:inventory_flutter/core/theme/colors.dart';

class RecentActivityItem extends StatelessWidget {
  final String title;
  final String time;

  const RecentActivityItem({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.update, color: AppColors.primaryBlue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      ),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
      ),
    );
  }
}
