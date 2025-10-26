#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Creating Statuses for Team-Managed Project ===${NC}"
echo ""

# For team-managed projects, we need to get the project's workflow first
echo "1. Getting project workflow..."

# Get project details to find the workflow scheme
PROJECT_ID=$(curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/project/JB" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('id', ''))
")

echo "   Project ID: $PROJECT_ID"
echo ""

# Statuses we need to create
echo "2. Statuses to create for Option 2 workflow:"
echo "   - Backlog"
echo "   - Ready to Apply"
echo "   - Screening"
echo "   - Interviewing"
echo "   - Offer"
echo "   - Accepted"
echo "   - Withdrawn"
echo ""

echo "3. Attempting to create statuses..."
echo ""

# Function to create status for team-managed project
create_status() {
    local status_name="$1"
    local category="$2"  # TODO, INDETERMINATE, or DONE

    echo -n "   Creating '$status_name'... "

    # For team-managed projects, try using the statuses endpoint with project context
    RESPONSE=$(curl -s -w "\n%{http_code}" \
      -X POST \
      -H "Authorization: Basic $AUTH_HEADER" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      "https://tim52.atlassian.net/rest/api/3/statuses" \
      -d "{
        \"statuses\": [
          {
            \"name\": \"$status_name\",
            \"statusCategory\": \"$category\",
            \"scope\": {
              \"type\": \"PROJECT\",
              \"project\": {
                \"id\": \"$PROJECT_ID\"
              }
            }
          }
        ]
      }")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" -eq 200 ] || [ "$HTTP_CODE" -eq 201 ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ (HTTP $HTTP_CODE)${NC}"
        if [ -n "$BODY" ]; then
            echo "      Error: $(echo $BODY | python3 -c 'import sys, json; d=json.load(sys.stdin); print(d.get("errorMessages", [d.get("message", "Unknown")]))'  2>/dev/null || echo $BODY | head -c 100)"
        fi
    fi
}

# Create each status
create_status "Backlog" "TODO"
create_status "Ready to Apply" "TODO"
create_status "Screening" "INDETERMINATE"
create_status "Interviewing" "INDETERMINATE"
create_status "Offer" "INDETERMINATE"
create_status "Accepted" "DONE"
create_status "Withdrawn" "DONE"

echo ""
echo "---"
echo ""
echo "If the API method above doesn't work (which is common for team-managed projects),"
echo "you'll need to add statuses through the Jira UI:"
echo ""
echo "Option A: Add via Board Settings (EASIEST)"
echo "  1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34"
echo "  2. Click ⋯ → Board settings → Columns"
echo "  3. Click 'Add column'"
echo "  4. Type the new status name (it will create the status automatically)"
echo "  5. Repeat for each status:"
echo "     - Backlog"
echo "     - Ready to Apply"
echo "     - Screening"
echo "     - Interviewing"
echo "     - Offer"
echo "     - Accepted"
echo "     - Withdrawn"
echo ""
echo "Option B: Add via Project Settings"
echo "  1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/settings/board"
echo "  2. Click 'Workflow' in left sidebar"
echo "  3. Add new statuses to the workflow"
echo ""
echo "After adding statuses, run: ./verify-jb-setup.sh"
