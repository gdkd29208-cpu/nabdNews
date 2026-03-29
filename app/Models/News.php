<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class News extends Model
{
    use HasFactory;

    public const CATEGORIES = [
        'سياسة',
        'رياضة',
        'اقتصاد',
        'تكنولوجيا',
        'ثقافة',
        'عالمي',
    ];

    protected $fillable = [
        'title',
        'content',
        'image',
        'category',
        'source',
        'is_scraped',
        'user_id',
        'link',
    ];

    protected $appends = [
        'image_url',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public static function scrapedNews()
    {
        return self::where('is_scraped', true)->latest()->limit(10)->get();
    }

    public function getImageUrlAttribute(): ?string
    {
        if (! $this->image) {
            return null;
        }

        return Storage::disk(config('filesystems.default', 'public'))->url($this->image);
    }
}
