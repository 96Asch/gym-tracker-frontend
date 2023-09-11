enum MessageType {
  error,
  warning,
  completion,
}

class AppMessage {
  final String message;
  final MessageType type;

  const AppMessage({required this.message, required this.type});
}
