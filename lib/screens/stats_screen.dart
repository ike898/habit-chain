import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../widgets/banner_ad_widget.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(child: habitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (habits) {
        if (habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bar_chart, size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text('Add habits to see your stats',
                    style: theme.textTheme.bodyLarge),
              ],
            ),
          );
        }

        final totalCompleted =
            habits.fold<int>(0, (sum, h) => sum + h.completedDates.length);
        final bestStreak =
            habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b);
        final todayCount =
            habits.where((h) => h.isCompletedToday()).length;
        final avgRate = habits.isEmpty
            ? 0.0
            : habits.fold<double>(0, (sum, h) => sum + h.completionRate) /
                habits.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatCard(
                    label: 'Today',
                    value: '$todayCount/${habits.length}',
                    icon: Icons.today,
                    theme: theme,
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    label: 'Total',
                    value: '$totalCompleted',
                    icon: Icons.check_circle,
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _StatCard(
                    label: 'Best Streak',
                    value: '$bestStreak days',
                    icon: Icons.local_fire_department,
                    theme: theme,
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    label: 'Avg Rate',
                    value: '${(avgRate * 100).toStringAsFixed(0)}%',
                    icon: Icons.trending_up,
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Per Habit', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...habits.map((h) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(h.colorValue),
                        child: Text(
                          h.emoji ?? h.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(h.name),
                      subtitle: Text(
                          'Streak: ${h.currentStreak}d | Best: ${h.longestStreak}d | Rate: ${(h.completionRate * 100).toStringAsFixed(0)}%'),
                    ),
                  )),
            ],
          ),
        );
      },
    )),
        const BannerAdWidget(),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(value,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
