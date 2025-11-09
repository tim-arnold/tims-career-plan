#!/bin/bash

# Script to show current job application pipeline

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

# Color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Job Application Pipeline ===${NC}"
echo ""

# Get all JB issues - save to temp file to avoid shell variable issues
TEMP_FILE="/tmp/jira-pipeline-$$.json"
curl -s \
  -X POST \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  "https://tim52.atlassian.net/rest/api/3/search/jql" \
  -d '{"jql": "project=JB ORDER BY status ASC, created DESC", "fields": ["key", "summary", "status", "labels", "created"], "maxResults": 100}' \
  > "$TEMP_FILE"

if [ ! -s "$TEMP_FILE" ]; then
  echo "Error: No response from Jira API"
  rm -f "$TEMP_FILE"
  exit 1
fi

# Check for error in response
if grep -q "errorMessages" "$TEMP_FILE"; then
  echo "Error from Jira API:"
  cat "$TEMP_FILE"
  rm -f "$TEMP_FILE"
  exit 1
fi

python3 - "$TEMP_FILE" << 'PYEOF'
import sys, json
from datetime import datetime

try:
    with open(sys.argv[1], 'r') as f:
        data = json.load(f)
except (json.JSONDecodeError, FileNotFoundError, IndexError) as e:
    print(f"Failed to read JSON response: {e}")
    sys.exit(1)
issues = data.get('issues', [])

if not issues:
    print('No applications found. Create your first one with:')
    print('  ./scripts/create-job-application.sh')
    sys.exit(0)

# Group by status
by_status = {}
for issue in issues:
    status = issue['fields']['status']['name']
    if status not in by_status:
        by_status[status] = []
    by_status[status].append(issue)

# Define desired order (will show others at the end)
status_order = ['Backlog', 'Research', 'To Do', 'Ready to Apply', 'Applied',
                'Screening', 'Interviewing', 'Offer', 'Offer Received',
                'Accepted', 'Rejected', 'Withdrawn', 'Closed']

# Print by status
total = 0
for status in status_order:
    if status in by_status:
        issues_in_status = by_status[status]
        total += len(issues_in_status)

        # Color code by status type
        if status in ['Accepted']:
            color = '\033[0;32m'  # Green
        elif status in ['Rejected', 'Withdrawn', 'Closed']:
            color = '\033[0;31m'  # Red
        elif status in ['Interviewing', 'Offer', 'Offer Received']:
            color = '\033[1;33m'  # Yellow
        else:
            color = '\033[0;34m'  # Blue

        print(f"{color}▸ {status} ({len(issues_in_status)})\033[0m")

        for issue in issues_in_status:
            key = issue['key']
            summary = issue['fields']['summary']
            labels = issue['fields'].get('labels', [])
            created = issue['fields']['created'][:10]

            priority = ''
            if 'tier-1' in labels:
                priority = ' 🔥'
            elif 'tier-3' in labels:
                priority = ' ⬇️'

            print(f"  {key}: {summary[:50]}{priority}")
        print()

# Show any statuses not in our ordered list
for status, issues_in_status in by_status.items():
    if status not in status_order:
        total += len(issues_in_status)
        print(f"▸ {status} ({len(issues_in_status)})")
        for issue in issues_in_status:
            key = issue['key']
            summary = issue['fields']['summary']
            print(f"  {key}: {summary[:50]}")
        print()

print(f"Total applications: {total}")

# Calculate some stats
active = sum(len(issues) for status, issues in by_status.items()
             if status not in ['Accepted', 'Rejected', 'Withdrawn', 'Closed'])
print(f"Active applications: {active}")

if 'Interviewing' in by_status or 'Offer' in by_status or 'Offer Received' in by_status:
    hot = sum(len(by_status.get(s, [])) for s in ['Interviewing', 'Offer', 'Offer Received'])
    print(f"🔥 Hot opportunities: {hot}")

PYEOF

# Clean up temp file
rm -f "$TEMP_FILE"
