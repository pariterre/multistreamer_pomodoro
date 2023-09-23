class StreamerInfo {
  final String name;
  final String url;
  final DateTime starting;
  final Duration length;

  const StreamerInfo({
    required this.name,
    required this.url,
    required this.starting,
    required this.length,
  });

  DateTime get ending => starting.add(length);
}
