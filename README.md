# Hisaab Rakho

Simple solution to track your finances.

## Private API integration

The client uses `https://hisaab-private-api.s-ammarahmed14.workers.dev`.
Sign-up and sign-in obtain a one-hour bearer session. Native clients store the
token in platform secure storage; web clients keep it in memory and require
sign-in after refreshing the page. Shared preferences contain profile fields,
never passwords or bearer tokens. Splash verifies `/auth/me` before opening the
dashboard. Expiry, unauthorized responses and sign-out clear the local profile,
transaction controllers and navigation history. Sign-out also revokes the
server session when the server can be reached.

Use **Recover account / forgot password** on the sign-in screen with the account's
email address. The API returns the same message for existing and unknown accounts;
the email link opens the API's password reset page. Imported accounts require
recovery before sign-in. Email delivery requires the separately configured server
SMTP relay; no email credentials belong in the Flutter app.

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release --base-href /
```

Publish `build/web` on the configured Netlify site. This is a client application;
financial data remains in the authenticated API's durable database. Native device
builds and platform secure-storage behavior still require device validation.

## Live web client and recovery email setup

The live client is https://hisaab-rakho-ammarsaa.netlify.app . Sign-up, sign-in,
and financial records use the private Worker API. Recovery delivery is pending
SMTP configuration; the Worker relay URL is intentionally disabled until setup
is complete. Recovery requests still return a generic message, so that response
does not confirm email delivery. Imported accounts remain locked until recovery.

1. In the Netlify site's **Project configuration → Environment variables**, add
   `SMTP_HOST`, `SMTP_PORT` (`465` for implicit TLS or `587` for STARTTLS),
   `SMTP_USER`, and `SMTP_PASS` with **Functions** scope in the production context.
   Use an SMTP/app password supplied by your mail provider. Optionally add
   `MAIL_FROM` as a plain verified sender email address; it defaults to
   `SMTP_USER`. Do not place these values in this repository or Flutter assets.
2. Preserve the existing `RECOVERY_RELAY_SECRET` on Netlify and the Worker.
   Its value must match on both services. Do not expose it to the web client.
3. Redeploy the Netlify site after environment configuration. The Node function
   at `/api/recovery-mail` uses Nodemailer; unsigned requests are rejected.
4. After SMTP configuration is ready, enable the Worker's `RECOVERY_RELAY_URL`
   as `https://hisaab-rakho-ammarsaa.netlify.app/api/recovery-mail` and redeploy
   the Worker. Keep this URL disabled until SMTP is configured.
5. Request recovery only for an account/email you own and verify delivery,
   password reset, and sign-in. The reset link expires after 30 minutes and can
   be used once; resetting revokes existing sessions.

The relay checks a SHA-256 HMAC of the timestamp and exact request body, accepts
timestamps within five minutes, and sends only links to the canonical Worker
reset page. Sender and subject are fixed by the server. Logs and client bundles
must not contain SMTP passwords, shared secrets, or reset tokens.

```sh
npm ci
npm run test:relay
```

## Demo Video

https://github.com/user-attachments/assets/af2995bd-ab17-4caa-89d4-3a46d8532e2b

