class CustomException implements Exception {
  String code;
  String message;

  CustomException({required this.code, required this.message});
}
