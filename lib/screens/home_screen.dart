import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
            ),
            onPressed: () {},
          ),
          title: const Text(
            'Welcome Username',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/image/ltech.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 34),
              ),
              const SizedBox(height: 16),
              const Text(
                'name',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'email',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 3,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ListTile(
                        leading: Icon(
                          Icons.logout_sharp,
                          color: Colors.red.shade300,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
