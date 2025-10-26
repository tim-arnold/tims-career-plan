#!/bin/bash

# Script to update a job application's status

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Update Job Application Status ===${NC}"
echo ""

# Get issue key
read -p "Issue Key (e.g., JB-1): " ISSUE_KEY

if [ -z "$ISSUE_KEY" ]; then
    echo "Error: Issue key is required"
    exit 1
fi

# Get available transitions
echo "Getting available statuses for $ISSUE_KEY..."

TRANSITIONS=$(curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/issue/$ISSUE_KEY/transitions")

echo "$TRANSITIONS" | python3 -c "
import sys, json
data = json.load(sys.stdin)
transitions = data.get('transitions', [])

if not transitions:
    print('No transitions available or issue not found.')
    sys.exit(1)

print('Available statuses:')
print()
for i, trans in enumerate(transitions, 1):
    print(f'{i}. {trans[\"to\"][\"name\"]}')

print()
" > /tmp/jb_transitions.txt

cat /tmp/jb_transitions.txt

if ! grep -q "Available statuses:" /tmp/jb_transitions.txt; then
    exit 1
fi

# Get user choice
read -p "Select status number: " CHOICE

# Get the transition ID
TRANSITION_ID=$(echo "$TRANSITIONS" | python3 -c "
import sys, json
choice = int('$CHOICE')
data = json.load(sys.stdin)
transitions = data.get('transitions', [])
if 0 < choice <= len(transitions):
    print(transitions[choice-1]['id'])
else:
    print('')
")

if [ -z "$TRANSITION_ID" ]; then
    echo "Invalid choice"
    exit 1
fi

# Make the transition
echo "Updating status..."

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  "https://tim52.atlassian.net/rest/api/3/issue/$ISSUE_KEY/transitions" \
  -d "{
    \"transition\": {
      \"id\": \"$TRANSITION_ID\"
    }
  }")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

if [ "$HTTP_CODE" -eq 204 ]; then
    echo -e "${GREEN}✓ Status updated successfully!${NC}"
    echo ""
    echo "View at: https://tim52.atlassian.net/browse/$ISSUE_KEY"
else
    echo "✗ Failed to update status (HTTP $HTTP_CODE)"
    BODY=$(echo "$RESPONSE" | sed '$d')
    echo "$BODY"
fi
