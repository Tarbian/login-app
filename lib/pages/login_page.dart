// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:login_app/pages/reg_page.dart';
import 'package:login_app/utils/validator.dart';
import 'package:login_app/utils/input_decoration.dart';
import 'package:login_app/utils/dialog_decorarion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  bool _hidePass = true;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: _loginFormKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                validator: (val) => Validator.validateEmail(val),
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                autofocus: true,
                decoration: buildInputDecoration(
                  labelText: 'Email',
                  iconData: Icons.email,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) => Validator.validatePassword(val),
                controller: _passController,
                focusNode: _passwordFocusNode,
                keyboardType: TextInputType.visiblePassword,
                onEditingComplete: () {
                  submitForm();
                },
                obscureText: _hidePass,
                obscuringCharacter: '●',
                decoration: buildInputDecoration(
                    labelText: 'Password',
                    iconData: Icons.key,
                    suffixIconData:
                        _hidePass ? Icons.visibility : Icons.visibility_off,
                    onSuffixIconPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => submitForm(),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 24),
                ),
                child: const Text('Login!'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegPage()),
                  );
                },
                child: const Text("Don't have an account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    if (_loginFormKey.currentState!.validate()) {
      var url = Uri.parse('http://10.0.2.2:5000/login');
      var data = jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passController.text,
      });
      var response = await http.post(
        url,
        body: data,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildAlertDialog(
              title: "Success",
              content: "Your login was successful.",
              context: context,
            );
          },
        );
      } else if (response.statusCode == 400) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildAlertDialog(
              title: "Error",
              content: "Invalid credentials.",
              context: context,
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return buildAlertDialog(
              title: "Error",
              content:
                  "Registration failed. Please try again.\nStatuse code: ${response.statusCode}",
              context: context,
            );
          },
        );
      }
    }
  }
}
