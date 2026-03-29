<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="description" content="نبض نيوز - بوابة أخبار مستقلة تغطي كل ما يهمك">
    <meta name="keywords" content="أخبار, سياسة, رياضة, اقتصاد, تكنولوجيا">
    <meta name="author" content="نبض نيوز">
    <title>@yield('title', 'نبض نيوز - بوابة الأخبار المستقلة')</title>
    <link rel="icon" type="image/x-icon" href="{{ asset('favicon.ico') }}">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @stack('styles')
    @yield('styles')
</head>
<body>
    <div class="site-shell">
    <header class="site-header">
        <div class="container">
            <nav class="nav-bar">
                <a href="{{ route('home') }}" class="brand">
                    <span class="brand-badge">
                        <i class="fas fa-bolt"></i>
                    </span>
                    نبض نيوز
                </a>

                <button class="mobile-menu-btn" id="mobileMenuBtn" type="button" aria-label="القائمة">
                    <i class="fas fa-bars"></i>
                </button>

                <ul class="nav-links" id="navLinks">
                    <li><a href="{{ route('home') }}" class="nav-link {{ request()->routeIs('home') ? 'is-active' : '' }}">الرئيسية</a></li>
                    <li><a href="{{ route('news.index') }}" class="nav-link {{ request()->routeIs('news.index', 'news.show') ? 'is-active' : '' }}">الأخبار</a></li>
                    <li><a href="{{ route('news.fetch') }}" class="nav-link {{ request()->routeIs('news.fetch') ? 'is-active' : '' }}">جلب الأخبار</a></li>
                    <li><a href="{{ route('social') }}" class="nav-link {{ request()->routeIs('social') ? 'is-active' : '' }}">وسائل التواصل</a></li>
                </ul>

                <div class="nav-actions">
                    @auth
                        <a href="{{ route('news.create') }}" class="btn btn-secondary">
                            <i class="fas fa-plus-circle"></i>
                            نشر خبر
                        </a>
                        <a href="{{ route('profile') }}" class="btn btn-primary">
                            <i class="fas fa-user"></i>
                            الملف الشخصي
                        </a>
                    @else
                        <a href="{{ route('login') }}" class="btn btn-secondary">
                            <i class="fas fa-sign-in-alt"></i>
                            دخول
                        </a>
                        <a href="{{ route('register') }}" class="btn btn-primary">
                            <i class="fas fa-user-plus"></i>
                            إنشاء حساب
                        </a>
                    @endauth
                </div>

                <div class="social-links">
                    <a href="#" aria-label="فيسبوك" class="social-link" title="فيسبوك">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" aria-label="تويتر" class="social-link" title="X">
                        <i class="fab fa-x-twitter"></i>
                    </a>
                    <a href="#" aria-label="إنستجرام" class="social-link" title="إنستجرام">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" aria-label="يوتيوب" class="social-link" title="يوتيوب">
                        <i class="fab fa-youtube"></i>
                    </a>
                    <a href="#" aria-label="تليجرام" class="social-link" title="تليجرام">
                        <i class="fab fa-telegram"></i>
                    </a>
                </div>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <div class="container">
            @if (session('success'))
                <div class="flash-message success">
                    <i class="fas fa-check-circle"></i>
                    {{ session('success') }}
                </div>
            @endif

            @if (session('error'))
                <div class="flash-message error">
                    <i class="fas fa-exclamation-triangle"></i>
                    {{ session('error') }}
                </div>
            @endif

            @yield('content')
        </div>
    </main>

    <footer class="footer">
        <div class="container">
            <div class="footer-inner">
                <div class="footer-brand">
                    <i class="fas fa-newspaper"></i>
                    <span>نبض نيوز - بوابة الأخبار المستقلة</span>
                </div>
                <p>تغطية سريعة، واجهة أوضح، وتجربة استخدام أفضل.</p>
            </div>
            <p>&copy; جميع الحقوق محفوظة | أدهم أحمد</p>
        </div>
    </footer>
    </div>

    @stack('scripts')
    @yield('scripts')

    <script>
        const mobileBtn = document.getElementById('mobileMenuBtn');
        const navLinks = document.getElementById('navLinks');

        if (mobileBtn && navLinks) {
            mobileBtn.addEventListener('click', () => {
                navLinks.classList.toggle('active');
                const icon = mobileBtn.querySelector('i');
                icon.classList.toggle('fa-bars');
                icon.classList.toggle('fa-times');
            });
        }
    </script>
</body>
</html>
