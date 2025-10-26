#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

echo "=== Setting up Job Board Workflow ==="
echo ""

# First, get the project details to find the workflow
echo "1. Getting project configuration..."
PROJECT_DATA=$(curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/project/JB")

echo "Project: $(echo $PROJECT_DATA | python3 -c 'import sys, json; data=json.load(sys.stdin); print(data.get("name", ""))')"

# Get available statuses
echo ""
echo "2. Getting available statuses in your Jira instance..."
STATUSES=$(curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/status")

echo "$STATUSES" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(f\"{'ID':<10} {'NAME':<30} CATEGORY\")
print('-' * 70)
for status in data:
    sid = status.get('id', '')
    name = status.get('name', '')
    cat = status.get('statusCategory', {}).get('name', '')
    print(f'{sid:<10} {name:<30} {cat}')
" > /tmp/jb_statuses.txt

cat /tmp/jb_statuses.txt

# Define the statuses we need for Option 2
echo ""
echo "3. Statuses needed for Option 2 workflow:"
echo "   - Backlog (To Do)"
echo "   - Ready to Apply (To Do)"
echo "   - Applied (In Progress)"
echo "   - Screening (In Progress)"
echo "   - Interviewing (In Progress)"
echo "   - Offer Received (In Progress)"
echo "   - Closed (Done)"
echo ""

# Check which statuses already exist
echo "4. Checking which statuses need to be created..."
python3 << 'PYEOF'
import json

with open('/tmp/jb_statuses.txt', 'r') as f:
    content = f.read()

# Parse existing statuses
existing = []
for line in content.split('\n'):
    if line and not line.startswith('ID') and not line.startswith('-'):
        parts = line.split()
        if len(parts) >= 2:
            name = ' '.join(parts[1:-1])
            existing.append(name.lower())

needed = ['Backlog', 'Ready to Apply', 'Applied', 'Screening', 'Interviewing', 'Offer Received', 'Closed', 'Rejected', 'Withdrawn']

print("Status check:")
for status in needed:
    exists = status.lower() in existing or status.lower().replace(' ', '') in [e.replace(' ', '') for e in existing]
    marker = "✓" if exists else "✗"
    print(f"  {marker} {status}")

PYEOF

echo ""
echo "Note: In team-managed projects, you can add statuses directly through the board configuration."
echo "This is simpler than creating them via API for company-managed projects."
echo ""
echo "Next, we'll update the board column configuration..."
