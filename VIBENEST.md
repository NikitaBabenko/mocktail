# Mocktail on VibeNest — controlled pilot, Free acceptance blocked

This fork preserves all 162 upstream tracked files and their original bytes and
Git modes under `upstream/source/`, plus the MIT license and Git history. The root
Dockerfile packages the publisher's pinned embedded-UI binary with a startup guard.
No Go/React source was changed. Fork Actions are disabled; no CI run was triggered.

[Deploy to VibeNest — pilot only](https://vibenest.net/deploy?repo=https://github.com/NikitaBabenko/mocktail&branch=master)

## Acceptance observed 2026-10-31

Tested fork revision: `6031d73a0809919da31b1044a300a97049c85502`.
Platform revision: `26261cb5fcaec1b05781560ca5ccda529e38979d`.

- Real README button → anonymous preview → existing-user login → normal gated
  launch passed, preserving the repository and `master`. **New-user registration
  was not tested.** This reused a clean, manually prepared project with two stable
  secret keys and a `/db` volume; it was not an unattended first installation.
- Public HTTPS dashboard, protected management/API access, GET 200 `{"ok":true}`,
  POST 201 `{"created":true}`, custom `X-Pilot: mocktail` response header, and
  synthetic POST payload inspection in Live passed. Missing and forged keys were
  rejected. AI was unconfigured and no AI provider calls were made.
- Both mock definitions and their original IDs survived a native owner operation
  that replaced the application container. The same keys still worked, and the
  original SQLite named volume remained mounted at `/db`.
- The app alone had an actual 256 MiB RAM/swap cap and 25,000/100,000 CPU quota
  (0.25 host CPU, equivalent to the assigned 0.5 platform CPU on this host).
  Initial functional cgroup memory peak was 5,898,240 bytes; process RSS/HWM was
  22,776 KiB. After replacement, peak was 5,234,688 bytes and RSS/HWM 22,200 KiB.
  These are short, sequential synthetic checks, not load capacity estimates.
  OOM events and restart count were zero. Writable layer was 8,192 bytes and
  root filesystem 36,483,072 bytes; the persistent volume is separate.

**The overall initial Free deployment did not pass.** VibeNest detected an
indirect MySQL driver in upstream `go.mod` and automatically provisioned a second,
unneeded MySQL service. It had no RAM/CPU cap and used about 430 MiB. The app's
256 MiB cap therefore did not bound the whole deployment. This database contained
no user tables/routines/events/triggers and was removed with the normal owner
Detach workflow; SQLite data was retained and verified afterward.

The project still has the platform's cached MySQL requirement. The inspected
existing-project UI/API has no supported opt-out or way to adopt a repository
manifest when its previous manifest binding is absent. A normal future deploy
can recreate the extra database. Adding a manifest alone would not repair this
existing project. No SQL override, dependency deletion, cloned project, or gate
bypass was used. **Do not describe this as an accepted one-click Free deployment
or an outreach-ready integration.** The temporary acceptance app is not a
maintained public demo and is stopped after verification.

## Guided preparation used in the test

A blank draft was created through normal settings. Two different keys were saved
and `/db` was configured before launch. Since volume attachment itself can trigger
a deploy, its save was performed with the repository temporarily blank; the normal
dispatcher declined before provider/hardware work. The exact repository and branch
were then restored, and the real README button reused this prepared draft. This
manual setup is part of the evidence, not an automatic storage claim.

The old layout at `cc9499e9e5c66a38ee58f210ea6b817ce745491c` entered a new-group
wizard with separate UI/API/MCP candidates. No group was launched there. Moving
the complete, byte-preserved upstream tree under `upstream/source/` resolved that
routing issue at `6031d73`; all security-candidate source files remained visible
to recursive scanning. No source/test/example was removed to satisfy a gate.

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
only; it does not compile dependencies. All original build/Compose/source files remain under
`upstream/source/`, which is their unchanged original build context. Never use those
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

## Operational limitations

The current v4.1.0 dashboard's Copy URL/host display hardcodes localhost. Although
upstream documentation advertises `MOCKTAIL_BASE_URL`, setting it did not correct
those controls in this tested build. Use the actual HTTPS host plus
`/mocktail/pilot-get` or `/mocktail/pilot-post` in an external client.
The built-in Test does not propagate `X-API-Key`, so it returns 401 with this
configuration; external keyed requests work.

Use `X-Admin-Key` only for management and `X-API-Key` for mock requests. Do not
place keys in query strings. Mocktail redacts these two headers in request logs,
but retains arbitrary client Authorization/Cookie headers and bodies. This pilot
used only synthetic data. Live history is in memory and resets on container
replacement; the mock definitions are persisted in SQLite.

The empty MySQL cleanup did not invoke a paid backup. The inspected platform's
managed-database backup adapter sends an empty POST to the provider's scheduled
configuration endpoint; that is not a verified immediate-backup contract. Do not
use this empty-test-resource cleanup as a procedure for deleting a database with
data. Preserve data and use a verified backup/recovery path for real databases.
