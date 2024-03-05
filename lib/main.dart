import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_fusion_vendedor/vendedor/views/auth/vendedor_auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: dotenv.get('FirebaseApiKey'),
        appId: dotenv.get('FirebaseAppID'),
        messagingSenderId: dotenv.get('FirebaseProjectNumber'),
        projectId: dotenv.get('FirebaseProjectId'),
        storageBucket: dotenv.get('FirebaseStorageBucket')),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VendedorAuthPage(),
    );
  }
}
