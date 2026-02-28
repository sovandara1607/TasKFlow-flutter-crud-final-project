<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
   /**
    * GET /api/notifications
    * Fetch all notifications for the authenticated user (newest first).
    */
   public function index(Request $request): JsonResponse
   {
      $notifications = Notification::forUser($request->user()->id)
         ->orderBy('created_at', 'desc')
         ->get();

      return response()->json([
         'success' => true,
         'message' => 'Notifications retrieved successfully',
         'data'    => $notifications,
      ], 200);
   }

   /**
    * GET /api/notifications/unread-count
    * Get the count of unread notifications.
    */
   public function unreadCount(Request $request): JsonResponse
   {
      $count = Notification::forUser($request->user()->id)
         ->unread()
         ->count();

      return response()->json([
         'success' => true,
         'data'    => ['unread_count' => $count],
      ], 200);
   }

   /**
    * PUT /api/notifications/{id}/read
    * Mark a single notification as read.
    */
   public function markAsRead(Request $request, int $id): JsonResponse
   {
      $notification = Notification::forUser($request->user()->id)->find($id);

      if (! $notification) {
         return response()->json([
            'success' => false,
            'message' => 'Notification not found',
         ], 404);
      }

      $notification->markAsRead();

      return response()->json([
         'success' => true,
         'message' => 'Notification marked as read',
         'data'    => $notification,
      ], 200);
   }

   /**
    * PUT /api/notifications/read-all
    * Mark all unread notifications as read.
    */
   public function markAllAsRead(Request $request): JsonResponse
   {
      Notification::forUser($request->user()->id)
         ->unread()
         ->update(['read_at' => now()]);

      return response()->json([
         'success' => true,
         'message' => 'All notifications marked as read',
      ], 200);
   }

   /**
    * DELETE /api/notifications/{id}
    * Delete a single notification.
    */
   public function destroy(Request $request, int $id): JsonResponse
   {
      $notification = Notification::forUser($request->user()->id)->find($id);

      if (! $notification) {
         return response()->json([
            'success' => false,
            'message' => 'Notification not found',
         ], 404);
      }

      $notification->delete();

      return response()->json([
         'success' => true,
         'message' => 'Notification deleted successfully',
      ], 200);
   }

   /**
    * DELETE /api/notifications
    * Delete all notifications for the authenticated user.
    */
   public function destroyAll(Request $request): JsonResponse
   {
      Notification::forUser($request->user()->id)->delete();

      return response()->json([
         'success' => true,
         'message' => 'All notifications deleted',
      ], 200);
   }
}
