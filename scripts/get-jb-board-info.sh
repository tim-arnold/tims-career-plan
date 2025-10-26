#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

echo "=== Job Board (JB) - Board Configuration ==="
echo ""

# Get all boards for the project
echo "1. Finding board ID..."
BOARD_DATA=$(curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/agile/1.0/board?projectKeyOrId=JB")

echo "$BOARD_DATA" | python3 -c "
import sys, json
data = json.load(sys.stdin)
boards = data.get('values', [])
if boards:
    for b in boards:
        print(f\"Board ID: {b['id']}, Name: {b['name']}, Type: {b['type']}\")
        board_id = b['id']
else:
    print('No boards found for JB project')
    sys.exit(1)
" > /tmp/jb_board_id.txt

cat /tmp/jb_board_id.txt
BOARD_ID=$(grep "Board ID" /tmp/jb_board_id.txt | head -1 | sed 's/Board ID: //' | cut -d',' -f1)

if [ -z "$BOARD_ID" ]; then
    echo "Could not find board ID"
    exit 1
fi

echo ""
echo "2. Getting board columns/statuses for board $BOARD_ID..."
curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/agile/1.0/board/$BOARD_ID/configuration" | \
  python3 -c "
import sys, json
data = json.load(sys.stdin)
columns = data.get('columnConfig', {}).get('columns', [])

if columns:
    print(f\"\n{'COLUMN NAME':<30} {'STATUSES':<50}\")
    print('-' * 80)
    for col in columns:
        col_name = col.get('name', 'Unnamed')
        statuses = col.get('statuses', [])
        status_names = ', '.join([s.get('name', '') for s in statuses])
        print(f'{col_name:<30} {status_names:<50}')
else:
    print('No columns found')
"

echo ""
echo "3. Getting current issues in JB project..."
curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/search?jql=project=JB&fields=key,summary,status&maxResults=10" | \
  python3 -c "
import sys, json
data = json.load(sys.stdin)
issues = data.get('issues', [])

if issues:
    print(f\"\n{'KEY':<10} {'STATUS':<20} SUMMARY\")
    print('-' * 80)
    for i in issues:
        key = i['key']
        status = i['fields']['status']['name']
        summary = i['fields']['summary']
        print(f'{key:<10} {status:<20} {summary[:45]}')
else:
    print('No issues found in JB project')
"
