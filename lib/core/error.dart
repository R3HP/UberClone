
class Error {
  final String message;
  Error({
    required this.message,
  });
  


  Error copyWith({
    String? message,
  }) {
    return Error(
      message: message ?? this.message,
    );
  }

  @override
  String toString() => 'Error(message: $message)';
}
