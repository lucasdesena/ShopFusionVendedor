import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';
import 'package:uuid/uuid.dart';

class ImagensPage extends StatefulWidget {
  const ImagensPage({super.key});

  @override
  State<ImagensPage> createState() => _ImagensPageState();
}

class _ImagensPageState extends State<ImagensPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  final List<File> _imagens = [];

  final List<String> _imagensUrl = [];

  ///Método para selecionar uma imagem da galeria para o produto
  Future<void> escolherImagem() async {
    final imagemEscolhida = await picker.pickImage(source: ImageSource.gallery);

    if (imagemEscolhida == null) {
      debugPrint('Nenhuma imagem escolhida');
    } else {
      setState(() {
        _imagens.add(File(imagemEscolhida.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProdutoProvider produtoProvider = Provider.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: _imagens.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                childAspectRatio: 3 / 3,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          onPressed: () async {
                            await escolherImagem();
                          },
                          icon: const Icon(Icons.add),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_imagens[index - 1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              },
            ),
            Visibility(
              visible: _imagens.isNotEmpty,
              child: ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: 'Carregando');
                  for (var img in _imagens) {
                    Reference ref =
                        _storage.ref().child('imagem_produto').child(
                              const Uuid().v4(),
                            );

                    await ref.putFile(img).whenComplete(() async {
                      await ref.getDownloadURL().then((url) {
                        setState(() {
                          _imagensUrl.add(url);
                        });
                      });
                      EasyLoading.dismiss();
                    });

                    produtoProvider.getFormData(imagensUrl: _imagensUrl);
                  }
                },
                child: const Text(
                  'Enviar imagens',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
