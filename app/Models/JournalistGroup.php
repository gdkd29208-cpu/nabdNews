<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JournalistGroup extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'password',
        'owner_id',
    ];

    protected $hidden = [
        'password',
    ];

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function members()
    {
        return $this->belongsToMany(User::class)
            ->withTimestamps();
    }
}
