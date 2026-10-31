# Mocktail on VibeNest — pilot, not yet accepted

This fork retains Mocktail v4.1.0 and its MIT license. It packages the publisher's
linux/amd64 binary with a small startup guard. No Go/React source has been changed.
Free-tier runtime, login handoff, persistence, and resource use are **not verified**.
There is no public demo yet. Do not treat this as an accepted one-click deployment.

## Intended entry point

```text
https://vibenest.net/deploy?repo=https://github.com/NikitaBabenko/mocktail&branch=master
```

The README badge remains inactive until the full path is accepted. The platform
entry point must preserve this repository and `master` through preview and login.
An existing-user login does not demonstrate new-user registration.

For this controlled acceptance, first create a blank project through the normal
dashboard with no repository, then save this repository and `master` in Settings.
This establishes an exact project ID without creating an application, claiming
hardware, or dispatching a deployment. Check that ID's current `IsBlocked` and
`SafetyHoldId` before any launch-capable action. Only after a runtime slot is
assigned and the draft is safely configured may the button/login path reuse it.
Record this honestly as a clean, prepared-draft reuse, not a virgin one-click launch.
If the live UI differs, stop before an action that could automatically dispatch.

## Guided setup, before the first launch

Use one HTTP service: repository root, branch `master`, build pack `dockerfile`,
root `Dockerfile`, internal port **6625**, persistent volume mounted at **/db**.
Do not deploy the UI/API folders as separate services. The binary includes the UI.
Use the normal VibeNest project settings and gated deployment actions.

The inspected platform revision `26261cb5fcaec1b05781560ca5ccda529e38979d`
supports stable generated secrets in Render manifests, but explicitly rejects
`disk` with `render_persistent_disk_unsupported`. A `render.yaml` cannot currently
declare the complete required storage contract for this app. This fork therefore
uses guided storage/secret setup instead of claiming automatic setup. Attaching a
volume can itself trigger deployment; treat it as a launch-capable action and
perform all project/security/slot checks first.

Set two distinct randomly generated secret environment variables, each at least
32 characters: `MOCKTAIL_ADMIN_KEY` and `MOCKTAIL_API_KEY`. Keep these stable across
redeploys. Do not use `auto`, `0`, sample values, query parameters, or command-line
arguments. The wrapper exits before serving HTTP if either key is missing, short,
or identical to the other. Verify both secrets and storage before pressing Deploy;
do not intentionally trigger repeated startup failures to discover settings.

The wrapper fixes `MOCKTAIL_DB_PATH=/db/apis.db`, `MOCKTAIL_PORT=6625`,
`MOCKTAIL_LOG_BUFFER_MB=8`, `MOCKTAIL_LOG_BODY_KB=8`, `GOMEMLIMIT=160MiB`, and
`GOMAXPROCS=1`. Go's memory setting is a soft limit, and the log budget approximates
retained entries; neither proves that the process fits 256 MiB. Leave all AI keys
and AI gateway overrides unset; the wrapper rejects them. Optional AI settings use
ephemeral `/tmp/mocktail-config`, separate from `/db`. Verify AI reports
`configured: false`; do not add provider keys or call AI features.

The image is pinned for **linux/amd64**. It uses COPY and metadata instructions
only; it does not compile dependencies. Original build/Compose files remain under
`docker/upstream/`, with repository root as their build context. Never use those
source builds on a constrained host without a separately approved build slot.

## Image provenance checked 2026-10-31

- Upstream master and tag `v4.1.0`: `9b57dc10878facd211a7fef75a962afc4dc3ed51`.
- Publisher index: `sha256:c177942bc000d8eb113f8fe19e479984d948c3a840c1c9e78470f5c2c7d3f5ea`.
- Pinned amd64 manifest: `sha256:5e201870d5e2f22687ba41fb55a1219d3af80e393a611402e2038f5f6d3cbd6a`.
- `/app` SHA-256: `4793c3decee2f5c8e49c9757b4cbaebc1e067570bc0790c548240e3f0d7465db` (27,332,770 bytes).
- Parsed Go build info: Go 1.26.10, linux/amd64, CGO disabled; dependency versions
  match the current source. Build info has no embedded VCS revision. The source
  association comes from the publisher's registry provenance and successful
  [tag workflow](https://github.com/Huseyinnurbaki/mocktail/actions/runs/40066079341),
  not from an independent reproducible build or verified signature.
- Wrapper base: official Alpine 3.23.7 amd64,
  `sha256:3d67941fed5ae436b2bb9791cb3f50a252441c7706bbc5b4e738936df8ff8306`.

The binary was inspected as data, never executed during static preparation.
This evidence does not replace VibeNest's normal security gate.

## Acceptance recipe (pending a runtime slot)

1. Follow the intended entry point anonymously and verify repo/branch after login.
   Record clean environment/volume setup separately from any reuse.
2. Confirm both keys, /db storage, assigned Free hardware and allowed project state
   before the normal gated launch. Record the exact fork SHA and deployed image.
3. Open the public HTTPS dashboard and enter the management key in its passcode
   prompt. Static assets and `/health` are public; management is protected.
4. Check missing and forged keys receive 401 for `/core/v1/apis`, `/core/v1/logs`,
   and `/core/v1/logs/{id}`. Check missing/forged mock API keys also receive 401.
5. Create `GET /pilot-get` with status 200, body `{"ok":true}`, and header
   `X-Pilot: mocktail`; create `POST /pilot-post` with status 201 and body
   `{"created":true}`. Keep delay 0 and randomization off.
6. Use a client sending `X-API-Key` to `/mocktail/pilot-get` and
   `/mocktail/pilot-post`; send only inert synthetic content. Confirm exact status,
   JSON, response header, and the POST payload in the dashboard Live view.
   The upstream dashboard's built-in Test does **not** propagate the mock API key
   and will return 401 with this configuration. External keyed requests are needed.
7. Record startup, idle and peak memory, actual RAM/CPU cgroups, CPU use, disk,
   OOM events and restarts. Make only a few sequential small requests; no load test.
8. Through normal gated restart/redeploy, confirm the same SQLite mocks and the
   same secret environment still work. Live request history is in-memory and is
   expected to reset; it is not persisted in SQLite.
9. Stop only the assigned temporary pilot using normal platform actions, preserve
   its data/evidence, and release the shared test slot.

Mocktail redacts its own two key headers in request logs, but intentionally retains
client Authorization/Cookie headers and bodies. Never send real client secrets or
personal data in this pilot. No arbitrary outbound-fetch feature was found in the
fixed-mock path; AI can make server-side HTTP calls when configured and is excluded.

Fork Actions are disabled. No build, tests executing application code, or runtime
acceptance has been run for this packaging change.
