@extends('layouts.app')

@section('title', 'الملف الشخصي - نبض نيوز')

@section('content')
    <section class="profile-layout">
        <div class="profile-card">
            <div class="avatar-circle">
                <i class="fas fa-user"></i>
            </div>
            <h2 class="page-title" style="text-align: center;">{{ $user->name }}</h2>
            <p class="muted-text" style="text-align: center;">{{ $user->email }}</p>

            <div class="stats-grid" style="margin-top: 1.5rem;">
                <div class="stat-card">
                    <strong>{{ $user->news->count() }}</strong>
                    <span>خبر منشور</span>
                </div>
            </div>

            <div class="stack">
                <a href="{{ route('news.create') }}" class="btn btn-success">
                    <i class="fas fa-plus"></i>
                    نشر خبر جديد
                </a>
                <a href="{{ route('news.index') }}" class="btn btn-secondary">
                    <i class="fas fa-list"></i>
                    إدارة الأخبار
                </a>
                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <button type="submit" class="btn btn-danger" style="width: 100%;" onclick="return confirm('هل أنت متأكد من تسجيل الخروج؟')">
                        <i class="fas fa-sign-out-alt"></i>
                        تسجيل خروج
                    </button>
                </form>
            </div>
        </div>

        <div class="stack">
            <div class="profile-form">
                <div class="section-heading">
                    <div>
                        <h3 class="page-title">تعديل البيانات</h3>
                        <p class="muted-text">حدّث اسمك أو بريدك أو كلمة المرور عند الحاجة.</p>
                    </div>
                </div>

                <form method="POST" action="{{ route('profile.update') }}" class="stack">
                    @csrf
                    @method('PATCH')

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">الاسم</label>
                            <input id="name" type="text" name="name" value="{{ old('name', $user->name) }}" required class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="email">البريد الإلكتروني</label>
                            <input id="email" type="email" name="email" value="{{ old('email', $user->email) }}" required class="form-control">
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="password">كلمة المرور الجديدة</label>
                            <input id="password" type="password" name="password" class="form-control" placeholder="اتركه فارغًا إذا لا تريد التغيير">
                        </div>

                        <div class="form-group">
                            <label for="password_confirmation">تأكيد كلمة المرور</label>
                            <input id="password_confirmation" type="password" name="password_confirmation" class="form-control">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        حفظ التغييرات
                    </button>
                </form>
            </div>

            <div class="surface-panel" style="padding: 2rem;">
                <div class="section-heading">
                    <div>
                        <h3 class="page-title">كروب الصحفيين</h3>
                        <p class="muted-text">أنشئ كروب خاص بالصحفيين وحدد له كلمة مرور من عندك، أو انضم لكروب موجود إذا عندك كلمة المرور.</p>
                    </div>
                </div>

                @if(!($groupsFeatureReady ?? false))
                    <div class="hint-box">
                        ميزة كروبات الصحفيين مضافة بالكود، لكن الجداول بعد ما متفعلة في قاعدة البيانات.
                        شغّل <code>php artisan migrate</code> وبعدها حدّث الصفحة.
                    </div>
                @else
                <div class="stack">
                    <form method="POST" action="{{ route('journalist-groups.store') }}" class="stack">
                        @csrf
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="group_name">اسم الكروب</label>
                                <input id="group_name" type="text" name="name" value="{{ old('name') }}" required class="form-control" placeholder="مثال: صحفيو بغداد">
                            </div>

                            <div class="form-group">
                                <label for="group_description">وصف الكروب</label>
                                <input id="group_description" type="text" name="description" value="{{ old('description') }}" class="form-control" placeholder="وصف بسيط للكروب">
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="group_password">كلمة مرور الكروب</label>
                                <input id="group_password" type="password" name="password" required minlength="6" class="form-control" placeholder="6 أحرف أو أكثر">
                            </div>

                            <div class="form-group">
                                <label for="group_password_confirmation">تأكيد كلمة المرور</label>
                                <input id="group_password_confirmation" type="password" name="password_confirmation" required class="form-control">
                            </div>
                        </div>

                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-users"></i>
                            إنشاء الكروب
                        </button>
                    </form>

                    <div class="hint-box">أي عضو يعرف كلمة المرور يگدر ينضم للكروب من داخل الملف الشخصي.</div>

                    <div class="profile-news-grid">
                        @forelse($availableGroups as $group)
                            <article class="profile-news-item">
                                <span class="source-badge">مالك الكروب: {{ $group->owner->name }}</span>
                                <h4 class="news-item-title">{{ $group->name }}</h4>
                                <p class="news-item-meta">{{ $group->description ?: 'بدون وصف إضافي.' }}</p>
                                <p class="news-item-meta">عدد الأعضاء: {{ $group->members->count() }}</p>

                                @php
                                    $isMember = $user->journalistGroups->contains('id', $group->id) || $user->ownedJournalistGroups->contains('id', $group->id);
                                @endphp

                                @if($isMember)
                                    <div class="hint-box">أنت داخل هذا الكروب بالفعل.</div>
                                @else
                                    <form method="POST" action="{{ route('journalist-groups.join') }}" class="stack">
                                        @csrf
                                        <input type="hidden" name="group_id" value="{{ $group->id }}">
                                        <div class="form-group">
                                            <label for="join_password_{{ $group->id }}">كلمة مرور الانضمام</label>
                                            <input id="join_password_{{ $group->id }}" type="password" name="password" required class="form-control" placeholder="أدخل كلمة مرور الكروب">
                                        </div>
                                        <button type="submit" class="btn btn-secondary btn-sm">
                                            <i class="fas fa-right-to-bracket"></i>
                                            دخول للكروب
                                        </button>
                                    </form>
                                @endif
                            </article>
                        @empty
                            <div class="empty-state">
                                <i class="fas fa-users"></i>
                                <h3>لا توجد كروبات صحفيين بعد</h3>
                                <p>أنشئ أول كروب من هذا القسم وسيظهر هنا مباشرة.</p>
                            </div>
                        @endforelse
                    </div>
                </div>
                @endif
            </div>

            <div class="surface-panel" style="padding: 2rem;">
                <div class="section-heading">
                    <div>
                        <h3 class="page-title">أخبارك المنشورة</h3>
                        <p class="muted-text">الوصول السريع إلى الأخبار التي كتبتها أو تعديلها.</p>
                    </div>
                </div>

                <div class="profile-news-grid">
                    @forelse($user->news as $news)
                        <article class="profile-news-item">
                            <span class="source-badge">{{ $news->category }}</span>
                            <h4 class="news-item-title">{{ \Illuminate\Support\Str::limit($news->title, 70) }}</h4>
                            <p class="news-item-meta">{{ $news->created_at->diffForHumans() }}</p>
                            <div class="inline-meta">
                                <a href="{{ route('news.show', $news) }}" class="btn btn-secondary btn-sm">عرض</a>
                                <a href="{{ route('news.edit', $news) }}" class="btn btn-primary btn-sm">تعديل</a>
                                <form method="POST" action="{{ route('news.destroy', $news) }}" onsubmit="return confirm('هل أنت متأكد من حذف هذا الخبر؟')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="btn btn-danger btn-sm">حذف</button>
                                </form>
                            </div>
                        </article>
                    @empty
                        <div class="empty-state">
                            <i class="fas fa-newspaper"></i>
                            <h3>لا توجد أخبار منشورة بعد</h3>
                            <p>ابدأ بكتابة أول خبر لك ليظهر هنا.</p>
                        </div>
                    @endforelse
                </div>
            </div>
        </div>
    </section>
@endsection
