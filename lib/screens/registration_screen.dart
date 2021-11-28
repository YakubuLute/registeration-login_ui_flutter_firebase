import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_registration_flutter/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({Key? key}) : super(key: key);
  @override
  _RegisterationScreenState createState() {
    return _RegisterationScreenState();
  }
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  //Firebase Instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Registeration',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 20,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    child: Image.asset('assets/image/ltech.png'),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Name';
                            }
                            return null;
                          },
                          controller: _nameController,
                          decoration: InputDecoration(
                            //add an icon before the hint text
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.person),
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Name',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if ((value!.isEmpty) ||
                                (!_emailController.value.text.contains('@') ||
                                    !_emailController.value.text
                                        .contains('.'))) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              //user must enter 7 digit password
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                          controller: _phoneController,
                          decoration: InputDecoration(
                            //add an icon before the hint text
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.phone),
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Phone',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
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
                            hintText: 'Enter Password',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            } //check to see if password and confirm password match
                            if (value != _passwordController.value.text) {
                              return 'Password does not match';
                            } //check to see if password is at least 6 characters
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: _passwordConfirmController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                //borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(15)),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.lock),
                            ),
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Material(
                    elevation: 5,
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //create new user with email and password
                          await _firebaseAuth
                              .createUserWithEmailAndPassword(
                                  email: _emailController.value.text,
                                  password: _passwordController.value.text)
                              .then((value) {
                            //create user in firebase
                            _firestore
                                .collection('users')
                                .doc(value.user!.uid)
                                .set({
                              'name': _nameController.value.text,
                              'email': _emailController.value.text,
                              'phone': _phoneController.value.text,
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          });
                          //Display a toast message
                          Scaffold.of(context).showSnackBar(const SnackBar(
                            content: Text('User created successfully'),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already having account? ",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterationScreen()));
                        },
                        child: const Text(
                          "Login here",
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
