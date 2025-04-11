import 'score_model.dart';

class PerformanceModel {
  final int? contestantId;
  final int? running;
  final int? place;
  final List<ScoreModel>? scores;

  PerformanceModel({
    this.contestantId,
    this.running,
    this.place,
    this.scores,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      contestantId: json['contestantId'] as int?,
      running: json['running'] as int?,
      place: json['place'] as int?,
      scores:
          (json['scores'] as List).map((e) => ScoreModel.fromJson(e)).toList(),
    );
  }
}
