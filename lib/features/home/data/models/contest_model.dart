import 'contestant_model.dart';
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
      presenters: json['presenters'] != null
          ? List<String>.from(json['presenters'] as List)
          : [],
      broadcasters: json['broadcasters'] != null
          ? List<String>.from(json['broadcasters'] as List)
          : [],
      contestants: json['contestants'] != null
          ? (json['contestants'] as List)
              .map((e) => e != null
                  ? ContestantModel.fromJson(e as Map<String, dynamic>)
                  : null)
              .toList()
          : [],
      rounds: json['rounds'] != null
          ? (json['rounds'] as List)
              .map((e) => e != null
                  ? RoundModel.fromJson(e as Map<String, dynamic>)
                  : null)
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'arena': arena,
      'city': city,
      'country': country,
      'intendedCountry': intendedCountry,
      'slogan': slogan,
      'logoUrl': logoUrl,
      'voting': voting,
      'presenters': presenters,
      'broadcasters': broadcasters,
      'contestants': contestants?.map((e) => e?.toJson()).toList(),
      'rounds': rounds?.map((e) => e?.toJson()).toList(),
    };
  }
}
