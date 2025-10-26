# Job Board Setup Guide - Option 2 (7 Columns)

## Quick Setup (5 minutes)

Your Job Board is a **team-managed project**, which is perfect for job tracking. You need to create statuses first, then assign them to columns.

### Step 1: Create Statuses in Workflow

**IMPORTANT:** You must create statuses before you can use them in columns.

1. Go to: https://tim52.atlassian.net/jira/settings/projects/JB
2. Click **"Workflow"** in the left sidebar
3. Click **"Add status"** or **"Create status"**
4. Create each of these statuses:

   | Status Name | Category | Notes |
   |-------------|----------|-------|
   | **Backlog** | To Do | Opportunities to research |
   | **Ready to Apply** | To Do | Application materials ready |
   | **Screening** | In Progress | Phone/recruiter screen |
   | **Interviewing** | In Progress | Active interviews |
   | **Offer** | In Progress | Offer received |
   | **Accepted** | Done | Offer accepted ✅ |
   | **Withdrawn** | Done | You withdrew |

5. Save each status after creating it

**Already Exist:** You already have "Applied" and "Rejected" so skip those.

### Step 2: Assign Statuses to Columns

1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/settings/board
2. Click **"Columns and statuses"**
3. You'll see "Unassigned statuses" - these are your newly created statuses
4. **Drag each status** into the column area to create columns:

   | Column | Drag These Statuses |
   |--------|---------------------|
   | **Backlog** | Backlog |
   | **Ready to Apply** | Ready to Apply |
   | **Applied** | Applied (already exists) |
   | **Screening** | Screening |
   | **Interviewing** | Interviewing |
   | **Offer** | Offer |
   | **Closed** | Accepted, Rejected, Withdrawn |

**Note:** The "Closed" column can contain multiple statuses (Accepted, Rejected, Withdrawn)

### Step 3: Final Column Order

After setup, your board should have these columns in order:

```
1. Backlog
2. Research (or "To Do")
3. Ready to Apply
4. Applied
5. Screening
6. Interviewing
7. Offer
8. Closed (contains: Rejected, Accepted, Withdrawn)
```

Or the simpler 7-column version:

```
1. Backlog
2. Ready to Apply
3. Applied
4. Screening
5. Interviewing
6. Offer
7. Closed
```

### Step 4: Verify Setup

Once you've added the columns, run:

```bash
./scripts/verify-jb-setup.sh
```

This will check that all columns are configured correctly.

---

## Alternative: Even Simpler Setup

If you want to keep it minimal for now, just add these 4 columns:

```
Backlog → Applied → Interviewing → Offer → Closed
```

This gives you the essential pipeline without too much complexity.

---

## Next Steps

After adding columns:
1. Run `./scripts/verify-jb-setup.sh` to confirm setup
2. Use `./scripts/create-job-application.sh` to add new opportunities
3. Use `./scripts/list-job-pipeline.sh` to see your current pipeline
4. Use `./scripts/update-job-status.sh` to move applications through stages

---

## Tips

- **Column limits**: Consider setting WIP limits on "Interviewing" (e.g., max 5) to stay focused
- **Swimlanes**: Use board settings to group by priority or company tier
- **Quick filters**: Create filters for "This Week", "High Priority", "Needs Follow-up"

---

Let me know when you've added the columns and I'll verify the setup!
