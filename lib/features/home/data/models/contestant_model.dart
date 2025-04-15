import 'lyrics_model.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'artist': artist,
      'song': song,
      'url': url,
      'lyrics': lyrics?.map((e) => e?.toJson()).toList(),
      'videoUrls': videoUrls,
      'dancers': dancers,
      'backings': backings,
      'composers': composers,
      'lyricists': lyricists,
      'writers': writers,
      'conductor': conductor,
      'stageDirector': stageDirector,
      'tone': tone,
      'bpm': bpm,
      'broadcaster': broadcaster,
      'spokesperson': spokesperson,
      'commentators': commentators,
    };
  }

  ContestantModel copyWith({
    String? country,
    String? artist,
    String? song,
    String? url,
    List<LyricsModel?>? lyrics,
    List<String?>? videoUrls,
    List<String?>? dancers,
    List<String?>? backings,
    List<String?>? composers,
    List<String?>? lyricists,
    List<String?>? writers,
    String? conductor,
    String? stageDirector,
    String? tone,
    int? bpm,
    String? broadcaster,
    String? spokesperson,
    List<String?>? commentators,
  }) {
    return ContestantModel(
      id: id,
      country: country ?? this.country,
      artist: artist ?? this.artist,
      song: song ?? this.song,
      url: url ?? this.url,
      lyrics: lyrics ?? this.lyrics,
      videoUrls: videoUrls ?? this.videoUrls,
      dancers: dancers ?? this.dancers,
      backings: backings ?? this.backings,
      composers: composers ?? this.composers,
      lyricists: lyricists ?? this.lyricists,
      writers: writers ?? this.writers,
      conductor: conductor ?? this.conductor,
      stageDirector: stageDirector ?? this.stageDirector,
      tone: tone ?? this.tone,
      bpm: bpm ?? this.bpm,
      broadcaster: broadcaster ?? this.broadcaster,
      spokesperson: spokesperson ?? this.spokesperson,
      commentators: commentators ?? this.commentators,
    );
  }
}
