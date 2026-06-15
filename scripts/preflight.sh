#!/usr/bin/env bash
# Preflight dependency self-check for the portfolio-to-issues skill.
# Prints what is present, what is missing, and how to install it.
# Exit 0 always: missing optional tools => degrade to manual mode, not a hard stop.

set -u
ok=0; warn=0

check () {
  local name="$1" probe="$2" required="$3" hint="$4"
  if eval "$probe" >/dev/null 2>&1; then
    echo "  [ok]   $name"
    ok=$((ok+1))
  else
    if [ "$required" = "required" ]; then
      echo "  [MISS] $name (REQUIRED) -> $hint"
    else
      echo "  [warn] $name (optional) -> $hint   [will run in manual mode]"
    fi
    warn=$((warn+1))
  fi
}

echo "portfolio-to-issues preflight:"
check "multica CLI"  "command -v multica"            "required" "this skill targets a Multica workspace; multica CLI must be on PATH"
check "gstack"       "command -v gstack || command -v \$B" "optional" "install the gstack plugin in your runtime (review/office-hours/ceo/eng skills)"
check "gsd"          "command -v gsd || ls .claude/skills 2>/dev/null | grep -qi gsd" "optional" "install the gsd plugin in your runtime (gsd-spec/plan/phase skills)"

echo ""
if command -v multica >/dev/null 2>&1; then
  if [ "$warn" -eq 0 ]; then
    echo "MODE: full (multica + gstack + gsd available)."
  else
    echo "MODE: manual fallback for missing optional tools."
    echo "      Stage 2 review: apply references/review-gauntlet.md dimensions inline."
    echo "      Stage 3 GSD:    write phases + verified-spec by hand from the spec."
  fi
else
  echo "BLOCKED: multica CLI missing. Install it before running this skill."
fi
exit 0
