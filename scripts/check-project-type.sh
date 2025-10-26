#!/bin/bash

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/project/JB" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(f\"Project Name: {data.get('name', 'N/A')}\")
print(f\"Project Type: {data.get('projectTypeKey', 'N/A')}\")
print(f\"Style: {data.get('style', 'N/A')}\")
print(f\"Simplified: {data.get('simplified', 'N/A')}\")
print()
print('Team-managed projects (simplified) are easier to configure via UI.')
print('Company-managed projects require workflow scheme configuration via API.')
print()
print('For automation, team-managed is actually better - we can add columns')
print('directly through the board configuration.')
"
