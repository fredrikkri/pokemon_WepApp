class JokeData {
  final String value;

  JokeData({required this.value});

  factory JokeData.fromJson(Map<String, dynamic> json) {
    return JokeData(
      value: json['value'],
    );
  }
}
