import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SairPage extends StatelessWidget {
  SairPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _auth.signOut();
          },
          child: const Text(
            'Sair',
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
