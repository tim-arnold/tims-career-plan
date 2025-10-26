#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/project" | \
  python3 -c "
import sys, json
data = json.load(sys.stdin)
if isinstance(data, list):
    projects = data
else:
    projects = data.get('values', [])

print(f\"{'KEY':<10} {'NAME':<30} TYPE\")
print('-' * 60)
for p in projects:
    key = p.get('key', '')
    name = p.get('name', '')
    ptype = p.get('projectTypeKey', '')
    print(f'{key:<10} {name:<30} {ptype}')
"
