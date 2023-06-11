import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_last_lab/model/model.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_last_lab/screens/Widgets/registation_form_widget.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllerLogin = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerMail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPasswordRepeat = TextEditingController();

  String _login = '';
  String _name = '';
  String _mail = '';
  String _password = '';
  String _repeatPassword = '';

  addRegistrationData(
      String login, String name, String mail, String password) async {
    User user = User();
    user.login = login;
    user.name = name;
    user.mail = mail;
    user.password = hashPassword(password);
    //Очистил таблицу после введения хеширования паролей
    // User().select().delete();
    await user.save();
  }

  Future<bool> getData() async {
    if (_formKey.currentState!.validate()) {
      _login = _controllerLogin.text.trim();
      _name = _controllerName.text;
      _mail = _controllerMail.text;
      _password = _controllerPassword.text;
      _repeatPassword = _controllerPasswordRepeat.text;

      if (!await isContains(_login)) {
        print('Save');
        addRegistrationData(_login, _name, _mail, _password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Account created',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          duration: const Duration(seconds: 3),
        ));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('The login is already occupied',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          duration: const Duration(seconds: 3),
        ));
        return false;
      }
    }
    else {
      return false;
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> isContains(value) async {
    var login = await User().select().login.equals(value).toSingle();
    print('LOGIN : $login');
    if (login == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isValidateEmail(String email) {
    final RegExp emailRegex = RegExp(
        '^([a-z0-9]+(?:[._-][a-z0-9]+)*)@([a-z0-9]+(?:[.-][a-z0-9]+)*\.[a-z]{2,})\$');
    return emailRegex.hasMatch(email);
  }

  bool isValidatePassword(String password) {
    final RegExp passwordRegex =
        RegExp('^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}\$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registration'),
        ),
        body:  SafeArea(
          child: Center(
            child: RegistrationFormWidget(isTransition: true, title: 'Registration'),
          ),
        ));
  }
}
