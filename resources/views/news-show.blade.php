@extends('layouts.app')

@section('title', $news->title . ' - نبض نيوز')

@section('content')
    <article class="surface-panel" style="padding: 2rem;">
        <div class="stack">
            <div class="section-heading">
                <div>
                    @if($news->category)
                        <span class="source-badge">{{ $news->category }}</span>
                    @endif
                    <h1 class="page-title" style="margin-top: 1rem;">{{ $news->title }}</h1>
                    <div class="inline-meta" style="margin-top: 1rem;">
                        <span class="meta-group">
                            <i class="fas fa-user-circle"></i>
                            {{ $news->user->name ?? 'غير معروف' }}
                        </span>
                        <span class="meta-group">
                            <i class="fas fa-clock"></i>
                            {{ $news->created_at->diffForHumans() }}
                        </span>
                        @if($news->source)
                            <span class="meta-group">
                                <i class="fas fa-globe"></i>
                                {{ $news->source }}
                            </span>
                        @endif
                    </div>
                </div>
            </div>

            @if($news->image)
                <div class="article-media" style="min-height: 22rem;">
                    <img src="{{ $news->image_url }}" alt="{{ $news->title }}">
                </div>
            @endif

            <div class="surface-panel" style="padding: 1.5rem; background: rgba(255,255,255,0.7);">
                <p style="white-space: pre-line; margin: 0;">{{ $news->content }}</p>
            </div>

            <div class="hero-actions">
                <a href="{{ route('news.index') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-right"></i>
                    العودة للقائمة
                </a>
                @auth
                    @if(auth()->id() === $news->user_id || auth()->user()?->is_admin)
                        <a href="{{ route('news.edit', $news) }}" class="btn btn-primary">
                            <i class="fas fa-pen"></i>
                            تعديل الخبر
                        </a>
                    @endif
                @endauth
                @if($news->link)
                    <a href="{{ $news->link }}" class="btn btn-success" target="_blank" rel="noopener noreferrer">
                        <i class="fas fa-up-right-from-square"></i>
                        فتح المصدر
                    </a>
                @endif
            </div>
        </div>
    </article>
@endsection
