/// A simple in-memory activity log shared across the app.
///
/// Matches the proposal's "Activity Logs" requirement (Phase 5): a history
/// log showing exactly when an employee checked off a task. Entries reset
/// on app restart, consistent with the rest of the app's in-memory data.
class ActivityLogEntry {
  final String description;
  final DateTime timestamp;

  ActivityLogEntry({required this.description, required this.timestamp});

  String get relativeTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    }
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }
}

class ActivityLogService {
  ActivityLogService._();

  static final List<ActivityLogEntry> _entries = [];

  static List<ActivityLogEntry> get entries => List.unmodifiable(_entries);

  static void log(String description) {
    _entries.insert(
      0,
      ActivityLogEntry(description: description, timestamp: DateTime.now()),
    );
  }

  static void logTaskCompletion({
    required String employeeName,
    required String taskTitle,
    String? note,
  }) {
    final suffix = (note != null && note.isNotEmpty) ? ' — "$note"' : '';
    log('$employeeName checked off "$taskTitle"$suffix');
  }

  static void logNudge(String employeeName) {
    log('Nudged $employeeName about their onboarding progress');
  }
}
