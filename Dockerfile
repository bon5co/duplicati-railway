# Duplicati wrapper for Railway. Upstream listens on the DUPLICATI__WEBSERVICE_PORT=8200 baked into the image ENV and ignores Railway's
# PORT, refuses sign-in (403) from any Host outside its allowlist, so a public Railway domain cannot log in until
# DUPLICATI__WEBSERVICE_ALLOWED_HOSTNAMES is set, and starts with no password and an unencrypted settings database when neither secret
# is set. The wrapper refuses to start without both secrets, listens on PORT, allows any Host, and keeps everything under /data.
# upstream: duplicati/duplicati
FROM duplicati/duplicati:2.4.1.0@sha256:5df64d95abd79ddaa41897a6c234c956d6de03df767a1b8eb8c5baecf3162bbf

COPY --chmod=0755 boot.sh /railway-boot.sh

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", "/railway-boot.sh"]
CMD ["duplicati-server"]
