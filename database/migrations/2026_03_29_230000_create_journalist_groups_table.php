<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('journalist_groups', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->string('password');
            $table->foreignId('owner_id')->constrained('users')->cascadeOnDelete();
            $table->timestamps();
        });

        Schema::create('journalist_group_user', function (Blueprint $table) {
            $table->id();
            $table->foreignId('journalist_group_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->timestamps();
            $table->unique(['journalist_group_id', 'user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('journalist_group_user');
        Schema::dropIfExists('journalist_groups');
    }
};
