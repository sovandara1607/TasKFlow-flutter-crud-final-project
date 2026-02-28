import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import '../services/api_service.dart';

/// Provider that manages server-side notifications via the Laravel API.
///
/// Holds the list of notifications, unread count, and exposes
/// fetch / mark-as-read / delete operations.
class NotificationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // ── Fetch all notifications ──
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await _apiService.fetchNotifications();
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Fetch only unread count (lightweight) ──
  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await _apiService.fetchUnreadCount();
      notifyListeners();
    } catch (_) {
      // Silently fail — count stays as is
    }
  }

  // ── Mark single notification as read ──
  Future<void> markAsRead(int id) async {
    try {
      await _apiService.markNotificationAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final old = _notifications[index];
        if (!old.isRead) {
          _notifications[index] = AppNotification(
            id: old.id,
            userId: old.userId,
            type: old.type,
            title: old.title,
            message: old.message,
            data: old.data,
            readAt: DateTime.now(),
            createdAt: old.createdAt,
          );
          _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
        }
      }
      notifyListeners();
    } catch (_) {
      // Silently fail
    }
  }

  // ── Mark all notifications as read ──
  Future<void> markAllAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();
      final now = DateTime.now();
      _notifications = _notifications.map((n) {
        if (!n.isRead) {
          return AppNotification(
            id: n.id,
            userId: n.userId,
            type: n.type,
            title: n.title,
            message: n.message,
            data: n.data,
            readAt: now,
            createdAt: n.createdAt,
          );
        }
        return n;
      }).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (_) {
      // Silently fail
    }
  }

  // ── Delete single notification ──
  Future<void> deleteNotification(int id) async {
    try {
      await _apiService.deleteNotification(id);
      final removed = _notifications.firstWhere(
        (n) => n.id == id,
        orElse: () => _notifications.first,
      );
      _notifications.removeWhere((n) => n.id == id);
      if (!removed.isRead) {
        _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
      }
      notifyListeners();
    } catch (_) {
      // Silently fail
    }
  }

  // ── Delete all notifications ──
  Future<void> deleteAllNotifications() async {
    try {
      await _apiService.deleteAllNotifications();
      _notifications.clear();
      _unreadCount = 0;
      notifyListeners();
    } catch (_) {
      // Silently fail
    }
  }
}
