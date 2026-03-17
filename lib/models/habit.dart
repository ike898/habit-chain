class Habit {
  final String id;
  final String name;
  final String? emoji;
  final int colorValue;
  final DateTime createdAt;
  final Set<DateTime> completedDates;

  Habit({
    required this.id,
    required this.name,
    this.emoji,
    this.colorValue = 0xFF4CAF50,
    required this.createdAt,
    Set<DateTime>? completedDates,
  }) : completedDates = completedDates ?? {};

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    int streak = 0;
    var check = DateTime.now();
    // Allow today to be incomplete
    final today = _dateOnly(check);
    if (completedDates.contains(today)) {
      streak = 1;
      check = check.subtract(const Duration(days: 1));
    }
    while (true) {
      final day = _dateOnly(check);
      if (completedDates.contains(day)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  int get longestStreak {
    if (completedDates.isEmpty) return 0;
    final sorted = completedDates.toList()..sort();
    int longest = 1;
    int current = 1;
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }
    return longest;
  }

  bool isCompletedToday() {
    return completedDates.contains(_dateOnly(DateTime.now()));
  }

  double get completionRate {
    if (completedDates.isEmpty) return 0;
    final daysSinceCreation =
        DateTime.now().difference(createdAt).inDays + 1;
    return completedDates.length / daysSinceCreation;
  }

  Habit copyWith({
    String? name,
    String? emoji,
    int? colorValue,
    Set<DateTime>? completedDates,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'colorValue': colorValue,
        'createdAt': createdAt.toIso8601String(),
        'completedDates':
            completedDates.map((d) => d.toIso8601String()).toList(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String?,
        colorValue: json['colorValue'] as int? ?? 0xFF4CAF50,
        createdAt: DateTime.parse(json['createdAt'] as String),
        completedDates: (json['completedDates'] as List?)
                ?.map((e) => DateTime.parse(e as String))
                .toSet() ??
            {},
      );

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
