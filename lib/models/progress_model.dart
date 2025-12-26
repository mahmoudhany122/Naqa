class ProgressModel {
  final String day;
  final int progress;

  // Constructor عادي (positional parameters)
  ProgressModel({required this.day, required this.progress});



  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      day: map['day'] ?? '',
      progress: map['progress'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'progress': progress,
    };
  }
}