import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import '../../model/model.dart';

class UpdateFormWidget extends StatefulWidget {
  final bool isTransition;
  // final context;

  // final String title;
  // String? login = '';
  // String? name = '';
  // String? mail = '';
  // String? password = '';
  User user;

  UpdateFormWidget({Key? key, required this.isTransition, required this.user,
    // required this.context
  })
      : super(key: key);

  @override
  State<UpdateFormWidget> createState() => _UpdateFormWidgetState();
}

class _UpdateFormWidgetState extends State<UpdateFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _controllerLogin = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerMail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPasswordRepeat = TextEditingController();

  late User _user;
  late final _context;
  late final bool _isTransition;
  String _title = 'Profile';

  String _login = '';
  String _name = '';
  String _mail = '';
  String _password = '';


  @override
  void initState() {
    super.initState();
    // _context = widget.context;
    _user = widget.user;

    _isTransition = widget.isTransition;
    _login = _user.login ?? '';
    _name = _user.name ?? '';
    _mail = _user.mail ?? '';
    _password = _user.password ?? '';
  }

  updateData(String login, String name, String mail, String password) async {
    _user.password = password;
    _user.name = name;
    _user.mail = mail;

    _user.password = hashPassword(password);
    //Очистил таблицу после введения хеширования паролей
    // User().select().delete();
    await _user.save();

  }

  Future<bool> getData() async {
    if (_formKey.currentState!.validate()) {
      _name = _controllerName.text;
      _mail = _controllerMail.text;
      _password = _controllerPassword.text;

      updateData(_login, _name, _mail, _password);


      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
        content: const Text(
          'Account created',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        duration: const Duration(seconds: 3),
      ));

      return true;
    }
    else{
      return false;
    }
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '$_login',
                  style: TextStyle(fontSize: 26, color: Colors.blue),
                ),
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
                decoration: InputDecoration(labelText: 'Password:●●●●●●●●●●'),
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
                      Navigator.of(context).pop();
                      if (_isTransition) {
                        Future.delayed(const Duration(milliseconds: 700), () {
                          Get.offNamed('/login');
                        });
                      }
                    }
                  },
                  child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
