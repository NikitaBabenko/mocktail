# Mocktail — VibeNest deployment pilot

**NOT READY: full runtime acceptance is pending.**

[![Deploy to VibeNest — pilot, acceptance pending](https://img.shields.io/badge/Deploy_to_VibeNest-pilot_acceptance_pending-lightgrey)](https://vibenest.net/deploy?repo=https://github.com/NikitaBabenko/mocktail&branch=master)

This fork packages one Mocktail v4.1.0 server: the publisher's pinned Go binary
already embeds the web UI. The root Dockerfile copies that binary and adds a
startup guard; it does not compile Go or React. See [VIBENEST.md](VIBENEST.md)
for image provenance, required keys, persistent `/db`, and acceptance status.

## Complete upstream source

The full upstream tree at `9b57dc10878facd211a7fef75a962afc4dc3ed51` is preserved,
with every tracked file's original bytes and Git mode, under
[`upstream/source/`](upstream/source/). No source, tests, examples, or build
manifests were removed. Its original relative directory structure is intact.
Read the [upstream README](upstream/source/readme.md) for features and development.
The fork retains upstream Git history and the [MIT license](LICENSE).

For the original source build, use `upstream/source/` as the build context:
`docker build -f upstream/source/Dockerfile upstream/source`.
This is a separate, untested source-build option and requires appropriate build
resources. The VibeNest pilot uses only the root COPY-based Dockerfile.

The local guarded Compose companion is at `docker/vibenest/docker-compose.yml`;
its build context points back to the repository root. It is not the VibeNest path.

## Why this layout

VibeNest's preview treated the upstream UI/API/MCP development folders as
separate deployable services, then sent the button through a new-group wizard.
This deployment-adapter layout presents the actual single embedded-UI server at
the root while retaining the complete upstream tree for inspection. Security
scanning must still inspect all source recursively; this layout grants no
clearance and changes no platform limits or gates.

The original layout preserved repository/branch through existing-user login, but
could not reuse the prepared single-service draft. This revised layout still
requires a fresh real button-path test. No public demo, Free-tier runtime fit,
authentication acceptance, or SQLite persistence is claimed yet.
