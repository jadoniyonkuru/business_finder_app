import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/language_selector.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: localizations.language,
            children: [const LanguageSelector()],
          ),
          _buildSection(
            context,
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  context.read<AuthProvider>().signOut();
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: localizations.appPreferences,
            children: [
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme'),
                    value: settings.isDarkMode,
                    onChanged: (val) => settings.toggleDarkMode(),
                  );
                },
              ),
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Enable push notifications'),
                    value: settings.notificationsEnabled,
                    onChanged: (val) => settings.toggleNotifications(),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: localizations.arSettings,
            children: [
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return SwitchListTile(
                    title: const Text('Show Distance'),
                    subtitle: const Text('Show distance to businesses'),
                    value: settings.showDistance,
                    onChanged: (val) => settings.toggleShowDistance(),
                  );
                },
              ),
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return SwitchListTile(
                    title: const Text('Auto-filter'),
                    subtitle: const Text('Only show businesses within max distance'),
                    value: settings.autoFilter,
                    onChanged: (val) => settings.toggleAutoFilter(),
                  );
                },
              ),
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return ListTile(
                    title: const Text('Maximum Distance'),
                    subtitle: Text('${settings.maxDistance.toStringAsFixed(1)} km'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showDistanceDialog(context, settings),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: localizations.about,
            children: [
              const ListTile(
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              const ListTile(
                title: Text('Build'),
                subtitle: Text('2023.04.15'),
              ),
              ListTile(
                title: const Text('Report an Issue'),
                leading: const Icon(Icons.bug_report),
                onTap: () {
                  // TODO: Implement issue reporting
                },
              ),
              ListTile(
                title: const Text('View Tutorial'),
                leading: const Icon(Icons.help),
                onTap: () {
                  // TODO: Implement tutorial
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  void _showDistanceDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) {
        double selectedDistance = settings.maxDistance;
        return AlertDialog(
          title: const Text('Maximum Distance'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: selectedDistance,
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    label: '${selectedDistance.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setState(() => selectedDistance = value);
                    },
                  ),
                  Text('${selectedDistance.toStringAsFixed(1)} km'),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                settings.setMaxDistance(selectedDistance);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
} 