import 'dart:convert';

import 'package:muscuapp/screens/workouts_screen.dart';
import '../global_state.dart' as global_state;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/model/login_response.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: const EdgeInsets.all(15.0));

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
                  labelText: 'Username',
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
                  setState(() {
                    loading = true;
                  });
                  LoginResponse? response = await login();
                  setState(() {
                    loading = false;
                  });
                  if (response == null) {
                    Fluttertoast.showToast(
                        msg: 'Failed to login',
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        fontSize: 18.0);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkoutsScreen()),
                    );
                  }
                },
                child: AnimatedSwitcher(
                  child: SizedBox(
                    width: 150,
                    height: 25,
                    child: Center(
                      child: loading
                          ? const SizedBox(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              height: 20.0,
                              width: 20.0,
                            )
                          : const Text('Log In'),
                    ),
                  ),
                  duration: const Duration(milliseconds: 500),
                ),
              ),
            ],
          )),
    )));
  }
}
