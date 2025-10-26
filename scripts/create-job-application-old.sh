#!/bin/bash

# Script to quickly create a new job application in Jira

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Create New Job Application ===${NC}"
echo ""

# Prompt for details
read -p "Company Name: " COMPANY
read -p "Job Title: " JOB_TITLE
read -p "Job URL: " JOB_URL
read -p "Salary Range (optional): " SALARY
read -p "Priority (1-3, where 1=top): " PRIORITY

# Create summary
SUMMARY="$COMPANY - $JOB_TITLE"

# Create description
DESCRIPTION="*Company:* $COMPANY
*Position:* $JOB_TITLE
*Job URL:* $JOB_URL
*Salary Range:* ${SALARY:-TBD}
*Priority Tier:* ${PRIORITY:-2}

---
*Application Timeline*
- Added: $(date +%Y-%m-%d)

---
*Notes*
"

# Set priority label
case $PRIORITY in
  1) PRIORITY_LABEL="tier-1" ;;
  2) PRIORITY_LABEL="tier-2" ;;
  3) PRIORITY_LABEL="tier-3" ;;
  *) PRIORITY_LABEL="tier-2" ;;
esac

# Create the issue
echo ""
echo "Creating issue in Jira..."

RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  "https://tim52.atlassian.net/rest/api/3/issue" \
  -d "{
    \"fields\": {
      \"project\": {
        \"key\": \"JB\"
      },
      \"summary\": \"$SUMMARY\",
      \"description\": {
        \"type\": \"doc\",
        \"version\": 1,
        \"content\": [
          {
            \"type\": \"paragraph\",
            \"content\": [
              {
                \"type\": \"text\",
                \"text\": \"$DESCRIPTION\"
              }
            ]
          }
        ]
      },
      \"issuetype\": {
        \"name\": \"Task\"
      },
      \"labels\": [\"$PRIORITY_LABEL\"]
    }
  }")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" -eq 201 ]; then
    ISSUE_KEY=$(echo "$BODY" | python3 -c 'import sys, json; data=json.load(sys.stdin); print(data.get("key", ""))')
    ISSUE_URL="https://tim52.atlassian.net/browse/$ISSUE_KEY"

    echo -e "${GREEN}✓ Success!${NC}"
    echo ""
    echo "Issue created: $ISSUE_KEY"
    echo "URL: $ISSUE_URL"
    echo ""
    echo "The application is now in your backlog."
    echo "Move it through the stages as you progress!"
else
    echo "✗ Failed to create issue (HTTP $HTTP_CODE)"
    echo "Response: $BODY" | python3 -c 'import sys, json; data=json.load(sys.stdin); print(data.get("errorMessages", data))' 2>/dev/null || echo "$BODY"
fi
