import 'dart:math';

import 'package:ioc/ioc.dart';

@Prototype()
class PrototypeService {
  int temp = Random.secure().nextInt(10000);
}
