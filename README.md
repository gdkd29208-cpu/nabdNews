# نبض نيوز - Nabd News

منصة أخبار مبنية بـ Laravel 12 لعرض الأخبار المنشورة محليًا والأخبار العالمية المسحوبة، مع حسابات مستخدمين، ملف شخصي، وكروب صحفيين.

## التشغيل المحلي

```bash
composer install
npm install
copy .env.example .env
php artisan key:generate
php artisan migrate
npm run build
php artisan serve
```

## الصفحات الأساسية

- `/` الرئيسية
- `/news-list` جميع الأخبار
- `/news-fetch` جلب الأخبار العالمية
- `/profile` الملف الشخصي وكروب الصحفيين

## النشر

تم تجهيز المشروع للنشر على Laravel Cloud.

راجع الملف:
- [DEPLOY_LARAVEL_CLOUD.md](./DEPLOY_LARAVEL_CLOUD.md)
- [PRODUCTION_ENV.md](./PRODUCTION_ENV.md)
- [SECURITY_REVIEW.md](./SECURITY_REVIEW.md)

## ملاحظات

- صور الأخبار تستخدم القرص الافتراضي من `FILESYSTEM_DISK`.
- إذا ستنشر المشروع بشكل عام، غيّر كلمة الإدارة الثابتة داخل التسجيل.
