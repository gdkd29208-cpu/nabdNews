@extends('layouts.app')

@section('title', 'الرئيسية - نبض نيوز')

@section('content')
    <section class="hero">
        <div class="hero-content">
            <span class="eyebrow">
                <i class="fas fa-bolt"></i>
                منصة أخبار مرتبة وسريعة
            </span>
            <h1 class="hero-title">واجهة أخبار أوضح وتجربة نشر أسهل.</h1>
            <p class="hero-subtitle">
                تابع آخر الأخبار المحلية والعالمية، وانشر محتواك ضمن تصميم منظم يركز على السرعة والوضوح.
            </p>
            <div class="hero-actions">
                @auth
                    <a href="{{ route('news.create') }}" class="btn btn-success">
                        <i class="fas fa-plus-circle"></i>
                        نشر خبر الآن
                    </a>
                @else
                    <a href="{{ route('register') }}" class="btn btn-success">
                        <i class="fas fa-user-plus"></i>
                        ابدأ بحساب جديد
                    </a>
                @endauth

                <a href="{{ route('news.index') }}" class="btn btn-secondary">
                    <i class="fas fa-list"></i>
                    تصفح كل الأخبار
                </a>

                <a href="{{ route('news.fetch') }}" class="btn btn-secondary">
                    <i class="fas fa-globe"></i>
                    جلب الأخبار العالمية
                </a>
            </div>
        </div>
    </section>

    <section class="surface-panel" style="padding: 2rem; margin-bottom: 2rem;">
        <div class="section-heading">
            <div>
                <h2>الأخبار العالمية الحديثة</h2>
                <p class="muted-text">آخر الأخبار التي تم جلبها تلقائيًا من المصادر الخارجية وتخزينها داخل الموقع.</p>
            </div>
            <a href="{{ route('news.fetch') }}" class="btn btn-secondary btn-sm">
                <i class="fas fa-robot"></i>
                تشغيل الجلب
            </a>
        </div>

        <div class="preview-grid">
            @forelse($globalNews as $news)
                <article class="feature-card">
                    <span class="source-badge">
                        <i class="fas fa-globe"></i>
                        {{ $news->source ?? 'عالمي' }}
                    </span>
                    <span class="muted-text">{{ $news->category }}</span>
                    <h3 class="article-title">{{ \Illuminate\Support\Str::limit($news->title, 90) }}</h3>
                    <p class="article-excerpt">{{ \Illuminate\Support\Str::limit(strip_tags($news->content), 120) }}</p>
                    <div class="inline-meta">
                        <span class="meta-group">
                            <i class="fas fa-clock"></i>
                            {{ $news->created_at->diffForHumans() }}
                        </span>
                        <div class="inline-meta">
                            <a href="{{ route('news.show', $news) }}" class="button-link btn-secondary btn-sm">
                                عرض الخبر
                            </a>
                            @if($news->link)
                                <a href="{{ $news->link }}" class="button-link btn-secondary btn-sm" target="_blank" rel="noopener noreferrer">
                                    قراءة المصدر
                                </a>
                            @endif
                        </div>
                    </div>
                </article>
            @empty
                <div class="empty-state">
                    <i class="fas fa-globe"></i>
                    <h3>لا توجد أخبار عالمية بعد</h3>
                    <p>شغّل صفحة جلب الأخبار حتى يبدأ القسم يمتلئ بالمحتوى.</p>
                </div>
            @endforelse
        </div>
    </section>

    <section class="stack">
        <div class="section-heading">
            <div>
                <h2>أحدث الأخبار المنشورة</h2>
                <p class="muted-text">بطاقات أوضح، معلومات أساسية، ووصول مباشر للتفاصيل.</p>
            </div>
        </div>

        <div class="news-grid">
            @forelse($featuredNews as $news)
                <article class="article-card">
                    <a href="{{ route('news.show', $news) }}" class="article-media">
                        @if($news->image)
                            <img src="{{ $news->image_url }}" alt="{{ $news->title }}">
                        @else
                            <div class="article-media-placeholder">
                                <i class="fas fa-newspaper"></i>
                            </div>
                        @endif

                        @if($news->category)
                            <span class="category-badge">{{ $news->category }}</span>
                        @endif
                    </a>

                    <div class="stack" style="gap: 0.75rem;">
                        <h3 class="article-title">
                            <a href="{{ route('news.show', $news) }}" style="text-decoration: none;">
                                {{ \Illuminate\Support\Str::limit($news->title, 75) }}
                            </a>
                        </h3>
                        <p class="article-excerpt">{{ \Illuminate\Support\Str::limit(strip_tags($news->content), 140) }}</p>
                        <div class="article-meta">
                            <span class="meta-group">
                                <i class="fas fa-user-circle"></i>
                                {{ $news->user->name ?? 'غير معروف' }}
                            </span>
                            <span class="meta-group">
                                <i class="fas fa-clock"></i>
                                {{ $news->created_at->diffForHumans() }}
                            </span>
                        </div>
                    </div>
                </article>
            @empty
                <div class="empty-state">
                    <i class="fas fa-newspaper"></i>
                    <h3>لا توجد أخبار منشورة حتى الآن</h3>
                    <p>ابدأ بإضافة أول خبر محلي حتى يظهر هذا القسم بشكل كامل.</p>
                </div>
            @endforelse
        </div>
    </section>
@endsection
