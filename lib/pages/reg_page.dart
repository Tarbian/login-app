// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/pages/login_page.dart';
import 'package:login_app/utils/validator.dart';
import 'package:login_app/utils/input_decoration.dart';
import 'package:login_app/utils/dialog_decorarion.dart';
import 'package:http/http.dart' as http;

class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  bool _hidePass = true;

  final _regFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPassFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmpassController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _nameFocusNode.unfocus();
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
        _confirmPassFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Registration'),
        ),
        body: Form(
          key: _regFormKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                validator: (val) => Validator.validateName(val),
                controller: _nameController,
                focusNode: _nameFocusNode,
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                decoration: buildInputDecoration(
                    labelText: 'Name', iconData: Icons.person),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) => Validator.validateEmail(val),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocusNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                decoration: buildInputDecoration(
                    labelText: 'Email', iconData: Icons.email),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) => Validator.validatePassword(val),
                controller: _passController,
                obscureText: _hidePass,
                obscuringCharacter: '●',
                keyboardType: TextInputType.visiblePassword,
                focusNode: _passwordFocusNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_confirmPassFocusNode);
                },
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
                height: 20,
              ),
              TextFormField(
                validator: (val) =>
                    Validator.validatePasswordRepeat(val, _passController.text),
                controller: _confirmpassController,
                obscureText: _hidePass,
                obscuringCharacter: '●',
                keyboardType: TextInputType.visiblePassword,
                focusNode: _confirmPassFocusNode,
                onEditingComplete: () {
                  submitForm();
                },
                decoration: buildInputDecoration(
                    labelText: 'Confirm Password',
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
                child: const Text(
                  'Register me!',
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                },
                child: const Text('Already have an account?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (_regFormKey.currentState!.validate()) {
      var url = Uri.parse('http://10.0.2.2:5000/register');
      var data = jsonEncode(<String, String>{
        'name': _nameController.text,
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
              content: "Your registration was successful.",
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
              content: "Email is already registered.",
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
