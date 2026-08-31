# VulnerableAppExamples

A test corpus for validating SAST, secret-scanning, and dependency-scanning tooling.

Each subproject is a small, self-contained application that contains a wide range of
common security weaknesses across the languages and platforms used across our
engineering estate. The corpus exists so we can point a scanner at a known set of
issues and confirm the tool actually detects them, measure coverage per language, and
compare tools against each other.

> **This is a deliberate security test corpus, not production software.**
> Every "secret" in this repository (passwords such as `exposedPassword`, API keys, and
> the `AKIAIOSFODNN7EXAMPLE` AWS example key) is a **fake placeholder value**. Nothing
> here is a real credential, and none of these apps are deployed or run. Do not treat any
> finding in this repo as a live leak, and do not reuse any of this code.

## Projects

| Project | Stack | Scanned primarily by |
|---|---|---|
| `BlazorVulnerableApp` | Blazor Server / C# (.NET 10) | CodeQL, Semgrep, DevSkim, Trivy, Gitleaks |
| `ReactCSharpVulnerableApp/Backend` | ASP.NET Core Web API / C# | CodeQL, Semgrep, DevSkim, Trivy, Gitleaks |
| `ReactCSharpVulnerableApp/Frontend` | React + TypeScript (Vite) | CodeQL, Semgrep, Dependabot, Gitleaks |
| `NodeVulnerableApp` | Node.js / Express (JavaScript) | CodeQL, Semgrep, Dependabot, Gitleaks |
| `VBNetVulnerableApp` | VB.NET (.NET 10) | DevSkim, Semgrep (generic), Gitleaks |
| `VB6VulnerableApp` | Classic Visual Basic 6 | Gitleaks, Trivy (secrets) |
| `OraclePLSQLVulnerable` | Oracle PL/SQL | Gitleaks, Semgrep (generic), Trivy (secrets) |
| `SQLServerVulnerable` | Microsoft T-SQL | Gitleaks, Semgrep (generic), Trivy (secrets) |
| `PowerShellVulnerable` | PowerShell | PSScriptAnalyzer, Gitleaks, DevSkim |

Weakness classes represented include SQL/OS/LDAP/PL-SQL injection, XSS, SSRF, path
traversal, XXE, insecure deserialization, weak and hardcoded cryptography, insecure
randomness, disabled TLS certificate validation, open redirect, missing authorization
and IDOR, verbose error disclosure, hardcoded credentials and secrets in settings files,
excessive database privileges, cleartext credential storage, and known-vulnerable
dependencies.

## Scanning

All scanners run from a single GitHub Actions workflow
([`.github/workflows/security-scan.yml`](.github/workflows/security-scan.yml)) and report
into one place — the repository **Security** tab — plus a consolidated email summary.
See [SECURITY-SCANNING.md](SECURITY-SCANNING.md) for the tooling, coverage matrix, and the
one-time email-notification setup.

## Building

The .NET projects compile with the .NET 10 SDK (`dotnet build`). The remaining projects
(VB6, Oracle PL/SQL, T-SQL, PowerShell) are source-only fixtures and are not compiled or
executed.
