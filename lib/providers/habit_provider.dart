import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/habit.dart';

int _counter = 0;
String _generateId() =>
    '${DateTime.now().millisecondsSinceEpoch}_${++_counter}';

final habitsProvider =
    AsyncNotifierProvider<HabitsNotifier, List<Habit>>(HabitsNotifier.new);

class HabitsNotifier extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() => _load();

  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/habits.json');
  }

  Future<List<Habit>> _load() async {
    final file = await _file;
    if (!await file.exists()) return [];
    final json = jsonDecode(await file.readAsString()) as List;
    return json
        .map((e) => Habit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _save(List<Habit> habits) async {
    final file = await _file;
    await file.writeAsString(
        jsonEncode(habits.map((h) => h.toJson()).toList()));
  }

  Future<void> addHabit(String name, {String? emoji, int? colorValue}) async {
    final habit = Habit(
      id: _generateId(),
      name: name,
      emoji: emoji,
      colorValue: colorValue ?? 0xFF4CAF50,
      createdAt: DateTime.now(),
    );
    final current = [...?state.value, habit];
    state = AsyncData(current);
    await _save(current);
  }

  Future<void> toggleToday(String habitId) async {
    final current = state.value ?? [];
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final updated = current.map((h) {
      if (h.id != habitId) return h;
      final dates = Set<DateTime>.from(h.completedDates);
      if (dates.contains(today)) {
        dates.remove(today);
      } else {
        dates.add(today);
      }
      return h.copyWith(completedDates: dates);
    }).toList();
    state = AsyncData(updated);
    await _save(updated);
  }

  Future<void> deleteHabit(String id) async {
    final current = state.value?.where((h) => h.id != id).toList() ?? [];
    state = AsyncData(current);
    await _save(current);
  }

  Future<void> updateHabit(Habit updated) async {
    final current =
        state.value?.map((h) => h.id == updated.id ? updated : h).toList() ??
            [];
    state = AsyncData(current);
    await _save(current);
  }
}
