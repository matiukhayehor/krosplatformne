class Training {
  final int? id;
  final String type;
  final int duration;
  final DateTime date;
  final String emoji;

  Training({
    this.id,
    required this.type,
    required this.duration,
    required this.date,
    required this.emoji,
  });

  factory Training.fromMap(Map<String, dynamic> map) {
    return Training(
      id: map['id'] as int?,
      type: map['type'] ?? '',
      duration: map['duration'] is int ? map['duration'] : int.tryParse(map['duration'].toString()) ?? 0,
      date: DateTime.tryParse(map['date']) ?? DateTime.now(),
      emoji: map['emoji'] ?? '🏋️',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'duration': duration,
      'date': date.toIso8601String(),
      'emoji': emoji,
    };
  }
}