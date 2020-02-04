import 'package:shelf/shelf.dart';

abstract class ActionParam {
  const ActionParam();

  dynamic onExecute(Request request, dynamic previousValue);
}
