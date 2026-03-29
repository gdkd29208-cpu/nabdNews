@extends('layouts.app')

@section('title', 'نبض نيوز - بوابة الأخبار')

@section('content')
<div class="welcome-hero" style="background: white; padding: 4rem 3rem; border-radius: 24px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); text-align: center; margin-bottom: 3rem;">
    <div style="font-size: 4rem; background: linear-gradient(135deg, #3b82f6, #1d4ed8); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 1.5rem;">
        <i class="fas fa-newspaper"></i>
    </div>
    <h1 style="font-size: 3rem; font-weight: 800; margin-bottom: 1.5rem; color: #1e293b;">مرحباً بك في نبض نيوز</h1>
    <p style="font-size: 1.3rem; color: #64748b; margin-bottom: 3rem; max-width: 600px; margin-left: auto; margin-right: auto;">
        أسرع بوابة أخبار مستقلة تغطي كل ما يهمك من حول العالم بأسلوب بسيط وموثوق.
    </p>
    <div style="display: flex; gap: 1.5rem; justify-content: center; flex-wrap: wrap;">
        @auth
            <a href="/news-create" style="padding: 1.2rem 3rem; background: linear-gradient(135deg, #10b981, #059669); color: white; text-decoration: none; border-radius: 12px; font-weight: 700; font-size: 1.1rem; box-shadow: 0 10px 30px rgba(16,185,129,0.3);">
                <i class="fas fa-plus"></i> نشر خبر
            </a>
            <a href="/profile" style="padding: 1.2rem 3rem; background: white; color: #3b82f6; text-decoration: none; border-radius: 12px; font-weight: 700; font-size: 1.1rem; border: 2px solid #3b82f6; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
                <i class="fas fa-user"></i> الملف الشخصي
            </a>
        @else
            <a href="/register" style="padding: 1.2rem 3rem; background: linear-gradient(135deg, #3b82f6, #1d4ed8); color: white; text-decoration: none; border-radius: 12px; font-weight: 700; font-size: 1.1rem; box-shadow: 0 10px 30px rgba(59,130,246,0.3);">
                <i class="fas fa-user-plus"></i> إنشاء حساب
            </a>
            <a href="/login" style="padding: 1.2rem 3rem; background: white; color: #3b82f6; text-decoration: none; border-radius: 12px; font-weight: 700; font-size: 1.1rem; border: 2px solid #3b82f6;">
                <i class="fas fa-sign-in-alt"></i> تسجيل الدخول
            </a>
        @endauth
    </div>
</div>

<!-- أحدث الأخبار -->
<div class="latest-news" style="background: white; padding: 3rem; border-radius: 24px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); margin-bottom: 3rem;">
    <h2 style="font-size: 2rem; margin-bottom: 2rem; color: #1e293b; text-align: center;">أحدث الأخبار</h2>
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem;">
        @php $latestNews = \App\Models\News::latest()->take(6)->get(); @endphp
        @forelse($latestNews as $news)
            <div style="border: 2px solid #e2e8f0; border-radius: 16px; padding: 1.5rem; transition: all 0.3s;">
                <span style="background: #10b981; color: white; padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; margin-bottom: 1rem; display: inline-block;">{{ $news->category }}</span>
                <h3 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 0.5rem; color: #1e293b;">{{ Str::limit($news->title, 60) }}</h3>
                <p style="color: #64748b; margin-bottom: 1rem;">{{ Str::limit(strip_tags($news->content), 100) }}</p>
                <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; color: #64748b;">
                    <span><i class="fas fa-user"></i> {{ $news->user->name ?? 'غير معروف' }}</span>
                    <span>{{ $news->created_at->diffForHumans() }}</span>
                </div>
            </div>
        @empty
            <div style="grid-column: 1 / -1; text-align: center; padding: 3rem; color: #64748b;">
                <i class="fas fa-newspaper" style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.5;"></i>
                <p>لا توجد أخبار بعد. كن الأول!</p>
            </div>
        @endforelse
    </div>
    <div style="text-align: center; margin-top: 2rem;">
        <a href="/news" style="padding: 1rem 2.5rem; background: linear-gradient(135deg, #3b82f6, #1d4ed8); color: white; text-decoration: none; border-radius: 12px; font-weight: 700;">عرض جميع الأخبار</a>
    </div>
</div>
@endsection
