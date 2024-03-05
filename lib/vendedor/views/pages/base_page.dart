import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_fusion_vendedor/models/vendedor_model.dart';
import 'package:shop_fusion_vendedor/vendedor/views/auth/vendedor_cadastro_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/vendedor_mapa_page.dart';

class BasePage extends StatelessWidget {
  BasePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference vendedoresStream =
        FirebaseFirestore.instance.collection('vendedores');

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: vendedoresStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo de errado aconteceu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Carregando");
          }

          if (!snapshot.data!.exists) {
            return const VendedorCadastroPage();
          }

          VendedorModel vendedorModel = VendedorModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>);

          if (vendedorModel.aprovado) {
            return const VendedorMapaPage();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          vendedorModel.imagemLoja,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        vendedorModel.razaoSocial,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'A sua aplicação foi enviada a administração do aplicativo com sucesso!\nVocê recebera um retorno a respeito em breve.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 90,
                        child: TextButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.deepPurple),
                          ),
                          onPressed: () async {
                            await _auth.signOut();
                          },
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
