@extends('layouts.app')

@section('title', 'تعديل الخبر - نبض نيوز')

@section('content')
    <section class="editor-card">
        <div class="section-heading">
            <div>
                <h1 class="page-title">تعديل الخبر</h1>
                <p class="muted-text">حدّث العنوان أو المحتوى أو الفئة، وسيتم حفظ التغييرات مباشرة.</p>
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

        <form method="POST" action="{{ route('news.update', $news) }}" enctype="multipart/form-data" class="stack">
            @csrf
            @method('PUT')

            <div class="form-grid">
                <div class="form-group">
                    <label for="title">عنوان الخبر</label>
                    <input id="title" type="text" name="title" value="{{ old('title', $news->title) }}" required maxlength="255" class="form-control">
                </div>

                <div class="form-group">
                    <label for="category">الفئة</label>
                    <select id="category" name="category" required class="form-control">
                        @foreach($categories as $category)
                            <option value="{{ $category }}" @selected(old('category', $news->category) === $category)>{{ $category }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="content">المحتوى</label>
                <textarea id="content" name="content" required class="form-control textarea-control">{{ old('content', $news->content) }}</textarea>
            </div>

            <div class="form-group">
                <label for="image">تحديث الصورة</label>
                <input id="image" type="file" name="image" accept="image/*" class="form-control" data-max-size="5242880">
                <div class="hint-box">الحد المسموح للصورة هو 5 ميغابايت.</div>
            </div>

            <div class="hero-actions">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    حفظ التغييرات
                </button>
                <a href="{{ route('news.show', $news) }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-right"></i>
                    رجوع للتفاصيل
                </a>
            </div>
        </form>
    </section>
@endsection

@push('scripts')
<script>
    const editImageInput = document.getElementById('image');

    if (editImageInput) {
        editImageInput.addEventListener('change', () => {
            const file = editImageInput.files?.[0];
            const maxSize = Number(editImageInput.dataset.maxSize || 0);

            if (file && maxSize && file.size > maxSize) {
                alert('الصورة أكبر من 5 ميغابايت. اختر صورة أصغر حتى يكتمل التحديث.');
                editImageInput.value = '';
            }
        });
    }
</script>
@endpush
