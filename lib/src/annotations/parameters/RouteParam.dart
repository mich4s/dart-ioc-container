import 'package:ioc/src/annotations/parameters/ActionParam.dart';

class RouteParam extends ActionParam {
  final String name;
  final Type type;

  const RouteParam(this.name, {this.type = String});

  @override
  perform({
    Map<String, String> routeParams,
    Map<String, dynamic> requestBody,
  }) {
    String paramValue = routeParams[this.name];
    switch (this.type) {
      case String:
        return '$paramValue';
        break;
      case int:
        return int.tryParse('$paramValue', radix: 10);
        break;
      default:
        throw FormatException();
    }
  }
}
