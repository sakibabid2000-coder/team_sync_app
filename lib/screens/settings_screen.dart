import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotifications = true;
  bool _slackNotifications = false;
  bool _weeklyDigest = true;
  String _onboardingDuration = '30days';
  String _theme = 'light';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Preferences',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your account, notifications, and onboarding workflow settings.',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 32),
          // Profile Section
          _buildSection('Profile & Account', [
            _buildSettingItem(
              label: 'Account Email',
              value: 'alex.carter@company.com',
              icon: Icons.email,
            ),
            _buildSettingItem(
              label: 'Account Role',
              value: 'HR Administrator',
              icon: Icons.person,
            ),
            _buildSettingItem(
              label: 'Organization',
              value: 'Acme Corp',
              icon: Icons.business,
            ),
          ]),
          const SizedBox(height: 28),
          // Notifications Section
          _buildSection('Notifications', [
            _buildToggleSetting(
              label: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
              },
            ),
            _buildToggleSetting(
              label: 'Slack Notifications',
              subtitle: 'Send alerts to Slack workspace',
              value: _slackNotifications,
              onChanged: (value) {
                setState(() => _slackNotifications = value);
              },
            ),
            _buildToggleSetting(
              label: 'Weekly Digest',
              subtitle: 'Sunday 9:00 AM onboarding summary',
              value: _weeklyDigest,
              onChanged: (value) {
                setState(() => _weeklyDigest = value);
              },
            ),
          ]),
          const SizedBox(height: 28),
          // Onboarding Workflow Section
          _buildSection('Onboarding Workflow', [
            _buildDropdownSetting(
              label: 'Standard Duration',
              value: _onboardingDuration,
              options: const {
                '7days': '7 days',
                '14days': '14 days',
                '30days': '30 days',
                '60days': '60 days',
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() => _onboardingDuration = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withAlpha(13),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withAlpha(51),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Color(0xFF3B82F6), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This duration is used as the default for new onboarding templates.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 28),
          // Appearance Section
          _buildSection('Appearance', [
            _buildDropdownSetting(
              label: 'Theme',
              value: _theme,
              options: const {
                'light': 'Light',
                'dark': 'Dark',
                'auto': 'Auto (System)',
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() => _theme = value);
                }
              },
            ),
          ]),
          const SizedBox(height: 28),
          // Danger Zone
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withAlpha(13),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEF4444).withAlpha(51)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                    onPressed: () {},
                    child: const Text('Reset All Settings to Default'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(
            children.length,
            (index) => Column(
              children: [
                children[index],
                if (index < children.length - 1)
                  Divider(height: 16, color: Colors.grey[200]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleSetting({
    required String label,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF6B46C1),
        ),
      ],
    );
  }

  Widget _buildDropdownSetting({
    required String label,
    required String value,
    required Map<String, String> options,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: options.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
