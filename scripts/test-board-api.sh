#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/agile/1.0/board/34/configuration" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    cols = data.get('columnConfig', {}).get('columns', [])
    print('Current columns:', [c.get('name') for c in cols])
except Exception as e:
    print(f'Error: {e}')
"
