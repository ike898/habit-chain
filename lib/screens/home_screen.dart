import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final theme = Theme.of(context);

    return habitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (habits) {
        if (habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link, size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text('Add your first habit to start building chains',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _showAddDialog(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Habit'),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: habits.length,
          itemBuilder: (context, index) => HabitTile(habit: habits[index]),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Exercise, Read, Meditate',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(habitsProvider.notifier).addHabit(name);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
