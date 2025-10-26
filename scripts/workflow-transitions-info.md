# Workflow Transitions for Team-Managed Projects

## Short Answer: NO (Usually)

Team-managed projects typically create **automatic transitions** between all statuses by default.

## What This Means

When you create statuses in a team-managed project:
- Jira automatically allows transitions from ANY status to ANY other status
- You don't need to manually define transitions
- Users can move issues freely through the workflow

## How to Check

After creating your statuses, you can verify:

1. Create a test issue or use an existing one
2. Try moving it between statuses using the scripts:
   ```bash
   ./scripts/update-job-status.sh
   ```
3. If you see all your statuses as options, transitions are automatic ✓

## If Transitions Are Missing

**Unlikely for team-managed projects**, but if you can't move issues:

### Option 1: Check Workflow Editor
1. Go to: https://tim52.atlassian.net/jira/settings/projects/JB
2. Click "Workflow"
3. Look at the workflow diagram
4. If it's a simple "All → All" workflow, you're good
5. If it shows specific arrows between statuses, you may need to add transitions

### Option 2: Add Transitions Manually
If required (rare):
1. In workflow editor, click on a status
2. Look for "Add transition" or similar
3. Create transition to target status
4. Repeat for all needed paths

## For Job Board Use Case

**You should NOT need to create transitions manually** because:

1. Team-managed projects default to flexible workflows
2. Job applications need to move freely (sometimes skip steps)
3. The `update-job-status.sh` script will show available transitions

## Example Flexible Workflow

```
    ┌─────────────┐
    │   Backlog   │ ──┐
    └─────────────┘   │
                      │
    ┌─────────────┐   │
    │Ready to Apply│──┤
    └─────────────┘   │
                      │
    ┌─────────────┐   ├──→ All statuses can
    │   Applied   │ ──┤    transition to
    └─────────────┘   │    any other status
                      │
    ┌─────────────┐   │
    │  Screening  │ ──┤
    └─────────────┘   │
                      │
         etc...       ┘
```

## What You Actually Need to Do

**Just create the statuses.** That's it.

The workflow will handle transitions automatically.

## Testing After Setup

1. Create statuses (7 new ones)
2. Assign to columns
3. Run: `./scripts/verify-jb-setup.sh`
4. Create test application: `./scripts/create-job-application.sh`
5. Try updating status: `./scripts/update-job-status.sh`

If step 5 shows all your statuses, you're done! ✓

---

**TL;DR: For team-managed projects, just create the statuses. Transitions are automatic.**
