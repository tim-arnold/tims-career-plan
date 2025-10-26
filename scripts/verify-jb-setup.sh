#!/bin/bash

# Script to verify Job Board setup

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Verifying Job Board Setup ===${NC}"
echo ""

# Get board configuration
curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/agile/1.0/board/34/configuration" | \
  python3 << 'PYEOF'
import sys, json

data = json.load(sys.stdin)
columns = data.get('columnConfig', {}).get('columns', [])

print("Current Board Columns:")
print("-" * 60)

# Desired columns for Option 2
desired = ['Backlog', 'Ready to Apply', 'Applied', 'Screening',
           'Interviewing', 'Offer', 'Closed']

# Also acceptable variations
acceptable = {
    'To Do': 'Research',
    'Rejected': 'Closed',
    'Offer Received': 'Offer'
}

found_columns = [col.get('name', '') for col in columns]

for i, col in enumerate(columns, 1):
    col_name = col.get('name', 'Unnamed')
    statuses = col.get('statuses', [])
    status_names = ', '.join([s.get('name', '') for s in statuses]) or 'No statuses'

    # Check if it's desired
    is_desired = col_name in desired or col_name in acceptable
    marker = '\033[0;32m✓\033[0m' if is_desired else '\033[1;33m!\033[0m'

    print(f"{marker} Column {i}: {col_name}")
    if statuses:
        print(f"   Statuses: {status_names}")

print()
print("-" * 60)

# Check coverage
print("\nColumn Coverage Check:")
print()

for desired_col in desired:
    if desired_col in found_columns:
        print(f"\033[0;32m✓\033[0m {desired_col}")
    elif any(acceptable.get(fc) == desired_col for fc in found_columns):
        alt = [k for k, v in acceptable.items() if v == desired_col and k in found_columns][0]
        print(f"\033[1;33m~\033[0m {desired_col} (using '{alt}')")
    else:
        print(f"\033[0;31m✗\033[0m {desired_col} - MISSING")

print()

# Summary
missing_count = sum(1 for dc in desired if dc not in found_columns
                   and not any(acceptable.get(fc) == dc for fc in found_columns))

if missing_count == 0:
    print("\033[0;32m✓ Setup complete! All columns configured.\033[0m")
    print()
    print("Next steps:")
    print("  1. Create your first application: ./scripts/create-job-application.sh")
    print("  2. View your pipeline: ./scripts/list-job-pipeline.sh")
elif len(found_columns) > 3:
    print(f"\033[1;33m~ Partial setup ({len(found_columns)}/7 columns)\033[0m")
    print()
    print("You have some columns set up. Add the missing ones:")
    print("  1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34")
    print("  2. Board → Board settings → Columns")
    print("  3. Add missing columns listed above")
else:
    print(f"\033[0;31m✗ Setup incomplete ({len(found_columns)}/7 columns)\033[0m")
    print()
    print("Follow the setup guide:")
    print("  cat ./scripts/SETUP-GUIDE.md")

PYEOF
