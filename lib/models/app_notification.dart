import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Model representing a server-side notification from the Laravel API.
class AppNotification {
  final int id;
  final int userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final DateTime? readAt;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.readAt,
    required this.createdAt,
  });

  /// Whether this notification has been read.
  bool get isRead => readAt != null;

  /// Create from JSON returned by the API.
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'] as Map)
          : null,
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Icon based on notification type.
  IconData get icon {
    switch (type) {
      case 'task_completed':
        return Icons.check_circle_rounded;
      case 'task_created':
        return Icons.add_task_rounded;
      case 'login_success':
        return Icons.login_rounded;
      case 'profile_updated':
        return Icons.person_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  /// Color based on notification type.
  Color get color {
    switch (type) {
      case 'task_completed':
        return AppConstants.successColor;
      case 'task_created':
        return AppConstants.accentSky;
      case 'login_success':
        return AppConstants.accentMint;
      case 'profile_updated':
        return AppConstants.accentPink;
      default:
        return AppConstants.primaryLight;
    }
  }

  /// Human-readable relative time string.
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
