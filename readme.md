# Team Sync — Employee Onboarding & Task Tracker

An internal tool for HR managers to onboard new hires, assign onboarding
tasks, track progress, and manage the workflow around getting a new
employee up to speed.

## Tech stack

- **Framework:** Flutter (Dart), single codebase targeting web/desktop/mobile
- **State management:** Built-in `StatefulWidget` / `setState` only — no
  Provider, Riverpod, Bloc, etc.
- **Data:** Everything is in-memory (`List`/`Map` literals seeded at
  startup). **Nothing persists** — a page refresh or app restart resets
  all data back to the seed values.
- **Backend:** None. No HTTP client, no database, no auth. This is a
  frontend-only prototype.

## Screens

| Screen | Purpose |
|---|---|
| Dashboard | Stat cards, onboarding pipeline, manager action center, employee table with search/nudge |
| Employees | Employee directory, filter by status, add new employee, edit job title/department |
| Tasks | Static kanban-style board (Due today / In progress / Needs attention / Completed) |
| Templates | Create/edit/delete onboarding templates, each with its own task checklist |
| Approvals | Approval queue for onboarding items (equipment, clearance, policy sign-off, etc.) |
| Journey | Per-employee onboarding timeline across pre-boarding → week 2 |
| Announcements | Company-wide announcement feed |
| Reports | Static onboarding metrics and recent activity feed |
| Integrations | Slack / Google Workspace / Teams / Zapier / Jira / GitHub connection management |
| Settings | Notification preferences, default onboarding duration, theme, reset to defaults |

## What's working

Everything below is wired to real (in-memory) state — buttons actually do
something, not just decoration:

- **Navigation** — responsive sidebar (web) / bottom nav + drawer (mobile)
- **Employees**
  - **Add Employee** — full name, job title, department, hire date (Phase 1: User Management, Department Tagging, Hire Date Tracker)
  - Filter by status (All / In Progress / At Risk / Completed)
  - **View profile** → edit job title and department, hire date shown
- **Templates**
  - Create a template (name, department, description) with a nested task list (each task: title, due days after hire, optional document link, department scope)
  - Edit an existing template's details
  - Delete a template
- **Tasks / onboarding checklist**
  - "Mark Done" on a task prompts for a completion note, then marks it complete (Phase 3: Note Submission)
  - "View Details" / "Remove Task" via an overflow menu
  - Task checkboxes in the employee side panel toggle completion
- **Dashboard**
  - Employee table search filters by name
  - **Nudge** logs a reminder (confirmation toast) for a slow employee (Phase 4)
  - Dismissible system maintenance banner
  - "View all" opens the full Manager Action Center list
  - Selecting an employee row opens their profile + task panels
- **Approvals** — "Approve" transitions an item's status; "Details" shows a full dialog
- **Employee Journey** — the employee picker actually rescopes the timeline shown (each employee has a distinct set of onboarding steps)
- **Integrations** — Connect / Disconnect / Manage / Learn more all update real state
- **Settings** — notification toggles, onboarding duration, theme, and a confirmed "Reset All Settings to Default"
- **Announcements** — "Open details" shows the full announcement in a dialog

## What's not implemented yet

From the approved project proposal, still outstanding:

- **Activity Logs** — a history log of exactly when an employee checked off each task (Phase 5)
- **Filter by Department** — managers filtering the dashboard/employee list down to one department, e.g. "Marketing only" (Phase 5)
- **Export Completion Report** — a printable HTML view of an employee's completed onboarding file (Phase 5)
- **Archive Employee** — moving an employee to an "Onboarded" status to clean up the active dashboard pool (Phase 5)
- **Overdue indicators on individual tasks** — task rows should switch to red text once their due date has passed; currently only the aggregate "overdue tasks" count is colored (Phase 4)

Beyond the proposal's scope (built as extra functionality, not required by
Phase 1–5, but present in the app and kept working):

- Approval Workflow screen
- Integration Hub screen
- Settings screen

## Known limitations

- **No persistence.** Everything resets on refresh/restart — there is no
  database, local storage, or backend API.
- **No authentication.** The signed-in "Sarah Johnson / HR Manager" in the
  sidebar is a hardcoded placeholder, not a real logged-in user.
- **No real integrations.** The Integration Hub's Slack/Google/Teams/etc.
  connections are simulated locally; nothing actually calls those
  services.
- **Tasks/Reports screens are still static** — the Tasks kanban board and
  Reports dashboard show fixed mock data with no interactivity.

## What can be done next

1. Finish the remaining Phase 4/5 items above (Activity Logs, Filter by
   Department, Export Completion Report, Archive Employee, per-task
   overdue indicators).
2. Add a real data layer (e.g. a repository/service abstraction) so
   screens aren't each holding their own disconnected copies of mock
   data — today, for example, "Alex Morgan" exists as separate,
   independently-editable records in the Dashboard, Employees, and Task
   Details screens.
3. Add persistence (local: `shared_preferences`/`sqflite`; or a real
   backend) so onboarding progress survives a restart.
4. Add authentication and role-based access (Admin/HR vs. Manager vs.
   New Hire), per the proposal's Phase 1 user roles.
5. Wire the Tasks and Reports screens up to the same underlying data
   model as the rest of the app instead of static mock content.
