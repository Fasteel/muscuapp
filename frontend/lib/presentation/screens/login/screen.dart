import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muscuapp/application/models/login_response.dart';
import 'package:muscuapp/infrastructure/services/authentication.dart';
import 'package:muscuapp/presentation/screens/workouts/screen.dart';

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
                  LoginResponse? response = await AuthService.login(
                      usernameController.text, passwordController.text);

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
