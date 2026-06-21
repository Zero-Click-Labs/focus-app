# Universal Links hosting (`mindpower.zeroclicklabs.org`)

The app's NFC tags, QR codes, and widgets open `https://mindpower.zeroclicklabs.org/profile/<id>`
and `/navigate/<id>` links. For iOS to route those into the app (instead of Safari),
the **Apple App Site Association (AASA)** file in `.well-known/` must be hosted on that domain.

## Steps

1. Replace `TEAMID` in `.well-known/apple-app-site-association` with your 10-character
   Apple Developer Team ID (Apple Developer → Membership details). The full App ID must
   read `<TeamID>.org.zeroclicklabs.mindpower`.
2. Deploy the `.well-known/apple-app-site-association` file so it is reachable at:
   `https://mindpower.zeroclicklabs.org/.well-known/apple-app-site-association`
3. Serve it:
   - over **HTTPS** with a valid certificate,
   - with **no redirects**,
   - with `Content-Type: application/json`,
   - with **no file extension** on the file name.
4. The app side is already configured: `Foqos/foqos.entitlements` declares
   `applinks:mindpower.zeroclicklabs.org`.

## Verify

- Apple's CDN cache: `https://app-site-association.cdn-apple.com/a/v1/mindpower.zeroclicklabs.org`
- On device: delete and reinstall the app after the file is live (iOS fetches AASA at install time),
  then tap a `https://mindpower.zeroclicklabs.org/profile/...` link.

Until this is hosted, the `mindpower://` custom scheme still works as a fallback, but
`https://` Universal Links (tags/QR/widgets) will open Safari instead of the app.
