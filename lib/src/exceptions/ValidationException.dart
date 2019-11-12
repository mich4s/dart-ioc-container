import 'package:ioc/src/exceptions/CoreException.dart';

class ValidationException extends CoreException {
  int get code => 422;

  ValidationException(dynamic message) : super(message);
}
