@extends('layouts.app')

@section('title', 'تسجيل الدخول - نبض نيوز')

@section('content')
    <section class="auth-card">
        <div class="section-heading">
            <div>
                <h1 class="page-title">تسجيل الدخول</h1>
                <p class="muted-text">ادخل إلى حسابك لمتابعة النشر وإدارة الأخبار.</p>
            </div>
        </div>

        @if ($errors->any())
            <div class="status error">
                <i class="fas fa-exclamation-triangle"></i>
                @foreach ($errors->all() as $error)
                    <div>{{ $error }}</div>
                @endforeach
            </div>
        @endif

        <form method="POST" action="{{ route('login') }}" class="stack">
            @csrf
            <div class="form-group">
                <label for="email">البريد الإلكتروني</label>
                <input id="email" type="email" name="email" value="{{ old('email') }}" required autocomplete="email" class="form-control" placeholder="example@email.com">
            </div>

            <div class="form-group">
                <label for="password">كلمة المرور</label>
                <input id="password" type="password" name="password" required autocomplete="current-password" class="form-control" placeholder="••••••••">
            </div>

            <button type="submit" class="btn btn-primary">
                <i class="fas fa-sign-in-alt"></i>
                دخول إلى الحساب
            </button>
        </form>

        <div class="inline-meta" style="margin-top: 1.5rem;">
            <a href="{{ route('register') }}" class="button-link btn-secondary btn-sm">إنشاء حساب جديد</a>
        </div>
    </section>
@endsection
