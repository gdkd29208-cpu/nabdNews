@extends('layouts.app')

@section('title', 'نشر خبر جديد - نبض نيوز')

@section('content')
    <section class="editor-card">
        <div class="section-heading">
            <div>
                <h1 class="page-title">نشر خبر جديد</h1>
                <p class="muted-text">أدخل العنوان والمحتوى والفئة بشكل واضح حتى يظهر الخبر بصورة احترافية.</p>
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

        <form method="POST" action="{{ route('news.store') }}" enctype="multipart/form-data" class="stack">
            @csrf

            <div class="form-grid">
                <div class="form-group">
                    <label for="title">عنوان الخبر</label>
                    <input id="title" type="text" name="title" value="{{ old('title') }}" required maxlength="255" class="form-control" placeholder="عنوان واضح ومباشر">
                </div>

                <div class="form-group">
                    <label for="category">الفئة</label>
                    <select id="category" name="category" required class="form-control">
                        <option value="">اختر الفئة</option>
                        @foreach($categories as $category)
                            <option value="{{ $category }}" @selected(old('category') === $category)>{{ $category }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="content">المحتوى</label>
                <textarea id="content" name="content" required class="form-control textarea-control" placeholder="اكتب تفاصيل الخبر هنا">{{ old('content') }}</textarea>
            </div>

            <div class="form-group">
                <label for="image">صورة الخبر</label>
                <input id="image" type="file" name="image" accept="image/*" class="form-control" data-max-size="5242880">
                <div class="hint-box">يُفضل رفع صورة واضحة بصيغة `JPG` أو `PNG` وبحجم أقل من 5 ميغابايت.</div>
            </div>

            <div class="hero-actions">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-paper-plane"></i>
                    نشر الخبر
                </button>
                <a href="{{ route('news.index') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-right"></i>
                    رجوع للأخبار
                </a>
            </div>
        </form>
    </section>
@endsection

@push('scripts')
<script>
    const createImageInput = document.getElementById('image');

    if (createImageInput) {
        createImageInput.addEventListener('change', () => {
            const file = createImageInput.files?.[0];
            const maxSize = Number(createImageInput.dataset.maxSize || 0);

            if (file && maxSize && file.size > maxSize) {
                alert('الصورة أكبر من 5 ميغابايت. اختر صورة أصغر حتى يكتمل رفع الخبر.');
                createImageInput.value = '';
            }
        });
    }
</script>
@endpush
