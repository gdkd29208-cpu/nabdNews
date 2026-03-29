# Production Environment Variables

هذا الملف يوضح إعدادات `env` النهائية المقترحة للإنتاج.

## Required

```env
APP_NAME="Nabd News"
APP_ENV=production
APP_KEY=base64:...
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_CONNECTION=mysql
DB_HOST=...
DB_PORT=3306
DB_DATABASE=...
DB_USERNAME=...
DB_PASSWORD=...

SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database
```

## Strongly Recommended

```env
APP_LOCALE=ar
APP_FALLBACK_LOCALE=ar
LOG_LEVEL=warning
SESSION_SECURE_COOKIE=true
SESSION_SAME_SITE=lax
```

## Admin Registration Secret

```env
ADMIN_REGISTRATION_SECRET=choose-a-long-random-secret
```

هذا المتغير يستبدل أي كلمة ثابتة داخل الكود. لا تشارك القيمة علنًا ولا ترفعها إلى Git.

## File Storage

### Local-like disk (basic)

```env
FILESYSTEM_DISK=public
```

### Object Storage (recommended on Laravel Cloud)

```env
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=auto
AWS_BUCKET=...
AWS_ENDPOINT=...
AWS_URL=...
AWS_USE_PATH_STYLE_ENDPOINT=false
```

## Optional Mail Provider

```env
MAIL_MAILER=smtp
MAIL_HOST=...
MAIL_PORT=587
MAIL_USERNAME=...
MAIL_PASSWORD=...
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=no-reply@your-domain.com
MAIL_FROM_NAME="${APP_NAME}"
```
