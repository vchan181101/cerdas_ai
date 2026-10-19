class ApiException implements Exception {
  final String message;
  final String? prefix;
  final int? statusCode;

  ApiException(this.message, {this.prefix, this.statusCode});

  @override
  String toString() {
    return "${prefix ?? ''}$message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException(super.message)
      : super(prefix: "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.statusCode})
      : super(prefix: "Invalid Request: ");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException(super.message, {super.statusCode})
      : super(prefix: "Unauthorised: ");
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.statusCode})
      : super(prefix: "Not Found: ");
}

class InternalServerException extends ApiException {
  InternalServerException(super.message, {super.statusCode})
      : super(prefix: "Internal Server Error: ");
}
