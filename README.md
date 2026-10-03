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

## Demo Video

https://github.com/user-attachments/assets/af2995bd-ab17-4caa-89d4-3a46d8532e2b

