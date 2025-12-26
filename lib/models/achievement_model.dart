class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final int requiredDays;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.requiredDays,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      iconPath: map['icon'] ?? '🏆',
      requiredDays: map['requiredDays'] ?? 0,
      isUnlocked: map['isUnlocked'] ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? (map['unlockedAt'] as dynamic).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': iconPath,
      'requiredDays': requiredDays,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt,
    };
  }

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? iconPath,
    int? requiredDays,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      requiredDays: requiredDays ?? this.requiredDays,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}