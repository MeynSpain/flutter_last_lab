import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import '../../model/model.dart';

class RegistrationFormWidget extends StatefulWidget {
  final bool isTransition;
  final String title;
  String? login = '';
  String? name = '';
  String? mail = '';
  String? password = '';

  RegistrationFormWidget(
      {Key? key,
      required this.isTransition,
      required this.title,
      this.login,
      this.name,
      this.password,
      this.mail})
      : super(key: key);

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _controllerLogin = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerMail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPasswordRepeat = TextEditingController();

  late final bool _isTransition;
  String _title = '';

  String _login = '';
  String _name = '';
  String _mail = '';
  String _password = '';

  @override
  void initState() {
    super.initState();

    _isTransition = widget.isTransition;
    _login = widget.login ?? '';
    _name = widget.name ?? '';
    _mail = widget.mail ?? '';
    _password = widget.password ?? '';
    _title = widget.title;
  }

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
      // _repeatPassword = _controllerPasswordRepeat.text;

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
    } else {
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${_title}',
                style: TextStyle(fontSize: 26),
              ),
              TextFormField(
                controller: _controllerLogin,
                decoration: InputDecoration(labelText: 'Login:${_login}'),
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
                controller: _controllerName,
                decoration: InputDecoration(labelText: 'Name:${_name}'),
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
                controller: _controllerMail,
                decoration: InputDecoration(labelText: 'Email:${_mail}'),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please input email';
                  }
                  if (!isValidateEmail(value.trim())) {
                    return 'Email is not correct';
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controllerPassword,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password:${_password}'),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please input password';
                  }
                  if (!isValidatePassword(value.trim())) {
                    return 'The password must contain uppercase and lowercase letters, as well as numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controllerPasswordRepeat,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password repeat'),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please repeat password';
                  }
                  if (_controllerPassword.text.trim().compareTo(value.trim()) !=
                      0) {
                    return "the password doesn't match";
                  }
                  return null;
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
                    if (await getData()) {
                      if (_isTransition) {
                        Future.delayed(const Duration(milliseconds: 700), () {
                          Get.offAllNamed('/login');
                        });
                      }
                    }
                  },
                  child: const Text('Registration'))
            ],
          ),
        ),
      ),
    );
  }
}
