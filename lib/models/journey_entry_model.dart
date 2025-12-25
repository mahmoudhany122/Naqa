class JourneyEntryModel {
  final String text;
  final DateTime timestamp;

  JourneyEntryModel({
    required this.text,
    required this.timestamp,
  });

  factory JourneyEntryModel.fromJson(Map<String, dynamic> json) {
    return JourneyEntryModel(
      text: json['text'] ?? '',
      timestamp: (json['timestamp'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp,
    };
  }
}