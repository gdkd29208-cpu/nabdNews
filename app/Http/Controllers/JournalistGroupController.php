<?php

namespace App\Http\Controllers;

use App\Models\JournalistGroup;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;

class JournalistGroupController extends Controller
{
    private function ensureGroupsTablesExist()
    {
        if (! Schema::hasTable('journalist_groups') || ! Schema::hasTable('journalist_group_user')) {
            return redirect()
                ->route('profile')
                ->with('error', 'ميزة كروبات الصحفيين تحتاج تشغيل قاعدة البيانات الجديدة أولاً عبر php artisan migrate.');
        }

        return null;
    }

    public function store(Request $request)
    {
        if ($response = $this->ensureGroupsTablesExist()) {
            return $response;
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $group = JournalistGroup::create([
            'name' => $validated['name'],
            'description' => $validated['description'] ?? null,
            'password' => Hash::make($validated['password']),
            'owner_id' => Auth::id(),
        ]);

        $group->members()->syncWithoutDetaching([Auth::id()]);

        return redirect()
            ->route('profile')
            ->with('success', 'تم إنشاء كروب الصحفيين بنجاح وإضافتك إليه.');
    }

    public function join(Request $request)
    {
        if ($response = $this->ensureGroupsTablesExist()) {
            return $response;
        }

        $validated = $request->validate([
            'group_id' => 'required|exists:journalist_groups,id',
            'password' => 'required|string',
        ]);

        $group = JournalistGroup::findOrFail($validated['group_id']);

        if (! Hash::check($validated['password'], $group->password)) {
            return redirect()
                ->route('profile')
                ->with('error', 'كلمة مرور الكروب غير صحيحة.');
        }

        $group->members()->syncWithoutDetaching([Auth::id()]);

        return redirect()
            ->route('profile')
            ->with('success', 'تم الانضمام إلى كروب الصحفيين بنجاح.');
    }
}
