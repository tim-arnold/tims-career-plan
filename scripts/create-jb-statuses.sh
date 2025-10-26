#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

echo "=== Creating Job Board Statuses ==="
echo ""

# Function to create a status
create_status() {
    local name="$1"
    local category="$2"

    echo "Creating status: $name (category: $category)..."

    RESPONSE=$(curl -s -w "\n%{http_code}" \
      -X POST \
      -H "Authorization: Basic $AUTH_HEADER" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      "https://tim52.atlassian.net/rest/api/3/status" \
      -d "{
        \"name\": \"$name\",
        \"statusCategory\": \"$category\"
      }")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)

    if [ "$HTTP_CODE" -eq 201 ] || [ "$HTTP_CODE" -eq 200 ]; then
        echo "  ✓ Created: $name"
        echo "$BODY" | python3 -c "import sys, json; data=json.load(sys.stdin); print(f'    ID: {data.get(\"id\", \"N/A\")}')" 2>/dev/null || echo "    (Status created)"
    else
        echo "  ✗ Failed to create $name (HTTP $HTTP_CODE)"
        echo "    Response: $(echo $BODY | python3 -c 'import sys, json; data=json.load(sys.stdin); print(data.get("errorMessages", data.get("message", "Unknown error")))' 2>/dev/null || echo $BODY)"
    fi
    echo ""
}

# Create the statuses we need
# Note: statusCategory can be "TODO", "INDETERMINATE", or "DONE"

create_status "Backlog" "TODO"
create_status "Ready to Apply" "TODO"
create_status "Screening" "INDETERMINATE"
create_status "Interviewing" "INDETERMINATE"
create_status "Offer Received" "INDETERMINATE"
create_status "Withdrawn" "DONE"
create_status "Accepted" "DONE"

echo ""
echo "=== Status Creation Complete ==="
echo ""
echo "Note: If you see permission errors, you may need to create these statuses"
echo "through the Jira UI instead:"
echo ""
echo "  1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34"
echo "  2. Click Board → Board settings → Columns"
echo "  3. Click 'Add column' and create new columns with these names"
echo ""
