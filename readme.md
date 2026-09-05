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
| Tasks | Interactive kanban-style board (Due today / In progress / Needs attention / Completed) |
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
  - Task Center kanban board: each card can move to any other column via a
    "Move to..." menu, columns show live counts, "+" adds a task to a
    column, and moving a card to Completed logs it to the Activity Log
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
- **Activity Logs** — a shared log records task completions and manager nudges; the Reports screen's activity feed shows these live, ahead of historical seed entries (Phase 5)
- **Filter by Department** — the dashboard's employee table has department filter chips alongside the name search (Phase 5)
- **Overdue indicators** — incomplete tasks past their due date render in red with an "Overdue" label, both on the dashboard and in the employee profile panel (Phase 4)
- **Export Completion Report** — the employee profile panel can generate an HTML onboarding report (employee info + completed tasks) with a "Copy HTML" action (Phase 5)
- **Archive Employee** — employees can be archived to an "Onboarded" status via a per-card menu, hidden from the default view, and restored again (Phase 5)
- **Persistence (Templates + Settings)** — these two screens save to local storage via `shared_preferences` and reload on startup, so they're the only parts of the app that survive a refresh/restart. Everything else is still in-memory only (see Known limitations).
- **Reports metric cards** — Completion rate, Pending approvals, Nudge activity, and At-risk hires are all computed live from the Employees, Approvals, and Activity Log data (no more hardcoded numbers). Making this possible: the Employees and Approvals screens' lists are now `static`, so they're shared with Reports and also survive navigating away and back (previously they silently reset to the seed data every time you left and returned to those screens, since `main.dart` swaps screens by disposing/recreating them rather than keeping them alive).

Beyond the proposal's scope (built as extra functionality, not required by
Phase 1–5, but present in the app and kept working):

- Approval Workflow screen
- Integration Hub screen
- Settings screen

## Known limitations

- **Persistence is partial.** Only Templates and Settings save to local
  storage (`shared_preferences`) and survive a refresh/restart. Every
  other screen (Employees, Tasks, Approvals, Journey, Integrations,
  Activity Log) is still in-memory only and resets on reload — there is
  no database or backend API anywhere in the app.
- **No authentication.** The signed-in "Sarah Johnson / HR Manager" in the
  sidebar is a hardcoded placeholder, not a real logged-in user.
- **No real integrations.** The Integration Hub's Slack/Google/Teams/etc.
  connections are simulated locally; nothing actually calls those
  services.
- **Approval Workflow's own quick-stat cards are still static** — the
  "Pending / In Review / Approved / Needs Action" cards at the top of
  that screen are fixed mock numbers (unlike Reports' metric cards,
  which are now real).

## What can be done next

All Phase 1–5 proposal items are now implemented. Remaining ideas:

1. Add a real data layer (e.g. a repository/service abstraction) so
   screens aren't each holding their own disconnected copies of mock
   data — today, for example, "Alex Morgan" exists as separate,
   independently-editable records in the Dashboard, Employees, and Task
   Details screens.
2. Extend persistence to the rest of the app (Employees, Tasks,
   Approvals, Activity Log, etc.) — the `shared_preferences` pattern
   used for Templates/Settings works the same way elsewhere, but each
   domain should go through the data-layer unification above first
   rather than persisting today's fragmented per-screen copies as-is.
3. Add authentication and role-based access (Admin/HR vs. Manager vs.
   New Hire), per the proposal's Phase 1 user roles.
4. Wire the Approval Workflow screen's own quick-stat cards up to real
   data the same way Reports' metric cards now are.
5. Actually render/print the Export Completion Report's HTML (e.g. via
   a WebView or by writing it to a file) instead of only showing/
   copying the raw markup.
