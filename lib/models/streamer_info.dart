class StreamerInfo {
  final String name;
  final String description;
  final String twitchUrl;
  final String? presentationYoutubeId;
  final String? philosophyYoutubeId;

  StreamerInfo(
    this.name, {
    required this.description,
    required this.twitchUrl,
    this.presentationYoutubeId,
    this.philosophyYoutubeId,
  });
}
