import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class SacarGanhosPage extends StatefulWidget {
  const SacarGanhosPage({super.key});

  @override
  State<SacarGanhosPage> createState() => _SacarGanhosPageState();
}

class _SacarGanhosPageState extends State<SacarGanhosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlNomeBanco = TextEditingController();
  final TextEditingController _ctrlNomeConta = TextEditingController();
  final TextEditingController _ctrlNumeroConta = TextEditingController();
  final TextEditingController _ctrlQuantiaSaque = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sacar Ganhos'),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: _ctrlNomeBanco,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor preencha o campo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome do Banco',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 5),
                      hintText: 'Insira o nome do seu banco',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ctrlNomeConta,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor preencha o campo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome da Conta',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 5),
                      hintText: 'Insira o nome da sua conta',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ctrlNumeroConta,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor preencha o campo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Número da Conta',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 5),
                      hintText: 'Insira o número da sua conta',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _ctrlQuantiaSaque,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor preencha o campo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Quantia para Saque',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 5),
                      hintText: 'Insira a quantidade que deseja sacar',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 58),
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                EasyLoading.show();
                DocumentSnapshot userDoc = await _firestore
                    .collection('vendedores')
                    .doc(_auth.currentUser!.uid)
                    .get();
                final saqueID = const Uuid().v4();
                await _firestore.collection('saques').doc(saqueID).set({
                  'razão_social':
                      (userDoc.data() as Map<String, dynamic>)['razão_social'],
                  'nome_banco': _ctrlNomeBanco.text,
                  'nome_conta': _ctrlNomeConta.text,
                  'numero_conta': _ctrlNumeroConta.text,
                  'quantia_saque': _ctrlQuantiaSaque.text,
                }).whenComplete(() {
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                });
              }
            },
            child: const Center(
              child: Text(
                'Sacar dinheiro',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
