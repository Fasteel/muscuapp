import 'dart:convert';

import '../global_state.dart' as global_state;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/factories/login_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muscuapp/screens/workouts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: const EdgeInsets.all(13.0));

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void setGlobalState(String username, String password) {
    var bytes =
        utf8.encode(usernameController.text + ":" + passwordController.text);
    global_state.token = "Basic " + base64.encode(bytes);
    global_state.isLoggedIn = true;
  }

  Future<LoginResponse?> login() async {
    final response = await http
        .post(Uri.parse('http://127.0.0.1:8000/api-token-auth/'), body: {
      'username': usernameController.text,
      'password': passwordController.text
    });
    if (response.statusCode != 200) {
      return null;
    }
    setGlobalState(usernameController.text, passwordController.text);
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
      key: _formKey,
      child: SizedBox(
          height: 240,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                style: style,
                onPressed: () async {
                  LoginResponse? response = await login();
                  if (response == null) {
                    Fluttertoast.showToast(
                        msg: 'Failed to login',
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        fontSize: 18.0);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Workouts()),
                    );
                  }
                },
                child: const Text('Log In'),
              ),
            ],
          )),
    )));
  }
}
