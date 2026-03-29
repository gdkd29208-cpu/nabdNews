@extends('layouts.app')

@section('title', 'جلب الأخبار - نبض نيوز')

@section('content')
    <section class="surface-panel" style="padding: 2rem;">
        <div class="section-heading">
            <div>
                <h1 class="page-title">جلب الأخبار العالمية</h1>
                <p class="muted-text">استخدم هذه الصفحة لملء الموقع بسرعة بأخبار خارجية محفوظة داخل قاعدة البيانات.</p>
            </div>
        </div>

        <div class="stack" style="max-width: 52rem; margin: 0 auto;">
            <button id="fetch-news-btn" class="btn btn-success" type="button">
                <i class="fas fa-download"></i>
                جلب أخبار جديدة
            </button>

            <div id="fetch-status"></div>
            <div id="fetched-news-list" class="stack"></div>
        </div>
    </section>

@push('scripts')
<script src="{{ asset('news-api.js') }}"></script>
@endpush
@endsection
