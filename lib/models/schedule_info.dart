class ScheduleInfo {
  final String title;
  final DateTime starting;
  final Duration length;
  final String url;

  const ScheduleInfo({
    required this.title,
    required this.url,
    required this.starting,
    required this.length,
  });

  DateTime get ending => starting.add(length);
}
