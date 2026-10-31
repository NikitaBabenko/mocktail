# VibeNest pilot: packaging only, no RUN instruction or source compilation.
# Upstream v4.1.0 / 9b57dc10878facd211a7fef75a962afc4dc3ed51, linux/amd64.
# Original source build: docker/upstream/Dockerfile with repository root context.
FROM hhaluk/mocktail@sha256:5e201870d5e2f22687ba41fb55a1219d3af80e393a611402e2038f5f6d3cbd6a AS upstream
FROM alpine@sha256:3d67941fed5ae436b2bb9791cb3f50a252441c7706bbc5b4e738936df8ff8306

COPY --from=upstream /app /app
COPY docker/vibenest/entrypoint.sh /entrypoint.sh
COPY LICENSE /usr/share/licenses/mocktail/LICENSE

ENV MOCKTAIL_DB_PATH=/db/apis.db MOCKTAIL_PORT=6625 \
    MOCKTAIL_LOG_BUFFER_MB=8 MOCKTAIL_LOG_BODY_KB=8 \
    GOMEMLIMIT=160MiB GOMAXPROCS=1
EXPOSE 6625
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
CMD []
