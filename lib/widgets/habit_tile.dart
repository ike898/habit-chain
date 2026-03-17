import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class HabitTile extends ConsumerWidget {
  final Habit habit;
  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final done = habit.isCompletedToday();
    final streak = habit.currentStreak;
    final color = Color(habit.colorValue);

    return Card(
      child: InkWell(
        onTap: () =>
            ref.read(habitsProvider.notifier).toggleToday(habit.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? color : Colors.transparent,
                  border: Border.all(
                    color: done ? color : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
              ),
              const SizedBox(width: 16),
              // Habit name + streak
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.emoji != null
                          ? '${habit.emoji} ${habit.name}'
                          : habit.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration:
                            done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (streak > 0)
                      Text(
                        '$streak day streak',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              // Chain visualization (last 7 days)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _buildChainDots(color, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChainDots(Color color, ThemeData theme) {
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final completed = habit.completedDates.contains(day);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? color : theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      );
    });
  }
}
