# Creating Statuses for Job Board (Team-Managed Project)

## The Issue
Team-managed projects require you to create statuses through the workflow before you can assign them to columns.

## Step-by-Step Instructions

### Step 1: Access Workflow Management

**Option A: Via Space Settings**
1. Go to: https://tim52.atlassian.net/jira/settings/projects/JB
2. Click **"Workflow"** in the left sidebar
3. You should see your current workflow with the 3 existing statuses

**Option B: Via Board Settings**
1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34
2. Click **⋯** → **Board settings**
3. Look for **"Manage workflow"** link

### Step 2: Add New Statuses to Workflow

Once in the workflow editor:

1. Look for a **"+ Add status"** or **"Create status"** button
2. Add each of these statuses one by one:

| Status Name | Category | Description |
|-------------|----------|-------------|
| **Backlog** | To Do | Opportunities identified |
| **Ready to Apply** | To Do | Application materials prepared |
| **Screening** | In Progress | Phone/recruiter screen |
| **Interviewing** | In Progress | Active interview rounds |
| **Offer** | In Progress | Offer received/negotiating |
| **Accepted** | Done | Offer accepted |
| **Withdrawn** | Done | Application withdrawn |

**For each status:**
- Click "Add status" or "Create status"
- Enter the name
- Select the category (To Do, In Progress, or Done)
- Save

### Step 3: Assign Statuses to Columns

After creating all statuses:

1. Go back to: https://tim52.atlassian.net/jira/software/c/projects/JB/settings/board
2. Click **"Columns and statuses"**
3. You should now see all your new statuses in "Unassigned statuses"
4. **Drag each status** to create/assign to columns:

**Target Column Structure:**

```
Column 1: Backlog
  └─ Status: Backlog

Column 2: Ready to Apply
  └─ Status: Ready to Apply

Column 3: Applied
  └─ Status: Applied (already exists)

Column 4: Screening
  └─ Status: Screening

Column 5: Interviewing
  └─ Status: Interviewing

Column 6: Offer
  └─ Status: Offer

Column 7: Closed
  └─ Status: Accepted
  └─ Status: Rejected (already exists)
  └─ Status: Withdrawn
```

### Step 4: Verify Setup

Run the verification script:
```bash
./scripts/verify-jb-setup.sh
```

---

## Alternative: Simpler Column Structure

If you want fewer columns, you can create just these statuses:

**Minimal (5 statuses):**
- Backlog
- Interviewing
- Offer
- Accepted
- Withdrawn

Then assign them like:
```
To Do → Applied → Interviewing → Offer → Closed (Accepted/Rejected/Withdrawn)
```

---

## Troubleshooting

### Can't Find Workflow Settings?
- Team-managed projects have workflow settings under:
  - Project settings → Workflow, OR
  - Board settings → Manage workflow

### Status Already Exists Error?
- Some status names might already exist globally in your Jira instance
- Try variations like "Phone Screen" instead of "Screening"

### Can't Drag Status to Column?
- Make sure the status was created successfully
- Refresh the page
- Try creating the column first, then dragging the status to it

---

## After Setup

Once all statuses are created and assigned to columns, you can:

1. **Create your first application:**
   ```bash
   ./scripts/create-job-application.sh
   ```

2. **View your pipeline:**
   ```bash
   ./scripts/list-job-pipeline.sh
   ```

3. **Update application status:**
   ```bash
   ./scripts/update-job-status.sh
   ```

---

Need help? The verification script will show you exactly which statuses are missing.
