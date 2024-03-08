import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';
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
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (
          _,
        ) {
          return ProdutoProvider();
        },
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopFusion Vendedor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.deepPurple),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(surfaceTintColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: const VendedorAuthPage(),
      builder: EasyLoading.init(),
    );
  }
}
