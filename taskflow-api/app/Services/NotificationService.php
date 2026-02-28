<?php

namespace App\Services;

use App\Models\Notification;

/**
 * Reusable service for creating notifications.
 * Keeps controller/trigger code thin and consistent.
 */
class NotificationService
{
   /**
    * Create a notification for a user.
    *
    * @param  int          $userId
    * @param  string       $type     e.g. task_completed, login_success, profile_updated
    * @param  string       $title
    * @param  string       $message
    * @param  array|null   $data     Extra JSON payload
    * @return Notification
    */
   public function send(
      int $userId,
      string $type,
      string $title,
      string $message,
      ?array $data = null
   ): Notification {
      return Notification::create([
         'user_id' => $userId,
         'type'    => $type,
         'title'   => $title,
         'message' => $message,
         'data'    => $data,
      ]);
   }

   /**
    * Notify about task completion.
    */
   public function taskCompleted(int $userId, int $taskId, string $taskTitle): Notification
   {
      return $this->send(
         $userId,
         'task_completed',
         'Task Completed',
         "You completed \"{$taskTitle}\".",
         ['task_id' => $taskId, 'task_title' => $taskTitle]
      );
   }

   /**
    * Notify about successful login.
    */
   public function loginSuccess(int $userId, ?string $ipAddress = null, ?string $userAgent = null): Notification
   {
      return $this->send(
         $userId,
         'login_success',
         'Login Successful',
         'You logged in successfully.',
         [
            'ip_address' => $ipAddress,
            'user_agent' => $userAgent,
            'login_at'   => now()->toDateTimeString(),
         ]
      );
   }

   /**
    * Notify about task creation.
    */
   public function taskCreated(int $userId, int $taskId, string $taskTitle): Notification
   {
      return $this->send(
         $userId,
         'task_created',
         'Task Created',
         "You created a new task: \"{$taskTitle}\".",
         ['task_id' => $taskId, 'task_title' => $taskTitle]
      );
   }

   /**
    * Notify about profile update.
    */
   public function profileUpdated(int $userId): Notification
   {
      return $this->send(
         $userId,
         'profile_updated',
         'Profile Updated',
         'Your profile was updated successfully.',
      );
   }

   /**
    * Get unread count for a user.
    */
   public function unreadCount(int $userId): int
   {
      return Notification::forUser($userId)->unread()->count();
   }
}
