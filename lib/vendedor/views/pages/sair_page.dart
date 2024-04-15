import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SairPage extends StatelessWidget {
  SairPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Obrigado por usar nosso aplicativo! Sua presença é sempre apreciada. Volte sempre! Estaremos aqui para ajudá-lo(a) sempre que precisar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: const Text(
                'Sair',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
