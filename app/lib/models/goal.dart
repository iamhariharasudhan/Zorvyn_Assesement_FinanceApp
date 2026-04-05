enum GoalType { savings, noSpend, budgetLimit, savingStreak }

class Goal {
  final String id;
  final String name;
  final GoalType type;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdDate;
  final DateTime targetDate;
  final String description;
  final bool isActive;
  final int streakDays;

  Goal({
    required this.id,
    required this.name,
    required this.type,
    required this.targetAmount,
    required this.currentAmount,
    required this.createdDate,
    required this.targetDate,
    required this.description,
    required this.isActive,
    this.streakDays = 0,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      name: json['name'] as String,
      type: GoalType.values.byName(json['type'] as String),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      createdDate: DateTime.parse(json['createdDate'] as String),
      targetDate: DateTime.parse(json['targetDate'] as String),
      description: json['description'] as String,
      isActive: json['isActive'] as bool,
      streakDays: json['streakDays'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'createdDate': createdDate.toIso8601String(),
        'targetDate': targetDate.toIso8601String(),
        'description': description,
        'isActive': isActive,
        'streakDays': streakDays,
      };

  double get progressPercentage =>
      targetAmount > 0 ? (currentAmount / targetAmount * 100) : 0;

  bool get isCompleted => currentAmount >= targetAmount;

  Goal copyWith({
    String? id,
    String? name,
    GoalType? type,
    double? targetAmount,
    double? currentAmount,
    DateTime? createdDate,
    DateTime? targetDate,
    String? description,
    bool? isActive,
    int? streakDays,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      createdDate: createdDate ?? this.createdDate,
      targetDate: targetDate ?? this.targetDate,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}
