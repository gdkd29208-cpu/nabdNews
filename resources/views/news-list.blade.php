@extends('layouts.app')

@section('title', 'جميع الأخبار - نبض نيوز')

@section('content')
    <section class="surface-panel" style="padding: 2rem;">
        <div class="section-heading">
            <div>
                <h1 class="page-title">جميع الأخبار</h1>
                <p class="muted-text">استعرض الأخبار حسب الفئة، وتابع آخر ما تم نشره داخل المنصة.</p>
            </div>
            @auth
                <a href="{{ route('news.create') }}" class="btn btn-primary">
                    <i class="fas fa-plus-circle"></i>
                    إضافة خبر
                </a>
            @endauth
        </div>

        <div class="filters">
            <a href="{{ route('news.index') }}" class="filter-chip {{ $selectedCategory === '' ? 'active' : '' }}">الكل</a>
            @foreach($categories as $category)
                <a href="{{ route('news.index', ['category' => $category]) }}" class="filter-chip {{ $selectedCategory === $category ? 'active' : '' }}">
                    {{ $category }}
                </a>
            @endforeach
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <strong>{{ $news->total() }}</strong>
                <span>الأخبار ضمن النتيجة الحالية</span>
            </div>
            @foreach($categories as $category)
                <div class="stat-card">
                    <strong>{{ $stats[$category] ?? 0 }}</strong>
                    <span>{{ $category }}</span>
                </div>
            @endforeach
        </div>

        <div class="news-grid">
            @forelse ($news as $article)
                <article class="list-card">
                    <a href="{{ route('news.show', $article) }}" class="list-card-media">
                        @if($article->image)
                            <img src="{{ $article->image_url }}" alt="{{ $article->title }}">
                        @else
                            <div class="list-card-placeholder">
                                <i class="fas fa-image"></i>
                            </div>
                        @endif

                        @if($article->category)
                            <span class="category-badge">{{ $article->category }}</span>
                        @endif
                    </a>

                    <div class="stack" style="gap: 0.8rem;">
                        <h2 class="list-card-title">
                            <a href="{{ route('news.show', $article) }}" style="text-decoration: none;">
                                {{ \Illuminate\Support\Str::limit($article->title, 80) }}
                            </a>
                        </h2>
                        <p class="list-card-excerpt">{{ \Illuminate\Support\Str::limit(strip_tags($article->content), 140) }}</p>
                        <div class="list-card-meta">
                            <span class="meta-group">
                                <i class="fas fa-user-circle"></i>
                                {{ $article->user->name ?? 'غير معروف' }}
                            </span>
                            <span class="meta-group">
                                <i class="fas fa-clock"></i>
                                {{ $article->created_at->diffForHumans() }}
                            </span>
                        </div>
                        <div class="inline-meta">
                            <a href="{{ route('news.show', $article) }}" class="btn btn-secondary btn-sm">
                                قراءة التفاصيل
                            </a>
                            @auth
                                @if(auth()->id() === $article->user_id || auth()->user()?->is_admin)
                                    <div class="inline-meta">
                                        <a href="{{ route('news.edit', $article) }}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-pen"></i>
                                            تعديل
                                        </a>
                                        <form method="POST" action="{{ route('news.destroy', $article) }}" onsubmit="return confirm('هل أنت متأكد من حذف هذا الخبر؟')">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i>
                                                حذف
                                            </button>
                                        </form>
                                    </div>
                                @endif
                            @endauth
                        </div>
                    </div>
                </article>
            @empty
                <div class="empty-state">
                    <i class="fas fa-newspaper"></i>
                    <h2>لا توجد أخبار لهذه الفئة</h2>
                    <p>جرّب تغيير الفلتر أو أضف خبرًا جديدًا.</p>
                </div>
            @endforelse
        </div>

        @if($news->hasPages())
            <div class="pagination-shell">
                @if($news->onFirstPage())
                    <span class="pagination-link">السابق</span>
                @else
                    <a href="{{ $news->previousPageUrl() }}" class="pagination-link">السابق</a>
                @endif

                @foreach ($news->getUrlRange(1, $news->lastPage()) as $page => $url)
                    <a href="{{ $url }}" class="pagination-link {{ $page === $news->currentPage() ? 'active' : '' }}">{{ $page }}</a>
                @endforeach

                @if($news->hasMorePages())
                    <a href="{{ $news->nextPageUrl() }}" class="pagination-link">التالي</a>
                @else
                    <span class="pagination-link">التالي</span>
                @endif
            </div>
        @endif
    </section>
@endsection
