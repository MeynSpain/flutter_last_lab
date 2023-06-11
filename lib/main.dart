import 'package:flutter/material.dart';
import 'package:flutter_last_lab/controller/user_controller.dart';
import 'package:flutter_last_lab/screens/home_screen.dart';
import 'package:flutter_last_lab/screens/login_screen.dart';
import 'package:flutter_last_lab/screens/registration_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
            name: '/registration',
            page: () => RegistrationScreen()
        ),
        GetPage(
            name: '/home',
            page: () => HomeScreen()
        ),
      ],
    );
  }
}
