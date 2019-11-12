import 'dart:math';

import 'package:ioc/ioc.dart';

@Singleton()
class UserService {
  int temp = Random.secure().nextInt(10000);
}
