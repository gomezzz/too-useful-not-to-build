#!/usr/bin/env bash
# One-off repository setup: settings, topics and labels. Needs gh authenticated
# with admin rights on the repo. Safe to re-run (labels are upserted).
set -euo pipefail

REPO="gomezzz/too-useful-not-to-build"

gh repo edit "$REPO" \
  --enable-issues \
  --enable-wiki=false \
  --enable-projects=false \
  --description "Why don't we just...? Software the space & AI community always wanted and can now afford to build. Open an issue with your idea, vote with 👍." \
  --add-topic spaice --add-topic open-science --add-topic llm \
  --add-topic space --add-topic astronomy --add-topic ideas

# Remove GitHub's default labels that do not fit an idea board (duplicate stays).
for label in bug documentation enhancement "good first issue" "help wanted" invalid question wontfix; do
  if gh label list -R "$REPO" --limit 200 --json name -q '.[].name' | grep -Fxq "$label"; then
    gh label delete "$label" -R "$REPO" --yes
  fi
done

upsert() { gh label create "$1" -R "$REPO" --color "$2" --description "$3" --force; }

upsert "idea"               "E8955C" "A why-don't-we-just idea"

upsert "cat: rescue"         "D9733B" "Port, test or document legacy code"
upsert "cat: infrastructure" "E8955C" "Benchmarks, loaders, converters, simulators"
upsert "cat: teaching"       "F2B48A" "Interactive papers, tutorials, outreach"
upsert "cat: bridges"        "C25E2A" "A tool another field already has"
upsert "cat: moonshots"      "A24A1E" "Research nobody could staff before"

upsert "astronomy"           "1E2E52" "Domain"
upsert "earth observation"   "2C4A7A" "Domain"
upsert "planetary"           "3A5F9E" "Domain"
upsert "heliophysics"        "4A72B8" "Domain"
upsert "onboard"             "5B86CC" "Domain: onboard and edge computing"
upsert "mission ops"         "6F98D6" "Domain: mission operations"
upsert "education"           "88AEE0" "Domain: education and outreach"
upsert "cross-domain"        "A6C3EA" "Domain: spans several fields"

upsert "needs champion"      "BFC8D9" "Looking for someone to lead it"
upsert "has champion"        "2E8B57" "Someone has said they'll lead it"
upsert "in progress"         "1F6F43" "Work has started"
upsert "exists already"      "8C97AD" "Something suitable already exists; see comments"

echo "Done. Issues: https://github.com/$REPO/issues/new/choose"
