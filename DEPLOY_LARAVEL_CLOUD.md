# Nabd News Deployment Guide

هذا المشروع مجهز للنشر على Laravel Cloud.

## قبل الرفع

1. ارفع المشروع إلى GitHub.
2. تأكد أن ملف [.env.example](./.env.example) موجود ومحدث.
3. استخدم الفرع الرئيسي مثل `main`.

## إنشاء التطبيق

1. افتح [Laravel Cloud Quickstart](https://cloud.laravel.com/docs/quickstart).
2. أنشئ `New application`.
3. اربط GitHub واختر هذا الريبو.
4. اختر Region قريب.

## إعدادات البيئة

أضف أو راجع هذه القيم في Laravel Cloud:

```env
APP_NAME="Nabd News"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-app-domain.laravel.cloud
APP_LOCALE=ar
APP_FALLBACK_LOCALE=ar
DB_CONNECTION=mysql
SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database
FILESYSTEM_DISK=public
ADMIN_REGISTRATION_SECRET=choose-a-long-random-secret
```

إذا أضفت Object Storage اجعل `FILESYSTEM_DISK` هو القرص الذي يحقنه Laravel Cloud تلقائيًا.

## قاعدة البيانات

1. من لوحة Laravel Cloud أضف MySQL database.
2. اربطها بالبيئة.
3. Laravel Cloud سيحقن متغيرات `DB_*` تلقائيًا عند الربط.

## أوامر Build و Deploy

بحسب [Laravel Cloud Deployments](https://cloud.laravel.com/docs/deployments)، Cloud يشغّل أوامر build/deploy التي تضبطها للبيئة.

### Build Command

```bash
composer install --no-interaction --prefer-dist --optimize-autoloader
npm ci
npm run build
php artisan config:clear
php artisan event:cache
php artisan route:cache
php artisan view:cache
```

### Deploy Command

```bash
php artisan migrate --force
php artisan optimize
```

## الملفات المرفوعة والصور

المشروع الآن يستخدم `config('filesystems.default')` لحفظ صور الأخبار. هذا مهم لأن Laravel Cloud يوصي باستخدام Object Storage للملفات، ويمكن ربط bucket من [Object Storage docs](https://cloud.laravel.com/docs/resources/object-storage).

إذا تريد صور المستخدمين تبقى محفوظة بعد كل deploy:

1. أضف Bucket من لوحة Laravel Cloud.
2. اربطه بالبيئة.
3. اختره كـ default disk أو اضبط `FILESYSTEM_DISK` على اسم القرص.
4. أعد النشر.

ملاحظة: وثائق Laravel Cloud تذكر أن Object Storage يحتاج دعم S3-compatible، والمشروع يملك الاعتماد المطلوب داخل `composer.lock`.

## بعد أول Deploy

نفّذ التحقق التالي:

1. افتح الصفحة الرئيسية.
2. سجّل حساب جديد.
3. أنشئ خبر مع صورة.
4. جرّب `/news-fetch`.
5. افتح `/profile` وتأكد أن كروب الصحفيين يعمل.

## دومين مخصص

بعد نجاح النشر، أضف دومين من إعدادات التطبيق داخل Cloud عبر صفحة [Domains](https://cloud.laravel.com/docs/domains).

## ملاحظات مهمة

1. لا ترفع ملف `.env` الحقيقي إلى GitHub.
2. استخدم قيمة قوية لمتغير `ADMIN_REGISTRATION_SECRET` بدل أي كلمة بسيطة.
3. يفضل لاحقًا نقل البريد من `log` إلى مزود فعلي.
4. راجع [SECURITY_REVIEW.md](./SECURITY_REVIEW.md) قبل الإطلاق.
