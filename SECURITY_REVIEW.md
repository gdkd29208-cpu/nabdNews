# Security Review (Quick)

تاريخ المراجعة: 2026-03-29

## Findings Applied

1. Removed hardcoded admin secret from code.
   - الحالة: Fixed
   - التفاصيل: registration now checks `ADMIN_REGISTRATION_SECRET` from env/config instead of fixed `admin123`.

2. Added rate limiting on sensitive endpoints.
   - الحالة: Fixed
   - التفاصيل:
     - `POST /login` => `throttle:8,1`
     - `POST /register` => `throttle:5,1`
     - `POST /journalist-groups` => `throttle:10,1`
     - `POST /journalist-groups/join` => `throttle:10,1`
     - `POST /news/scrape` => `throttle:15,1`

3. Restricted scraping endpoints to authenticated users.
   - الحالة: Fixed
   - التفاصيل:
     - `/news-fetch` and `/news/scrape` now inside `auth` middleware.

4. Production baseline env documented.
   - الحالة: Fixed
   - التفاصيل: see `PRODUCTION_ENV.md` and `.env.example`.

## Remaining Recommendations

1. Rotate any leaked secrets immediately (DB, APP_KEY, mail).
2. Replace registration-based admin escalation with invite-only flow for stronger control.
3. Add security headers at the web server / CDN layer (HSTS, CSP, X-Frame-Options).
4. Add audit logs for admin-sensitive actions (news delete/edit, group membership changes).
5. Move mail from `log` to real SMTP provider before public launch.
