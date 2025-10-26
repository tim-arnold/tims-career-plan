# Job Board Setup - Ready to Go!

## What's Been Set Up

I've created a complete automated workflow system for your Job Board Jira project.

### Current Status
- **Project**: Job Board (JB)
- **Board ID**: 34
- **Board URL**: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34
- **Current Columns**: To Do → Applied → Rejected (ready to expand)

---

## Next Step: Add Columns (2-3 minutes)

You currently have 3 columns. To get the full Option 2 setup (7 columns), follow this guide:

```bash
cat scripts/SETUP-GUIDE.md
```

### Quick Summary:
1. Go to your board: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34
2. Click **⋯** → **Board settings** → **Columns**
3. Add these columns:
   - Backlog
   - Ready to Apply
   - Screening
   - Interviewing
   - Offer
   - Accepted

4. Rename "Rejected" to "Closed" (optional but clearer)

**Target Structure**:
```
Backlog → Ready to Apply → Applied → Screening → Interviewing → Offer → Closed
```

---

## Scripts Created

All scripts are in the `/scripts` directory:

### Daily Use
- **`create-job-application.sh`** - Add new opportunities
- **`list-job-pipeline.sh`** - View current pipeline
- **`update-job-status.sh`** - Move applications through stages

### Weekly Use
- **`weekly-review.sh`** - Comprehensive progress report

### Setup & Verification
- **`verify-jb-setup.sh`** - Check board configuration
- **`SETUP-GUIDE.md`** - Step-by-step column setup instructions
- **`README.md`** - Complete documentation

### Utility
- **`list-jira-projects.sh`** - List all projects
- **`get-jb-board-info.sh`** - Board details

---

## Quick Start

### 1. Add Columns to Board (if you haven't yet)
```bash
cat scripts/SETUP-GUIDE.md
# Follow the 2-minute UI steps
```

### 2. Verify Setup
```bash
./scripts/verify-jb-setup.sh
```

### 3. Create Your First Application
```bash
./scripts/create-job-application.sh
```

### 4. View Your Pipeline
```bash
./scripts/list-job-pipeline.sh
```

---

## Recommended Aliases

Add these to your `~/.zshrc`:

```bash
alias job-new='~/sites-personal/tims-career-plan/scripts/create-job-application.sh'
alias job-list='~/sites-personal/tims-career-plan/scripts/list-job-pipeline.sh'
alias job-update='~/sites-personal/tims-career-plan/scripts/update-job-status.sh'
alias job-review='~/sites-personal/tims-career-plan/scripts/weekly-review.sh'
```

Then reload: `source ~/.zshrc`

Now you can simply type:
- `job-new` - Create application
- `job-list` - View pipeline
- `job-update` - Update status
- `job-review` - Weekly summary

---

## Workflow Example

### Adding a New Opportunity
```bash
$ job-new

Company Name: Acme Corp
Job Title: Senior Frontend Engineer
Job URL: https://acme.com/careers/123
Salary Range: $150-180k
Priority (1-3): 1

✓ Success!
Issue created: JB-1
```

### Checking Your Pipeline
```bash
$ job-list

▸ Backlog (2)
  JB-1: Acme Corp - Senior Frontend Engineer 🔥
  JB-2: TechCo - Staff Engineer

▸ Applied (3)
  JB-3: StartupXYZ - Lead Developer
  ...

Total applications: 8
Active applications: 5
🔥 Hot opportunities: 1
```

### Moving Through Stages
```bash
$ job-update

Issue Key: JB-1
Available statuses:
1. Ready to Apply
2. Applied
3. Rejected

Select: 2

✓ Status updated successfully!
```

### Weekly Review
```bash
$ job-review

📊 Overview
  Total applications: 8
  New this week: 3
  Updated this week: 5

📈 Pipeline Status
  Active: 5
    • Ready to Apply: 2
    • Applied: 2
    • Interviewing: 1

🔥 Hot Opportunities: 1
  JB-5: Acme Corp - Senior Frontend Engineer [Interviewing]

✅ Action Items
  • Prepare for 1 active interview process
  • Submit 2 ready applications
```

---

## Features

### Automatic Tracking
- Priority labeling (tier-1, tier-2, tier-3)
- Creation and update timestamps
- Application URLs and salary ranges

### Analytics
- Conversion rates (applied → interview → offer)
- Pipeline visualization
- Stale application detection (>14 days)

### Scalable
- Works for 1 application or 100+
- Grouped by status
- Sortable and filterable in Jira

---

## Documentation

- **Kanban Structure Guide**: `job-board-kanban-structure.md`
- **Recommendations**: `jb-kanban-recommendations.md`
- **Scripts README**: `scripts/README.md`
- **Setup Guide**: `scripts/SETUP-GUIDE.md`

---

## What's Next?

1. **Add columns** (2 minutes via Jira UI)
2. **Verify setup**: `./scripts/verify-jb-setup.sh`
3. **Create first application**: `./scripts/create-job-application.sh`
4. **Set up aliases** (optional but recommended)
5. **Start tracking!**

---

## Support

All scripts pull from `~/sites-personal/libarycard/.env.local` for authentication.

If you have issues:
1. Check that `.env.local` has `JIRA_API_TOKEN`
2. Verify scripts are executable: `chmod +x scripts/*.sh`
3. Check board URL: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34

---

## Summary

You now have a **fully automated job application tracking system** that:

✅ Tracks applications through 7 pipeline stages
✅ Provides weekly analytics and insights
✅ Identifies stale applications needing follow-up
✅ Calculates conversion rates
✅ Works from command line (no UI needed for daily use)
✅ Integrates with your career plan in this repo

**The only manual step left**: Add the 4-5 new columns via Jira UI (2-3 minutes).

Then you're ready to start tracking your Q4 2025 career transition! 🚀

Good luck with your job search!
