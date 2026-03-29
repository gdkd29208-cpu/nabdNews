<?php

namespace App\Http\Controllers;

use App\Models\JournalistGroup;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class AuthController extends Controller
{
    public function showLogin()
    {
        return view('auth.login');
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

        if ($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }

        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();
            return redirect()->intended('/')->with('success', 'تم تسجيل الدخول بنجاح');
        }

        return back()->withErrors([
            'email' => 'بيانات الدخول غير صحيحة.',
        ])->withInput($request->only('email'));
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        return redirect('/');
    }

    public function showRegister()
    {
        return view('auth.register');
    }


    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'admin_password' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }

        $userData = [
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ];

        $adminRegistrationSecret = (string) config('auth.admin_registration_secret', '');

        if ($adminRegistrationSecret !== '' && hash_equals($adminRegistrationSecret, (string) $request->admin_password)) {
            $userData['is_admin'] = true;
        }

        $user = User::create(array_filter($userData));
        Auth::login($user);
        return redirect('/')->with('success', '✅ حساب ' . ($userData['is_admin'] ?? false ? 'إداري' : 'عادي') . ' تم إنشاؤه!');
    }

    public function showProfile()
    {
        $user = auth()->user()->load('news');
        $groupsFeatureReady = Schema::hasTable('journalist_groups') && Schema::hasTable('journalist_group_user');
        $availableGroups = collect();

        if ($groupsFeatureReady) {
            $user->load([
                'ownedJournalistGroups.members',
                'journalistGroups.owner',
            ]);

            $availableGroups = JournalistGroup::with(['owner', 'members'])
                ->latest()
                ->get();
        }

        return view('profile', compact('user', 'availableGroups', 'groupsFeatureReady'));
    }

    public function updateProfile(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . auth()->id(),
            'password' => 'nullable|string|min:8|confirmed'
        ]);

        $user = auth()->user();
        $user->name = $request->name;
        $user->email = $request->email;
        if ($request->filled('password')) {
            $user->password = Hash::make($request->password);
        }
        $user->save();

        return redirect()->back()->with('success', '✅ تم تحديث الملف الشخصي بنجاح!');
    }

}
