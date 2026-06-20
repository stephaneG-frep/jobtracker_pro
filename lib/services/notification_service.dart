class NotificationService {
  static Future<void> init() async {
    // Notification service is disabled in this version to avoid plugin compatibility issues.
    return;
  }

  static Future<void> showNotification(int id, String title, String body) async {
    // Notifications are currently stubbed in local-only mode.
    return;
  }
}
