import 'package:ioc/src/annotations/parameters/validators/FieldValidation.dart';

class NotNull extends FieldValidation {
  const NotNull();

  @override
  bool validate(property) {
    return property != null;
  }
}
