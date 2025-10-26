# Job Board Scripts

Automated scripts for managing your Job Board (JB) Jira project.

## Setup

### First Time Setup

1. **Add columns to your board** (2-3 minutes):
   ```bash
   cat SETUP-GUIDE.md
   ```
   Follow the guide to add the 7 columns via Jira UI.

2. **Verify setup**:
   ```bash
   ./verify-jb-setup.sh
   ```

## Daily Scripts

### Create New Application
```bash
./create-job-application.sh
```
Interactively create a new job application. Prompts for:
- Company name
- Job title
- Job URL
- Salary range
- Priority (1-3)

### View Pipeline
```bash
./list-job-pipeline.sh
```
Shows all applications grouped by status with counts and priorities.

### Update Application Status
```bash
./update-job-status.sh
```
Move an application through the pipeline (e.g., Applied → Screening).

### Weekly Review
```bash
./weekly-review.sh
```
Comprehensive weekly summary with:
- New applications this week
- Pipeline status breakdown
- Hot opportunities (interviews/offers)
- Stale applications needing follow-up
- Conversion metrics
- Action items

## Utility Scripts

### List Projects
```bash
./list-jira-projects.sh
```
Shows all your Jira projects.

### Get Board Info
```bash
./get-jb-board-info.sh
```
Display current board configuration and columns.

### Check Project Type
```bash
./check-project-type.sh
```
Show project type and configuration details.

## Recommended Workflow

### Daily (2-3 minutes)
```bash
./list-job-pipeline.sh
```
Quick check of your pipeline status.

### When Adding Opportunities
```bash
./create-job-application.sh
```
Add new opportunities as you find them.

### When Status Changes
```bash
./update-job-status.sh
```
Move applications through the pipeline when you:
- Submit an application (Backlog → Applied)
- Get a screening call (Applied → Screening)
- Start interviews (Screening → Interviewing)
- Receive an offer (Interviewing → Offer)
- Accept/reject an offer (Offer → Accepted/Closed)

### Weekly (10 minutes)
```bash
./weekly-review.sh
```
Run every Monday to:
- Review progress
- Identify stale applications
- Plan the week ahead

## Tips

### Set Up Aliases
Add to your `~/.zshrc` or `~/.bashrc`:

```bash
alias job-new='~/sites-personal/tims-career-plan/scripts/create-job-application.sh'
alias job-list='~/sites-personal/tims-career-plan/scripts/list-job-pipeline.sh'
alias job-update='~/sites-personal/tims-career-plan/scripts/update-job-status.sh'
alias job-review='~/sites-personal/tims-career-plan/scripts/weekly-review.sh'
```

Then simply use:
- `job-new` to create applications
- `job-list` to view pipeline
- `job-update` to move cards
- `job-review` for weekly summary

### Weekly Cron Job
Set up a weekly reminder:

```bash
# Add to crontab (crontab -e)
# Run every Monday at 9am
0 9 * * 1 cd ~/sites-personal/tims-career-plan && ./scripts/weekly-review.sh
```

### Labels
When creating applications, use priority:
- `1` = Tier 1 (dream companies) 🔥
- `2` = Tier 2 (solid opportunities)
- `3` = Tier 3 (backup options)

Add custom labels in Jira for:
- `remote`, `hybrid`, `onsite`
- `startup`, `enterprise`
- `referral`, `direct-apply`, `recruiter`

## Troubleshooting

### "No such file or directory" for .env.local
The scripts source credentials from `~/sites-personal/libarycard/.env.local`.
Make sure this file exists and contains `JIRA_API_TOKEN`.

### "Permission denied"
Make scripts executable:
```bash
chmod +x *.sh
```

### "Issue not found"
Make sure you're using the correct issue key format: `JB-1`, `JB-2`, etc.

### API Token Expired
Generate a new Atlassian API token:
1. Go to: https://id.atlassian.com/manage-profile/security/api-tokens
2. Create new token
3. Update `JIRA_API_TOKEN` in `.env.local`

## References

- Jira Board: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34
- Project Key: `JB`
- Board ID: `34`

## Next Steps

After setup:
1. Start adding opportunities to your backlog
2. Move them through the pipeline as you progress
3. Run weekly reviews to stay on track
4. Analyze metrics to improve your approach

Good luck with your job search! 🚀
