class ScoreModel {
  final String name;
  final int points;
  final Map<String, int> votes;

  ScoreModel({required this.name, required this.points, required this.votes});

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      name: json['name'] as String,
      points: json['points'] as int,
      votes: Map<String, int>.from(json['votes'] as Map),
    );
  }
}
