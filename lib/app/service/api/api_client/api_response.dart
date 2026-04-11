class ApiResponse {
  final bool status;
  final int statusCode;
  final String message;
  final Map<String, dynamic> data;

  const ApiResponse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }
}
