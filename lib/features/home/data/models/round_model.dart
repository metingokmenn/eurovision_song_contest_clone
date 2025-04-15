import 'performance_model.dart';

class RoundModel {
  final String? name;
  final String? date;
  final String? time;
  final List<PerformanceModel?>? performances;
  final List<int?>? disqualifieds;

  RoundModel({
    this.name,
    this.date,
    this.time,
    this.performances,
    this.disqualifieds,
  });

  factory RoundModel.fromJson(Map<String, dynamic> json) {
    return RoundModel(
      name: json['name'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      performances: json['performances'] != null
          ? (json['performances'] as List)
              .map((e) => PerformanceModel.fromJson(e))
              .toList()
          : null,
      disqualifieds: json['disqualifieds'] != null
          ? List<int>.from(json['disqualifieds'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'performances': performances?.map((e) => e?.toJson()).toList(),
      'disqualifieds': disqualifieds,
    };
  }
}
