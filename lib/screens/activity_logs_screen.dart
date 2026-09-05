import 'package:flutter/material.dart';
import '../screens/app_state.dart';

class ActivityLogsScreen extends StatefulWidget {
  const ActivityLogsScreen({super.key});

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  final state = AppState.instance;

  @override
  void initState() {
    super.initState();
    state.addListener(_rebuild);
  }

  @override
  void dispose() {
    state.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final logs = state.activityLogs;

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Activity Logs', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Complete audit history of system actions, updates, and task completions.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: logs.isEmpty
                  ? const Center(child: Text('No activity recorded yet.'))
                  : ListView.separated(
                      itemCount: logs.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFEAE6F8),
                            child: Icon(Icons.history, color: Color(0xFF6B46C1)),
                          ),
                          title: Text('${log.action} — ${log.actor}'),
                          subtitle: Text(log.details),
                          trailing: Text(
                            '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}