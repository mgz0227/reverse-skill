# reverse-skill final installation summary

- Completed: 2026-08-14 05:58:11 +08:00
- Repository: `C:\Users\miaogongzi\Documents\GitHub\reverse-skill`
- Branch: `main`
- Final commit: `d53d790353bf7ad309babad0c04ce58deff9dad3`
- Remote: `origin/main` matches final commit
- Worktree: clean
- Security posture: conditional pass; unsafe/manual integrations remain disabled

## Outcome

- Codex router adapter installed in place. The repository was not copied into the global skill directory.
- Capability index: 19 of 24 listed capabilities ready.
- Added Codex MCP definitions: `reqable-mcp`, `jshook`, `pentestswarm`, `anything-analyzer`.
- Anything Analyzer MCP verified with an authenticated JSON-RPC initialize request: HTTP 200, session ID present, server info present. The same request without a token returned HTTP 401.
- Anything Analyzer binds only `127.0.0.1:23816`; authentication is enabled. Token values are intentionally omitted from all reports.
- ProxyCat dependencies are isolated in its own Python virtual environment. ProxyCat is installed but not running; port 1080 is closed.
- GhidraMCP is not deployed; port 8080 is closed.
- Codex configuration backup exists before the first MCP mutation.

## Ready capabilities

`adb`, `agent-browser`, `anything-analyzer`, `apktool`, `binwalk`, `bkcrack`, `frida`, `frida-ps`, `jadx`, `jshookmcp`, `nmap`, `pentestswarm`, `proxycat`, `pwntools`, `r2`, `rabin2`, `reqable-mcp`, `seclists`, `yara`.

## Not ready by design

- `jeb-pro`: commercial/manual installation required.
- `idalib-mcp` and `idapro`: Python integration package is installed, but no licensed IDA Pro runtime was found.
- `burpsuite-mcp`: manual Burp installation is required; the bundled extension build path failed the supply-chain gate and was not run.
- `ghidra-mcp`: blocked. Release 1.4 targets Ghidra 11.3.2, while the installed Ghidra is 12.1.2. The unsigned plugin binds all interfaces, has no authentication, and exposes write operations.
- `seclists`: usable but incomplete. Sixteen tracked EICAR/WebShell payload files are missing, likely due to endpoint security controls; no quarantine record was available to prove the cause. They were not restored or allowlisted.

## Security scan decisions

- Initial repository/router install: conditional pass.
- `refresh-tool-index.ps1`: low risk and executed.
- Windows bootstrap: executed only with explicit capabilities and `-McpHostTarget Codex`; no Claude configuration was changed.
- Anything Analyzer: installed from commit `0ed4791688e5186da051c85eb7ddfe4639e14fd2`; configured for loopback plus bearer-token authentication. CA/proxy features were not enabled.
- ProxyCat: installed from commit `2309b713e2e4f574df14c2ace7e8fa6c00eb6941`; service was not enabled because upstream defaults can bind broadly and log credentials.
- Binwalk: installed with Cargo from exact commit `4fdab3d464d97b68e0af9088df3f9e2e1545b21c` and `--locked`, not from the movable unsigned `v3.1.0` tag.
- GhidraMCP release ZIP hash matched the audited release, but deployment was blocked by compatibility and network/authentication findings.
- Burp build was not executed because its wrapper/dependency verification did not pass the supply-chain gate.

## Validation

- Routing regression: 163/163 pass.
- Routing coherence and supply-chain pin gate: pass.
- Smoke: verify exit 0, 11 scripts parsed, 9/9 routes pass, 0 failures.
- Codex config regression: UTF-8 Chinese path preserved, no BOM, MCP block valid, no unsupported `type` field.
- `codex --strict-config doctor`: configuration loaded, 0 failures. The recorded full run reports only optional environment/reachability notes.
- Tool versions: Binwalk 3.1.0; YARA 4.5.5; Go 1.26.5; Rust/Cargo 1.97.1 toolchain; Nmap 7.80.
- Final repository `HEAD` equals `origin/main`; worktree clean.

## Repository commits pushed directly

- `1c2841c` docs: record Codex skill installation audit
- `30610a0` fix: handle single-directory release archives
- `ec20b85` fix: isolate Electron service launch environment
- `4663f47` fix: preserve Electron native module ABI
- `7738c17` fix: write loopback MCP config without BOM
- `d53d790` fix: preserve Codex config encoding

## Operational note

A command-resolution check accidentally invoked `proxycat.bat` once, briefly opening `0.0.0.0:1080`. The exact process was terminated immediately and the port was verified closed. No target traffic or external scan was initiated.

## Raw log index

- Security report: `2026-08-14_skill-install-security-report.md`
- Case review: `case-review.md`
- Initial/resumed bootstrap: `passive-install.log`, `passive-install-resume.log`, `archive-retry.log`
- Anything Analyzer attempts and success: `anything-analyzer-install.log`, `anything-analyzer-retry.log`, `anything-analyzer-abi-repair.log`, `anything-analyzer-final.log`, `anything-analyzer-success.log`, `anything-analyzer-runtime.log`, `anything-analyzer-runtime.err.log`
- Binwalk: `binwalk-security-audit.log`, `binwalk-install.log`
- ProxyCat: `proxycat-install.log`
- GhidraMCP audit: `ghidra-plugin-install.log`
- Codex: `codex-config-write-regression.log`, `codex-doctor.log`
- Final tests: `final-routing-summary.txt`, `final-coherence.log`, `final-smoke.log`, `final-tool-index-refresh.log`
- File inventory: `final-file-change-list.csv`
