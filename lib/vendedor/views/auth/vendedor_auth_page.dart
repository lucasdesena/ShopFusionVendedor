import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_fusion_vendedor/vendedor/views/auth/vendedor_cadastro_page.dart';

class VendedorAuthPage extends StatefulWidget {
  const VendedorAuthPage({super.key});

  @override
  State<VendedorAuthPage> createState() => _VendedorAuthPageState();
}

class _VendedorAuthPageState extends State<VendedorAuthPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
          );
        }

        return const VendedorCadastroPage();
      },
    );
  }
}
