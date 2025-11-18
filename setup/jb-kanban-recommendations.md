# Job Board (JB) Kanban Structure Recommendations

## Current Setup
- **Project Key**: JB
- **Board ID**: 34
- **Current Columns**: To Do → Applied → Rejected

## Recommended Enhancements

Your current 3-column setup is minimal. Here are progressive options to improve it:

---

## Option 1: Minimal Enhancement (5 columns)
**Best for**: Simple tracking without too much overhead

```
To Do → Applied → Interviewing → Rejected → Accepted
```

**What to add:**
1. **Interviewing** - Between Applied and Rejected (for active processes)
2. **Accepted** - Success state (separate from Rejected)

**Why**: This gives you visibility into active opportunities vs. completed ones (success or failure).

---

## Option 2: Moderate Detail (7 columns) ⭐ RECOMMENDED
**Best for**: Balanced tracking with good pipeline visibility

```
Backlog → Ready to Apply → Applied → Screening → Interviewing → Offer → Closed
```

**Columns:**
1. **Backlog** - Companies/roles to research
2. **Ready to Apply** - Application materials prepared
3. **Applied** - Submitted, awaiting response
4. **Screening** - Phone/recruiter screen scheduled
5. **Interviewing** - Active interview rounds
6. **Offer** - Offer received/negotiating
7. **Closed** - Final state (accepted, rejected, or withdrawn)

**Why**: This provides clear pipeline stages and helps identify where applications stall.

---

## Option 3: Detailed Tracking (9 columns)
**Best for**: Maximum visibility and analytics

```
Research → Prep → Applied → Screen → Interview → Offer → Accepted → Rejected → Withdrawn
```

**Additional detail:**
- Separate **Accepted**, **Rejected**, and **Withdrawn** states
- **Research** vs **Prep** stages
- Allows for better conversion rate analysis

**Why**: Great for data-driven job searches, but requires more diligence to maintain.

---

## Implementation Steps

### Manual Setup (via Jira UI)
1. Go to: https://tim52.atlassian.net/jira/software/c/projects/JB/boards/34
2. Click **Board** → **Board settings** → **Columns**
3. Add new columns and map statuses

### Automated Setup (via API)
I can create scripts to:
- Create new statuses in your workflow
- Update board column configuration
- Bulk migrate existing issues if needed

---

## Recommended Workflow Statuses

For **Option 2** (recommended), you'll need these statuses:

| Status | Category | Description |
|--------|----------|-------------|
| Backlog | To Do | Identified opportunity |
| Ready to Apply | To Do | Materials prepared |
| Applied | In Progress | Application submitted |
| Screening | In Progress | Initial call scheduled |
| Interviewing | In Progress | In interview rounds |
| Offer Received | In Progress | Evaluating offer |
| Accepted | Done | Offer accepted ✅ |
| Rejected | Done | Not selected ❌ |
| Withdrawn | Done | You withdrew 🛑 |

---

## Suggested Labels/Components

Add these to categorize applications:

### Priority
- `tier-1` - Dream companies
- `tier-2` - Strong fit
- `tier-3` - Backup options

### Work Mode
- `remote`
- `hybrid`
- `onsite`

### Company Type
- `startup`
- `mid-size`
- `enterprise`

### Application Method
- `direct-apply`
- `referral`
- `recruiter`
- `linkedin`

---

## Custom Fields to Add

Consider adding these fields to JB issue type:

1. **Company Name** (text)
2. **Job Title** (text)
3. **Application Date** (date)
4. **Salary Range** (text)
5. **Job URL** (URL)
6. **Contact Person** (text)
7. **Next Follow-up Date** (date)
8. **Response Deadline** (date - for offers)

---

## Automation Rules

Set up these automations in Jira:

### 1. Auto-flag stale applications
```
WHEN: Issue in "Applied" for more than 14 days
THEN: Add label "stale" and comment "No response in 2 weeks - consider following up"
```

### 2. Set due dates for offers
```
WHEN: Issue moves to "Offer Received"
THEN: Prompt for due date (offer deadline)
```

### 3. Archive old rejections
```
WHEN: Issue in "Rejected" for more than 30 days
THEN: Add label "archived"
```

---

## Quick Start Scripts

I can create these helper scripts for you:

1. **create-job-application.sh** - Quickly add new opportunities
2. **list-active-applications.sh** - See pipeline status
3. **update-application-status.sh** - Move cards between columns
4. **weekly-review.sh** - Summary report of your job search

---

## Next Steps

**Choose your approach:**

**A. Manual Setup** (5-10 minutes)
   - I'll guide you through Jira UI steps
   - You add columns manually

**B. Scripted Setup** (automated)
   - I'll create scripts to configure everything
   - Run once and you're done

**C. Hybrid**
   - You add columns via UI
   - I create helper scripts for daily use

Which would you prefer?

---

## My Recommendation

Based on your career transition plan in this repo, I'd suggest:

1. **Use Option 2** (7 columns) - good balance of detail without overhead
2. **Add custom fields** for Company Name, Job Title, Application Date, Salary Range
3. **Use labels** for priority tiers and work mode (remote/hybrid/onsite)
4. **Create helper scripts** to quickly add applications and check status
5. **Set up weekly review** automation or reminder

This will give you clear visibility into your pipeline while keeping maintenance manageable during an active job search.

Let me know which option you prefer and how you'd like to set it up!
