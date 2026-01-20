class VideoModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  const VideoModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      site: json['site'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'site': site,
      'type': type,
    };
  }

  bool get isYouTubeTrailer => site.toLowerCase() == 'youtube' && type.toLowerCase() == 'trailer';
  bool get isYouTubeVideo => site.toLowerCase() == 'youtube';
}