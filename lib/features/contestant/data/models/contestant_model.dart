import '../../../contest/data/models/lyrics_model.dart';

class ContestantModel {
  final int id;
  final String? country;
  final String? artist;
  final String? song;
  final String? url;
  final List<LyricsModel?>? lyrics;
  final List<String?>? videoUrls;
  final List<String?>? dancers;
  final List<String?>? backings;
  final List<String?>? composers;
  final List<String?>? lyricists;
  final List<String?>? writers;
  final String? conductor;
  final String? stageDirector;
  final String? tone;
  final int? bpm;
  final String? broadcaster;
  final String? spokesperson;
  final List<String?>? commentators;

  ContestantModel({
    required this.id,
    this.country,
    this.artist,
    this.song,
    this.url,
    this.lyrics,
    this.videoUrls,
    this.dancers,
    this.backings,
    this.composers,
    this.lyricists,
    this.writers,
    this.conductor,
    this.stageDirector,
    this.tone,
    this.bpm,
    this.broadcaster,
    this.spokesperson,
    this.commentators,
  });

  factory ContestantModel.fromJson(Map<String, dynamic> json) {
    return ContestantModel(
      id: json['id'] as int,
      country: json['country'] as String?,
      artist: json['artist'] as String?,
      song: json['song'] as String?,
      url: json['url'] as String?,
      lyrics: json['lyrics'] != null
          ? List<LyricsModel>.from((json['lyrics'] as List)
              .map((e) => LyricsModel.fromJson(e as Map<String, dynamic>)))
          : null,
      videoUrls: json['videoUrls'] != null
          ? List<String>.from(json['videoUrls'] as List)
          : null,
      dancers: json['dancers'] != null
          ? List<String>.from(json['dancers'] as List)
          : null,
      backings: json['backings'] != null
          ? List<String>.from(json['backings'] as List)
          : null,
      composers: json['composers'] != null
          ? List<String>.from(json['composers'] as List)
          : null,
      lyricists: json['lyricists'] != null
          ? List<String>.from(json['lyricists'] as List)
          : null,
      writers: json['writers'] != null
          ? List<String>.from(json['writers'] as List)
          : null,
      conductor: json['conductor'] as String?,
      stageDirector: json['stageDirector'] as String?,
      tone: json['tone'] as String?,
      bpm: json['bpm'] as int?,
      broadcaster: json['broadcaster'] as String?,
      spokesperson: json['spokesperson'] as String?,
      commentators: json['commentators'] != null
          ? List<String>.from(json['commentators'] as List)
          : null,
    );
  }
}
