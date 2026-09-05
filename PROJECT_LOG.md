# Team Sync App - Project Log

**Status:** Front-end prototype
**Platform:** Flutter (Dart), with Android, iOS, web, Windows, macOS, and Linux project targets
**Last reviewed:** 2026-09-06

## 1. App Purpose

Team Sync is an employee onboarding and team coordination dashboard. It is designed for HR administrators and managers who need one place to:

- Monitor new-hire onboarding progress.
- Review employee status, departments, and tasks due today.
- Create reusable onboarding templates by department.
- Track approvals and operational handoffs.
- Follow an employee's onboarding journey from pre-onboarding through the first weeks.
- Review announcements, reports, integrations, and account preferences.

The current implementation is a navigable product prototype. It demonstrates the intended user experience and local interactions using sample data; it is not yet connected to a server or persistent data store.

## 2. Current Navigation and Workflow

The app starts in `MyApp`, which opens the `Dashboard` shell. The shell owns the selected navigation index and swaps the active feature screen into the main content area.

### Desktop and web-sized layouts

- A purple sidebar displays the Team Sync identity, user profile, and all feature destinations.
- A top bar shows the active section title.
- The selected navigation item is highlighted.

### Mobile-sized layouts

- The sidebar is hidden when the screen width is 600 pixels or less.
- A fixed bottom navigation bar exposes the same destinations.
- The top bar shows a menu icon, but the drawer behavior is still a TODO and is not connected.

### Available sections

1. **Dashboard** - Summary metrics, onboarding pipeline, manager action center, and employee/task detail areas.
2. **Employees** - Employee directory cards with department, progress, status, and tasks due today.
3. **Tasks** - Tasks grouped into Due today, In progress, Needs attention, and Completed.
4. **Templates** - Department-specific reusable onboarding templates.
5. **Approvals** - Approval queue with status and priority filtering.
6. **Journey** - A selected employee's onboarding timeline and completion progress.
7. **Announcements** - Team updates with audience, date, summary, and priority.
8. **Reports** - Completion, approvals, nudge, and at-risk metrics plus recent activity.
9. **Integrations** - Connected and available third-party tools.
10. **Settings** - Profile information, notifications, workflow duration, appearance, and reset controls.

## 3. Work Completed So Far

### Application shell and visual system

- Created the Flutter entry point in `lib/main.dart`.
- Added a Material 3 `ThemeData` configuration with a seeded purple color scheme.
- Standardized primary and outlined button styling, padding, border radius, and typography weights.
- Added responsive layout branching based on `MediaQuery` width.
- Added a reusable `NavigationItem` model and `Sidebar` widget.
- Added scrollable content surfaces so feature pages can accommodate different screen sizes.

### Dashboard

- Added headline KPI cards for new hires, completed onboarding, average progress, and overdue tasks.
- Added an onboarding pipeline summary.
- Added a manager action center with follow-ups, at-risk employees, and weekly activity.
- Added employee selection state and reusable employee profile/task detail components.
- Added maintenance notification presentation.

### Employee management

- Added a local employee directory with sample employees from Engineering, Marketing, Sales, and HR.
- Added status filters for All, In Progress, At Risk, and Completed.
- Added progress bars, status colors, initials avatars, and due-today counts.
- Added a profile panel showing progress and example current/upcoming tasks.

### Task and template workflow

- Added a task board grouped by operational status.
- Added reusable template cards with department badges, task counts, descriptions, and dates.
- Added a two-step Create Template dialog:
  - Step 1 collects template name, department, and description.
  - Step 2 allows tasks to be added and removed.
- Added a task creation dialog with:
  - Required title validation.
  - Due-days-after-hire slider and numeric input from 1 to 90 days.
  - Optional document link.
  - All-department or selected-department assignment.
- Newly created templates are appended to the in-memory template list during the current app session.

### Approvals and journey tracking

- Added approval summary cards for pending, in-review, approved, and needs-action items.
- Added approval filters and status/priority visual treatment.
- Added an employee selector for the onboarding journey.
- Added a timeline with Pre-onboarding, Day 1, Week 1, and Week 2 phases.
- Added calculated completion percentage and completed/in-progress/pending metrics.

### Communication, insights, and integrations

- Added announcement cards with audience, timing, summary, and priority.
- Added report metric cards and a recent activity feed.
- Added an integration hub separating connected services from available services.
- Added sample integration states for Slack, Google Workspace, Microsoft Teams, Zapier, Jira, and GitHub.

### Settings

- Added static profile/account information.
- Added local notification toggles for email, Slack, and weekly digest.
- Added a configurable default onboarding duration.
- Added a local theme preference selector.
- Added a danger-zone reset button placeholder.

## 4. Architecture and Techniques Used

### Current architecture

The app uses a simple feature-by-screen Flutter architecture:

```text
main.dart
  -> MyApp / MaterialApp / ThemeData
  -> Dashboard navigation shell
     -> DashboardScreen
     -> EmployeesScreen
     -> TasksScreen
     -> TemplatesScreen
     -> ApprovalWorkflowScreen
     -> EmployeeJourneyScreen
     -> AnnouncementsScreen
     -> ReportsScreen
     -> IntegrationHubScreen
     -> SettingsScreen
```

Each feature is implemented as a separate Dart file under `lib/screens/`. Reusable UI and form pieces are kept beside the related feature, such as `EmployeeProfilePanel`, `TaskDetailsSection`, `CreateTemplateDialog`, and `TaskCreationForm`.

### State management

- Stateless screens are used for views that only render fixed sample data.
- Stateful widgets are used where local interaction is needed.
- State is held in widget fields and updated with `setState`.
- Parent-child communication uses callbacks, for example `onTemplateCreated` and `onTaskCreated`.
- There is currently no Provider, Riverpod, Bloc, Redux, or other application-wide state-management layer.

### Data approach

- Data is represented by small Dart model classes such as `EmployeeDirectoryItem`, `TemplateData`, `TaskTemplate`, `ApprovalItem`, and `JourneyStep`.
- Most sample lists are constructed inside the screen's `build` method or initialized in `initState`.
- IDs and dates created by forms are generated locally with `DateTime.now()`.
- Data is not persisted when the app closes or restarts.

### UI and responsive techniques

- Material widgets provide the base controls and accessibility behavior.
- `LayoutBuilder`, `Wrap`, `Expanded`, `SingleChildScrollView`, and width breakpoints are used for responsive layouts.
- Cards, chips, badges, progress indicators, dropdowns, dialogs, sliders, checkboxes, switches, and bottom navigation communicate workflow state.
- Color-coded states are used consistently: green for complete/success, blue for in-progress/information, amber for attention, red for risk or destructive actions, and purple for primary navigation.

## 5. Current Behavior Boundaries

The following items are visually represented or partially interactive but are not production implementations yet:

- No authentication, roles, permissions, or user session handling.
- No API client, backend service, database, or local persistence.
- No real employee, task, approval, announcement, report, or integration records.
- Most action buttons such as View profile, Open details, Mark Done, Connect, Manage, and approval actions have empty callbacks.
- Template editing is still marked TODO; deletion works only against the current in-memory list.
- The mobile menu button does not open a drawer.
- Settings changes update only the current widget state; the selected theme does not reconfigure the app theme.
- Integration statuses are sample values and do not perform OAuth, synchronization, or connection management.
- The default widget test is still the generated counter smoke test and does not match the current Team Sync UI.

## 6. Recommended Next Implementation Sequence

1. Replace screen-local sample data with shared domain models and repositories.
2. Decide on a backend and persistence strategy, then add authentication and role-based access.
3. Add an application state-management layer for employees, templates, tasks, approvals, settings, and loading/error states.
4. Implement real navigation routes and complete the currently empty callbacks.
5. Add persistence for settings and draft/template changes.
6. Add form validation, URL/date validation, confirmation dialogs, and error handling around real operations.
7. Replace the generated counter test with widget tests for navigation, employee filters, template creation, task validation, and settings toggles.
8. Add integration tests for API/database workflows and responsive smoke tests for desktop and mobile layouts.
9. Review accessibility, keyboard navigation, semantics labels, and localization before release.

## 7. Development Commands

From the project root:

```text
flutter pub get
flutter analyze
flutter test
flutter run
```

To open the project in Android Studio from a terminal where the `studio` command is available:

```text
studio .
```
