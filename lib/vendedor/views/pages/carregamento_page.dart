import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/atributos_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/envio_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/geral_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/imagens_page.dart';
import 'package:uuid/uuid.dart';

class CarregamentoPage extends StatefulWidget {
  const CarregamentoPage({super.key});

  @override
  State<CarregamentoPage> createState() => _CarregamentoPageState();
}

class _CarregamentoPageState extends State<CarregamentoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProdutoProvider produtoProvider =
        Provider.of<ProdutoProvider>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(child: Text('Geral')),
              Tab(child: Text('Envio')),
              Tab(child: Text('Atributos')),
              Tab(child: Text('Imagens')),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: const TabBarView(
            children: [
              GeralPage(),
              EnvioPage(),
              AtributosPage(),
              ImagensPage(),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                DocumentSnapshot userDoc = await _firestore
                    .collection('vendedores')
                    .doc(_auth.currentUser!.uid)
                    .get();
                final produtoID = const Uuid().v4();
                if (_formKey.currentState!.validate()) {
                  EasyLoading.show(status: 'Carregando');
                  await _firestore.collection('produtos').doc(produtoID).set({
                    'id_produto': produtoID,
                    'nome_produto': produtoProvider.produtoData['nome_produto'],
                    'preço_produto':
                        produtoProvider.produtoData['preço_produto'],
                    'quantidade_produto':
                        produtoProvider.produtoData['quantidade_produto'],
                    'categoria': produtoProvider.produtoData['categoria'],
                    'descrição': produtoProvider.produtoData['descrição'],
                    'cobrar_frete': produtoProvider.produtoData['cobrar_frete'],
                    'preço_frete': produtoProvider.produtoData['preço_frete'],
                    'marca': produtoProvider.produtoData['marca'],
                    'medidas': produtoProvider.produtoData['medidas'],
                    'imagens_produto':
                        produtoProvider.produtoData['imagens_produto'],
                    'razão_social': (userDoc.data()
                        as Map<String, dynamic>)['razão_social'],
                    'imagem_loja':
                        (userDoc.data() as Map<String, dynamic>)['imagem_loja'],
                    'pais': (userDoc.data() as Map<String, dynamic>)['pais'],
                    'estado':
                        (userDoc.data() as Map<String, dynamic>)['estado'],
                    'cidade':
                        (userDoc.data() as Map<String, dynamic>)['cidade'],
                    'id_vendedor': _auth.currentUser!.uid,
                  }).whenComplete(() {
                    EasyLoading.dismiss();
                    produtoProvider.clearData();
                  });
                }
              },
              child: const Center(
                child: Text(
                  'Enviar produto',
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
      ),
    );
  }
}
