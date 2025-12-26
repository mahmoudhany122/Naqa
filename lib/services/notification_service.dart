import 'package:flutter/material.dart';

class NotificationService {
  static void showAchievementUnlocked(
      BuildContext context,
      String title,
      String description,
      String icon,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🎉 إنجاز جديد!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'عرض',
          textColor: Colors.black,
          onPressed: () {
            // Navigate to achievements page
          },
        ),
      ),
    );
  }

  static void showDailyReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: const Text(
          '💪 استمر في التقدم! لا تنسى تسجيل يومك',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}