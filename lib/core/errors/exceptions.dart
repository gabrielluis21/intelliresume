import 'package:meta/meta.dart';

/// Base class for all custom exceptions in the app.
@immutable
abstract class AppException implements Exception {
  final String key;
  final List<Object>? args;

  const AppException({required this.key, this.args});

  @override
  String toString() {
    return 'AppException(key: $key, args: $args)';
  }
}

/// Generic exception for data source failures.
class DataSourceException extends AppException {
  const DataSourceException({super.key = 'error_data_source', super.args});
}

/// Thrown when a requested entity is not found in the data source.
class NotFoundException extends DataSourceException {
  const NotFoundException({super.key = 'error_not_found', super.args});
}

/// Thrown on authentication failures.
class AuthException extends AppException {
  const AuthException({required super.key, super.args});
}

/// Thrown on AI service failures.
class AIServiceException extends AppException {
  const AIServiceException({required super.key, super.args});
}

/// Thrown on payment processing failures.
class PaymentException extends AppException {
  const PaymentException({required super.key, super.args});
}
