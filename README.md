# duplicati-railway

Wrapper image for [Duplicati](https://github.com/duplicati/duplicati) (2.4.1.0 stable) on [Railway](https://railway.com).

Upstream listens on `DUPLICATI__WEBSERVICE_PORT=8200` instead of Railway's injected `PORT`, answers sign-in with 403 from any Host
header outside its allowlist (a Railway domain is outside it), and without secrets starts with no password and an unencrypted
settings database. The wrapper refuses to start without `DUPLICATI__WEBSERVICE_PASSWORD` (at least 8 characters) and
`SETTINGS_ENCRYPTION_KEY`, listens on `PORT`, and allows any Host header.

- Variables: `DUPLICATI__WEBSERVICE_PASSWORD` and `SETTINGS_ENCRYPTION_KEY` (both required). Optional: `DUPLICATI__WEBSERVICE_ALLOWED_HOSTNAMES` (default `*`), `TZ`, any other `DUPLICATI__*` setting.
- Volume: `/data` (settings database in `/data/Duplicati`, `/data/backups` for local destinations, `/data/source` for local sources)
- Health: `GET /health`

Published as `ghcr.io/bon5co/duplicati-railway`. Template: see the Railway marketplace listing.
