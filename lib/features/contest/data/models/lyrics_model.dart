class LyricsModel {
  final List<String>? languages;
  final String? title;
  final String? content;

  LyricsModel({
    this.languages,
    this.title,
    this.content,
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      languages: json['languages'] != null
          ? List<String>.from(json['languages'] as List)
          : null,
      title: json['title'] as String?,
      content: json['content'] as String?,
    );
  }
}
