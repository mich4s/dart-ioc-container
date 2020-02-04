import 'package:ioc/src/annotations/parameters/ActionParam.dart';
import 'package:shelf/shelf.dart' as prefix0;

class RouteParam extends ActionParam {
  final String name;
  final Type type;

  const RouteParam(this.name, {this.type = String});

  onExecute(prefix0.Request request, dynamic previousValue) {
    Map<String, String> parameters = request.context['shelf_router/params'];
    String value = parameters[this.name];
    switch(this.type) {
      case int: 
        return int.tryParse(value, radix: 10);
    }
    return 0;
  }
}
