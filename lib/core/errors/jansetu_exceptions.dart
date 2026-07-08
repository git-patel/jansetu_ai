/// Base exception class for all JanSetu AI domain and infrastructure errors.
abstract class JanSetuException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const JanSetuException(this.message, {this.code, this.details});

  @override
  String toString() => 'JanSetuException [$code]: $message${details != null ? ' ($details)' : ''}';
}

/// Thrown when network connectivity fails or API requests time out.
class NetworkException extends JanSetuException {
  const NetworkException(super.message, {super.code = 'NETWORK_ERROR', super.details});
}

/// Thrown when local disk storage (SharedPreferences / Hive / SQLite) fails or corrupts.
class StorageException extends JanSetuException {
  const StorageException(super.message, {super.code = 'STORAGE_ERROR', super.details});
}

/// Thrown when authentication, session tokens, or e-Pramaan verification fails.
class AuthenticationException extends JanSetuException {
  const AuthenticationException(super.message, {super.code = 'AUTH_ERROR', super.details});
}

/// Thrown when a user attempts an action outside their jurisdictional or role permissions.
class PermissionException extends JanSetuException {
  const PermissionException(super.message, {super.code = 'PERMISSION_DENIED', super.details});
}

/// Thrown when input data validation fails (e.g. invalid ward polygon or empty title).
class ValidationException extends JanSetuException {
  const ValidationException(super.message, {super.code = 'VALIDATION_ERROR', super.details});
}

/// Thrown when Gemini AI inference or spatial routing encounters an processing failure.
class AiException extends JanSetuException {
  const AiException(super.message, {super.code = 'AI_INFERENCE_ERROR', super.details});
}

/// Thrown for unclassified or unexpected runtime exceptions.
class UnknownException extends JanSetuException {
  const UnknownException(super.message, {super.code = 'UNKNOWN_ERROR', super.details});
}
