@extends('layouts.app')

@section('title', 'إنشاء حساب - نبض نيوز')

@section('content')
    <section class="auth-card">
        <div class="section-heading">
            <div>
                <h1 class="page-title">إنشاء حساب</h1>
                <p class="muted-text">أنشئ حسابًا جديدًا وابدأ بإدارة محتواك بسهولة.</p>
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

        <form method="POST" action="{{ route('register') }}" class="stack">
            @csrf

            <div class="form-grid">
                <div class="form-group">
                    <label for="name">الاسم الكامل</label>
                    <input id="name" type="text" name="name" value="{{ old('name') }}" required class="form-control" placeholder="الاسم الكامل">
                </div>

                <div class="form-group">
                    <label for="email">البريد الإلكتروني</label>
                    <input id="email" type="email" name="email" value="{{ old('email') }}" required class="form-control" placeholder="example@email.com">
                </div>
            </div>

            <div class="form-group">
                <label for="admin_password">كلمة الإدارة السرية</label>
                <input id="admin_password" type="password" name="admin_password" class="form-control" placeholder="اختياري">
                <div class="hint-box">تُحدد هذه الكلمة من إعدادات البيئة للإنتاج. إذا ما عندك الكلمة من مالك النظام راح ينشأ الحساب كمستخدم عادي.</div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label for="password">كلمة المرور</label>
                    <input id="password" type="password" name="password" required minlength="8" class="form-control" placeholder="8 أحرف أو أكثر">
                </div>

                <div class="form-group">
                    <label for="password_confirmation">تأكيد كلمة المرور</label>
                    <input id="password_confirmation" type="password" name="password_confirmation" required class="form-control">
                </div>
            </div>

            <button type="submit" class="btn btn-success">
                <i class="fas fa-user-plus"></i>
                إنشاء الحساب
            </button>
        </form>

        <div class="inline-meta" style="margin-top: 1.5rem;">
            <a href="{{ route('login') }}" class="button-link btn-secondary btn-sm">لدي حساب بالفعل</a>
        </div>
    </section>
@endsection
