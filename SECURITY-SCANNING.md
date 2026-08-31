# Security scanning setup

Every scanner is orchestrated by one workflow,
[`.github/workflows/security-scan.yml`](.github/workflows/security-scan.yml), and all
findings land in **one central place**: the repository **Security** tab
(`Security → Code scanning` / `Secret scanning` / `Dependabot`). A final `notify` job
sends a single consolidated email summarizing the open-alert counts with links back to
those views.

All of the tools below are **free for public repositories** — no paid licences and no
per-scan cost. The only recurring cost is GitHub Actions minutes, which are unlimited for
public repos.

## Tools and coverage

| Tool | Type | Languages it covers here | Cost |
|---|---|---|---|
| **CodeQL** (`github/codeql-action`) | SAST | C#, JavaScript/TypeScript | Free (public repos) |
| **Semgrep OSS** (`semgrep/semgrep`) | SAST | C#, JS/TS, plus generic rules over SQL/PL-SQL/others | Free (OSS rule packs) |
| **DevSkim** (`microsoft/DevSkim-Action`) | SAST | C#, VB, JS, PowerShell, and more | Free |
| **PSScriptAnalyzer** (`+ ConvertToSARIF`) | Linter/SAST | PowerShell | Free |
| **Gitleaks** (`gitleaks/gitleaks-action`) | Secret scanning | All file types | Free (public repos) |
| **Trivy** (`aquasecurity/trivy-action`) | Secrets + misconfig + deps | All + dependency manifests | Free |
| **GitHub secret scanning** | Secret scanning | All file types | Free (auto-on for public repos) |
| **Dependabot** | Dependency scanning | NuGet + npm manifests | Free |

CodeQL does not support VB6, VB.NET, PL/SQL, T-SQL, or PowerShell — those languages are
covered by the secret scanners (Gitleaks/Trivy/GitHub), Semgrep's generic rules, DevSkim
(VB/PowerShell), and PSScriptAnalyzer (PowerShell). This split is intentional so we can
see each tool's real coverage boundary.

## When it runs

- On every push and pull request to `main`
- Weekly (Monday 06:00 UTC) on a schedule
- On demand via **Actions → Security Scan → Run workflow**

## Central email notifications — one-time setup

The `notify` job emails a consolidated summary to `Jordan.Weber@lee.net`. It only sends
once SMTP credentials are provided as repository secrets; until then it logs the alert
counts to the workflow run and sends nothing (the scans still work and still populate the
Security tab).

GitHub Actions cannot send mail on its own, so an SMTP relay is required. Provide these
**repository secrets** (Settings → Secrets and variables → Actions), or run
[`scripts/setup-notifications.sh`](scripts/setup-notifications.sh):

| Secret | Example | Notes |
|---|---|---|
| `MAIL_SERVER` | `smtp.office365.com` / `smtp.sendgrid.net` | SMTP host of an account allowed to relay externally |
| `MAIL_PORT` | `587` | 587 (STARTTLS) or 465 (SSL) |
| `MAIL_USERNAME` | service account / `apikey` | SMTP auth user |
| `MAIL_PASSWORD` | app password / API key | store as a secret only |
| `MAIL_FROM` | `security-scans@lee.net` | From address |

Optional **repository variable** `NOTIFY_EMAIL` overrides the recipient (defaults to
`Jordan.Weber@lee.net`).

```bash
# from the repo root, authenticated with gh
gh secret set MAIL_SERVER   --body "smtp.office365.com"
gh secret set MAIL_PORT     --body "587"
gh secret set MAIL_USERNAME --body "security-scans@lee.net"
gh secret set MAIL_PASSWORD --body "<app-password-or-api-key>"
gh secret set MAIL_FROM     --body "security-scans@lee.net"
# optional: change the recipient
gh variable set NOTIFY_EMAIL --body "Jordan.Weber@lee.net"
```

> Corporate Exchange often blocks unauthenticated external relay from GitHub-hosted
> runners. A free SendGrid/Mailgun account (use `apikey` as the username and the API key
> as the password) or an authenticated M365 mailbox with an app password is the reliable
> path.

### Alternative: GitHub-native email (no SMTP)

GitHub already emails security alerts to anyone **watching** the repo with the right
notification settings. To route those to `Jordan.Weber@lee.net` without any workflow:

1. Add and verify `Jordan.Weber@lee.net` on the GitHub account
   (Settings → Emails), then under Settings → Notifications set custom routing for this
   repo to that address.
2. Watch the repo → **Custom** → enable **Security alerts**.

The SMTP `notify` job is the more reliable "central place," because it fires regardless of
per-user watch settings and puts all three alert categories in one message.
