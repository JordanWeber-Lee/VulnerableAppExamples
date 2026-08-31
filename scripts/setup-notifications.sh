#!/usr/bin/env bash
# One-time setup for the consolidated security-scan email notifications.
# Requires the GitHub CLI (`gh`) authenticated against this repository.
#
# Usage: fill in the values below and run:  bash scripts/setup-notifications.sh
set -euo pipefail

MAIL_SERVER="smtp.office365.com"     # SMTP host (e.g. smtp.sendgrid.net)
MAIL_PORT="587"                       # 587 (STARTTLS) or 465 (SSL)
MAIL_USERNAME="security-scans@lee.net"  # SMTP auth user (e.g. "apikey" for SendGrid)
MAIL_PASSWORD=""                      # app password / API key  <-- set this
MAIL_FROM="security-scans@lee.net"    # From address
NOTIFY_EMAIL="Jordan.Weber@lee.net"   # recipient

if [[ -z "$MAIL_PASSWORD" ]]; then
  echo "Set MAIL_PASSWORD in this script before running." >&2
  exit 1
fi

gh secret set MAIL_SERVER   --body "$MAIL_SERVER"
gh secret set MAIL_PORT     --body "$MAIL_PORT"
gh secret set MAIL_USERNAME --body "$MAIL_USERNAME"
gh secret set MAIL_PASSWORD --body "$MAIL_PASSWORD"
gh secret set MAIL_FROM     --body "$MAIL_FROM"
gh variable set NOTIFY_EMAIL --body "$NOTIFY_EMAIL"

echo "Notification secrets configured. The next Security Scan run will email $NOTIFY_EMAIL."
