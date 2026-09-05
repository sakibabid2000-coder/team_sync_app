import 'package:flutter/material.dart';

import 'screens/announcements_screen.dart';
import 'screens/approval_workflow_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/employee_journey_screen.dart';
import 'screens/employees_screen.dart';
import 'screens/integration_hub_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/templates_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Sync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B46C1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF6B46C1),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF6B46C1),
            side: const BorderSide(color: Color(0xFF6B46C1), width: 1.2),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.dashboard, label: 'Dashboard', index: 0),
    NavigationItem(icon: Icons.people, label: 'Employees', index: 1),
    NavigationItem(icon: Icons.task_alt, label: 'Tasks', index: 2),
    NavigationItem(icon: Icons.description, label: 'Templates', index: 3),
    NavigationItem(icon: Icons.approval, label: 'Approvals', index: 4),
    NavigationItem(icon: Icons.person_outline, label: 'Journey', index: 5),
    NavigationItem(icon: Icons.announcement, label: 'Announcements', index: 6),
    NavigationItem(icon: Icons.assessment, label: 'Reports', index: 7),
    NavigationItem(
      icon: Icons.integration_instructions,
      label: 'Integrations',
      index: 8,
    ),
    NavigationItem(icon: Icons.settings, label: 'Settings', index: 9),
  ];

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const EmployeesScreen();
      case 2:
        return const TasksScreen();
      case 3:
        return const TemplatesScreen();
      case 4:
        return const ApprovalWorkflowScreen();
      case 5:
        return const EmployeeJourneyScreen();
      case 6:
        return const AnnouncementsScreen();
      case 7:
        return const ReportsScreen();
      case 8:
        return const IntegrationHubScreen();
      case 9:
        return const SettingsScreen();
      default:
        return Container(
          color: Colors.grey[50],
          child: Center(
            child: Text(
              'Content for ${_navigationItems[index].label}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWebView = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      key: _scaffoldKey,
      drawer: !isWebView
          ? Drawer(
              width: 220,
              child: Sidebar(
                items: _navigationItems,
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() => _selectedIndex = index);
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar for web view
          if (isWebView)
            Sidebar(
              items: _navigationItems,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          // Main content area
          Expanded(
            child: Column(
              children: [
                // Header/Top bar
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isWebView)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      Text(
                        _navigationItems[_selectedIndex].label,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                // Content area
                Expanded(child: _buildContent(_selectedIndex)),
              ],
            ),
          ),
        ],
      ),
      // Bottom navigation for mobile view
      bottomNavigationBar: !isWebView
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
              },
              type: BottomNavigationBarType.fixed,
              items: _navigationItems
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}

// Navigation Item Model
class NavigationItem {
  final IconData icon;
  final String label;
  final int index;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}

// Sidebar Widget
class Sidebar extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF4C3A8F), // Dark purple from UI
      child: Column(
        children: [
          // Logo/Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.people, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Team Sync',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                bool isSelected = selectedIndex == item.index;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withAlpha(51)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () => onItemSelected(item.index),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white24),
          // User Profile at bottom
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sarah Johnson',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'HR Manager',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
