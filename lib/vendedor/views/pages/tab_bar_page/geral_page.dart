import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';

class GeralPage extends StatefulWidget {
  const GeralPage({super.key});

  @override
  State<GeralPage> createState() => _GeralPageState();
}

class _GeralPageState extends State<GeralPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final List<String> _categorias = [];

  ///Método para obter a lista de categorias do firebase
  Future<dynamic> _getCategorias() {
    return _firebase
        .collection('categorias')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categorias.add(doc['nome_categoria']);
        });
      }
    });
  }

  @override
  void initState() {
    _getCategorias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProdutoProvider produtoProvider =
        Provider.of<ProdutoProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o nome do produto';
                  }
                  return null;
                },
                onChanged: (value) {
                  produtoProvider.getFormData(nomeProduto: value);
                },
                decoration: const InputDecoration(
                  labelText: 'Insira o nome do produto',
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o preço do produto';
                  }
                  return null;
                },
                onChanged: (value) {
                  produtoProvider.getFormData(
                      precoProduto: double.parse(value));
                },
                decoration: const InputDecoration(
                  labelText: 'Insira o preço do produto',
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a quantidade do produto';
                  }
                  return null;
                },
                onChanged: (value) {
                  produtoProvider.getFormData(
                      quantidadeProduto: int.parse(value));
                },
                decoration: const InputDecoration(
                  labelText: 'Insira a quantidade do produto',
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField(
                hint: const Text(
                  'Selecione a categoria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                items: _categorias.map<DropdownMenuItem<dynamic>>((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  produtoProvider.getFormData(categoria: value);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a descrição do produto';
                  }
                  return null;
                },
                onChanged: (value) {
                  produtoProvider.getFormData(descicao: value);
                },
                maxLines: 10,
                minLines: 3,
                maxLength: 800,
                decoration: const InputDecoration(
                  hintText: 'Insira a descrição do produto',
                  labelText: 'Descrição do produto',
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
