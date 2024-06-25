abstract class BaseException implements Exception {
  const BaseException({
    required this.message,
    this.stackTracing,
  });

  final String message;
  final dynamic stackTracing;
}
