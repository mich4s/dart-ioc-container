import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class CreateRouteMapping {
  static CreateRouteMapping _instance = CreateRouteMapping._internal();
  Router app = Router();

  CreateRouteMapping._internal();

  factory CreateRouteMapping() {
    return CreateRouteMapping._instance;
  }

  void mapRequest(String method, String url, Function callback) {
    this.app.add(method.toUpperCase(), url, callback);
  }

  void serve() async {
    var server = await io.serve(app.handler, 'localhost', 3000);
  }
}
