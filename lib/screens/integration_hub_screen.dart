import 'package:flutter/material.dart';

class IntegrationHubScreen extends StatefulWidget {
  const IntegrationHubScreen({super.key});

  @override
  State<IntegrationHubScreen> createState() => _IntegrationHubScreenState();
}

class _IntegrationHubScreenState extends State<IntegrationHubScreen> {
  final integrations = [
    IntegrationItem(
      name: 'Slack',
      description: 'Send onboarding notifications and updates to Slack',
      icon: '💬',
      status: 'Connected',
      isConnected: true,
      lastSync: 'Synced 2 hours ago',
    ),
    IntegrationItem(
      name: 'Google Workspace',
      description: 'Sync employee accounts and manage access',
      icon: '🔐',
      status: 'Connected',
      isConnected: true,
      lastSync: 'Synced 1 hour ago',
    ),
    IntegrationItem(
      name: 'Microsoft Teams',
      description: 'Enable Teams integration for team communication',
      icon: '👥',
      status: 'Available',
      isConnected: false,
      lastSync: null,
    ),
    IntegrationItem(
      name: 'Zapier',
      description: 'Create workflows to automate onboarding tasks',
      icon: '⚡',
      status: 'Available',
      isConnected: false,
      lastSync: null,
    ),
    IntegrationItem(
      name: 'Jira',
      description: 'Link onboarding tasks to project management',
      icon: '📋',
      status: 'Available',
      isConnected: false,
      lastSync: null,
    ),
    IntegrationItem(
      name: 'GitHub',
      description: 'Automate developer onboarding and access grants',
      icon: '🐙',
      status: 'Available',
      isConnected: false,
      lastSync: null,
    ),
  ];

  void _connect(IntegrationItem item) {
    setState(() {
      item.isConnected = true;
      item.status = 'Connected';
      item.lastSync = 'Synced just now';
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Connected ${item.name}')));
  }

  void _disconnect(IntegrationItem item) {
    setState(() {
      item.isConnected = false;
      item.status = 'Available';
      item.lastSync = null;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Disconnected ${item.name}')));
  }

  void _manage(IntegrationItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Text(item.lastSync ?? 'No sync activity yet.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _disconnect(item);
            },
            child: const Text('Disconnect'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _learnMore(IntegrationItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Text(item.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connected = integrations.where((i) => i.isConnected).toList();
    final available = integrations.where((i) => !i.isConnected).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Integration Hub',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Connect with external tools to enhance your onboarding workflow.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          // Quick Stats
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 1000
                  ? (constraints.maxWidth - 40) / 3
                  : (constraints.maxWidth - 24) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'Connected',
                      value: connected.length.toString(),
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'Available',
                      value: available.length.toString(),
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth.clamp(140.0, 220.0),
                    child: _QuickStatCard(
                      label: 'Total',
                      value: integrations.length.toString(),
                      color: const Color(0xFF6B46C1),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          // Connected Integrations
          if (connected.isNotEmpty) ...[
            Text(
              'Connected Integrations',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            ...connected.map(
              (item) => _IntegrationCard(
                item: item,
                onConnect: () => _connect(item),
                onManage: () => _manage(item),
                onLearnMore: () => _learnMore(item),
              ),
            ),
            const SizedBox(height: 28),
          ],
          // Available Integrations
          Text(
            'Available Integrations',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          ...available.map(
            (item) => _IntegrationCard(
              item: item,
              onConnect: () => _connect(item),
              onManage: () => _manage(item),
              onLearnMore: () => _learnMore(item),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntegrationCard extends StatelessWidget {
  final IntegrationItem item;
  final VoidCallback onConnect;
  final VoidCallback onManage;
  final VoidCallback onLearnMore;

  const _IntegrationCard({
    required this.item,
    required this.onConnect,
    required this.onManage,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: item.isConnected
            ? const Color(0xFF10B981).withAlpha(13)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: item.isConnected
              ? const Color(0xFF10B981).withAlpha(51)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(item.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: item.isConnected
                      ? const Color(0xFF10B981).withAlpha(26)
                      : const Color(0xFFF59E0B).withAlpha(26),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: item.isConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          if (item.isConnected && item.lastSync != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 6),
                Text(
                  item.lastSync!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              if (item.isConnected)
                OutlinedButton(onPressed: onManage, child: const Text('Manage'))
              else
                ElevatedButton(
                  onPressed: onConnect,
                  child: const Text('Connect'),
                ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: onLearnMore,
                child: const Text('Learn more'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IntegrationItem {
  final String name;
  final String description;
  final String icon;
  String status;
  bool isConnected;
  String? lastSync;

  IntegrationItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.status,
    required this.isConnected,
    required this.lastSync,
  });
}
