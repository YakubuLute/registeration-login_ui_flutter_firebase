import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_registration_flutter/screens/home_screen.dart';
import 'package:login_registration_flutter/screens/registration_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginScreeState createState() {
    return _LoginScreeState();
  }
}

//regex for email validation
/// RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")

class _LoginScreeState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: Image.asset('assets/image/ltech.png'),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }

                            if ((!_emailController.value.text.contains('@') ||
                                !_emailController.value.text.contains('.'))) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            //add an icon before the hint text
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.mail),
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                //borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(15)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.lock),
                            ),
                            hintText: 'Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Material(
                    elevation: 5,
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final user =
                                await _firebaseAuth.signInWithEmailAndPassword(
                                    email: _emailController.value.text.trim(),
                                    password: _passwordController.value.text);
                            if (user != null) {
                              //if user exists then navigate to home page
                              Fluttertoast.showToast(
                                msg: "You've logged in sucessffully",
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            } else {
                              //if user does not exists then navigate to registration page

                              print(
                                  "User doesn't exist, Redirecting to registeration page");

                              Timer(const Duration(seconds: 2), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterationScreen(),
                                  ),
                                );
                              });
                            }
                          } catch (e) {
                            //if there's an error, show error message
                            Fluttertoast.showToast(
                              msg:
                                  "There was an error sigining you in. ${e.toString()}",
                            );

                            print("Sorry something went wrong ${e.toString()}");
                          }
                        }
                      },
                      child: const Text('Login',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not having account? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterationScreen()));
                        },
                        child: const Text(
                          "Please register here",
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
