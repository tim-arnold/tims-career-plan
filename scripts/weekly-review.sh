#!/bin/bash

# Weekly review of job application progress

source ~/sites-personal/libarycard/.env.local
AUTH_HEADER=$(echo -n "tim.arnold@gmail.com:$JIRA_API_TOKEN" | base64)

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Weekly Job Search Review ===${NC}"
echo ""
echo "Week of: $(date +%Y-%m-%d)"
echo ""

# Get all JB issues
curl -s \
  -H "Authorization: Basic $AUTH_HEADER" \
  -H "Accept: application/json" \
  "https://tim52.atlassian.net/rest/api/3/search?jql=project=JB+ORDER+BY+created+DESC&fields=key,summary,status,labels,created,updated&maxResults=200" | \
  python3 << 'PYEOF'
import sys, json
from datetime import datetime, timedelta

data = json.load(sys.stdin)
issues = data.get('issues', [])

if not issues:
    print('No applications tracked yet.')
    print()
    print('Get started:')
    print('  ./scripts/create-job-application.sh')
    sys.exit(0)

# Calculate date ranges
today = datetime.now()
week_ago = today - timedelta(days=7)
two_weeks_ago = today - timedelta(days=14)

# Stats
total = len(issues)
by_status = {}
created_this_week = []
updated_this_week = []
stale_applications = []

for issue in issues:
    status = issue['fields']['status']['name']
    by_status[status] = by_status.get(status, 0) + 1

    created = datetime.fromisoformat(issue['fields']['created'].replace('Z', '+00:00'))
    updated = datetime.fromisoformat(issue['fields']['updated'].replace('Z', '+00:00'))

    if created.replace(tzinfo=None) > week_ago:
        created_this_week.append(issue)

    if updated.replace(tzinfo=None) > week_ago and created.replace(tzinfo=None) <= week_ago:
        updated_this_week.append(issue)

    # Check for stale applications (Applied for >14 days)
    if status in ['Applied'] and updated.replace(tzinfo=None) < two_weeks_ago:
        stale_applications.append(issue)

# Print summary
print("\033[1;34m📊 Overview\033[0m")
print(f"  Total applications: {total}")
print(f"  New this week: {len(created_this_week)}")
print(f"  Updated this week: {len(updated_this_week)}")
print()

# Status breakdown
print("\033[1;34m📈 Pipeline Status\033[0m")
active_statuses = ['Backlog', 'Research', 'To Do', 'Ready to Apply', 'Applied',
                   'Screening', 'Interviewing', 'Offer', 'Offer Received']
done_statuses = ['Accepted', 'Rejected', 'Withdrawn', 'Closed']

active_count = sum(by_status.get(s, 0) for s in active_statuses)
success_count = by_status.get('Accepted', 0)
rejected_count = sum(by_status.get(s, 0) for s in ['Rejected', 'Withdrawn', 'Closed']) - success_count

print(f"  Active: {active_count}")
for status in active_statuses:
    if status in by_status:
        print(f"    • {status}: {by_status[status]}")

print()
print(f"  Closed: {total - active_count}")
print(f"    • Accepted: \033[0;32m{success_count}\033[0m")
print(f"    • Not selected: {rejected_count}")
print()

# Hot opportunities
hot_statuses = ['Interviewing', 'Offer', 'Offer Received']
hot_count = sum(by_status.get(s, 0) for s in hot_statuses)

if hot_count > 0:
    print(f"\033[1;33m🔥 Hot Opportunities: {hot_count}\033[0m")
    for issue in issues:
        if issue['fields']['status']['name'] in hot_statuses:
            key = issue['key']
            summary = issue['fields']['summary']
            status = issue['fields']['status']['name']
            print(f"  {key}: {summary[:40]} [{status}]")
    print()

# New this week
if created_this_week:
    print(f"\033[1;32m✨ Added This Week: {len(created_this_week)}\033[0m")
    for issue in created_this_week[:5]:  # Show first 5
        key = issue['key']
        summary = issue['fields']['summary']
        print(f"  {key}: {summary[:50]}")
    if len(created_this_week) > 5:
        print(f"  ... and {len(created_this_week) - 5} more")
    print()

# Stale applications
if stale_applications:
    print(f"\033[1;31m⚠️  Stale Applications (>14 days in 'Applied'): {len(stale_applications)}\033[0m")
    print("  Consider following up or moving to Rejected:")
    for issue in stale_applications[:5]:
        key = issue['key']
        summary = issue['fields']['summary']
        updated = issue['fields']['updated'][:10]
        print(f"  {key}: {summary[:40]} (last updated: {updated})")
    if len(stale_applications) > 5:
        print(f"  ... and {len(stale_applications) - 5} more")
    print()

# Conversion metrics
if total > 5:
    print("\033[1;34m📐 Metrics\033[0m")
    applied_count = sum(by_status.get(s, 0) for s in ['Applied', 'Screening', 'Interviewing',
                                                        'Offer', 'Offer Received', 'Accepted',
                                                        'Rejected', 'Withdrawn', 'Closed'])
    interview_count = sum(by_status.get(s, 0) for s in ['Interviewing', 'Offer', 'Offer Received', 'Accepted'])
    offer_count = sum(by_status.get(s, 0) for s in ['Offer', 'Offer Received', 'Accepted'])

    if applied_count > 0:
        interview_rate = (interview_count / applied_count) * 100
        print(f"  Interview rate: {interview_rate:.1f}%")

    if interview_count > 0:
        offer_rate = (offer_count / interview_count) * 100
        print(f"  Offer rate: {offer_rate:.1f}%")

    print()

# Action items
print("\033[1;34m✅ Action Items\033[0m")
if stale_applications:
    print(f"  • Follow up on {len(stale_applications)} stale applications")
if active_count == 0:
    print("  • Add new opportunities to your pipeline")
if by_status.get('Ready to Apply', 0) > 0:
    print(f"  • Submit {by_status['Ready to Apply']} ready applications")
if hot_count > 0:
    print(f"  • Prepare for {hot_count} active interview processes")

print()
print("---")
print("Keep pushing forward! 💪")

PYEOF
