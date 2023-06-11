import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_last_lab/controller/user_controller.dart';
import 'package:get/get.dart';

import '../model/model.dart';
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserController userController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final _controllerLogin = TextEditingController();
  final _controllerPassword = TextEditingController();

  Future<bool> checkPassword(String password, String login) async {
    User? user = await User().select().login.equals(login).toSingle();
    if (user == null) {
      return false;
    } else {
      String? passwordFromDb = user.password;
      var bytes = utf8.encode(password);
      var digest = sha256.convert(bytes);
      print('pas:${digest.toString()}');
      print('pasfromDb:${passwordFromDb}');
      if (passwordFromDb?.compareTo(digest.toString()) != 0) {
        print('Не прошел');
        return false;
      } else {
        print('Прошел');
        userController.setUser(user);
        return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Логин')),
        body: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Authorization',
                  style: TextStyle(fontSize: 26),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerLogin,
                  decoration: InputDecoration(labelText: 'Login'),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please input login';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: true, //Скрытие текста
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please input password';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(145, 35),
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (await checkPassword(_controllerPassword.text, _controllerLogin.text)) {
                        Get.offNamed('/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Account not found',
                            style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    }

                    // if (_formKey.currentState!.validate()){
                    //   Get.toNamed('/home');
                    //     // print('Click');
                    //     // if (await checkPassword(_controllerPassword.text, _controllerLogin.text)) {
                    //     //   print('Переход на home screen');
                    //     //   Get.toNamed('/home');
                    //     // }
                    //     // else {
                    //     //   print('Not login');
                    //     // }
                    //   }
                    // else{
                    //   print('notClick');
                    //   return;
                    // }
                    //TODO
                  },
                  child: const Text('Sign in'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(145, 35),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    //TODO
                    Get.toNamed('/registration');
                  },
                  child: const Text('Registration'),
                )
              ],
            ),
          ),
        ));
  }
}
