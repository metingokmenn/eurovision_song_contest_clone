import '../../../contestant/data/models/contestant_model.dart';
import 'round_model.dart';

class ContestModel {
  final int year;
  final String? arena;
  final String? city;
  final String? country;
  final String? intendedCountry;
  final String? slogan;
  final String? logoUrl;
  final String? voting;
  final List<String>? presenters;
  final List<String>? broadcasters;
  final List<ContestantModel?>? contestants;
  final List<RoundModel?>? rounds;

  ContestModel({
    required this.year,
    this.arena,
    this.city,
    this.country,
    this.intendedCountry,
    this.slogan,
    this.logoUrl,
    this.voting,
    this.presenters,
    this.broadcasters,
    this.contestants,
    this.rounds,
  });

  factory ContestModel.fromJson(Map<String, dynamic> json) {
    return ContestModel(
      year: json['year'] as int,
      arena: json['arena'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      intendedCountry: json['intendedCountry'] as String?,
      slogan: json['slogan'] as String?,
      logoUrl: json['logoUrl'] as String?,
      voting: json['voting'] as String?,
      presenters: List<String>.from(json['presenters'] as List),
      broadcasters: List<String>.from(json['broadcasters'] as List),
      contestants: (json['contestants'] as List)
          .map((e) => ContestantModel.fromJson(e))
          .toList(),
      rounds:
          (json['rounds'] as List).map((e) => RoundModel.fromJson(e)).toList(),
    );
  }
}
