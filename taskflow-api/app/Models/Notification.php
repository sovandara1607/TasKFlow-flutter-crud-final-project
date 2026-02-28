<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
   use HasFactory;

   protected $fillable = [
      'user_id',
      'type',
      'title',
      'message',
      'data',
      'read_at',
   ];

   protected $casts = [
      'data'      => 'array',
      'read_at'   => 'datetime',
      'created_at' => 'datetime',
      'updated_at' => 'datetime',
   ];

   // ── Scopes ──────────────────────────────────────────────────

   public function scopeUnread($query)
   {
      return $query->whereNull('read_at');
   }

   public function scopeForUser($query, int $userId)
   {
      return $query->where('user_id', $userId);
   }

   // ── Relationships ───────────────────────────────────────────

   public function user()
   {
      return $this->belongsTo(User::class);
   }

   // ── Helpers ─────────────────────────────────────────────────

   public function markAsRead(): void
   {
      if ($this->read_at === null) {
         $this->update(['read_at' => now()]);
      }
   }

   public function isRead(): bool
   {
      return $this->read_at !== null;
   }
}
