import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Notifications', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: SwitchListTile(
            title: const Text('Daily Reminder'),
            subtitle: const Text('Remind to check off habits'),
            value: true,
            onChanged: (_) {},
          ),
        ),
        const SizedBox(height: 24),
        Text('Premium', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upgrade to Premium',
                          style: theme.textTheme.titleSmall),
                      Text('No ads, unlimited habits, custom colors',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Text('\$2.99',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: theme.colorScheme.primary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('About', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Version'),
                trailing: Text('1.0.0'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
