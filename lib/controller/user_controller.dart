import 'package:get/get.dart';

import '../model/model.dart';

class UserController extends GetxController {
  late User _user;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    update();
  }

  Future<bool> saveUser() async {
    if (_user != null) {
      await _user.save();
      return true;
    }
    else {
      return false;
    }
  }
}