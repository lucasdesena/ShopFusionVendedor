import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagensPage extends StatefulWidget {
  const ImagensPage({super.key});

  @override
  State<ImagensPage> createState() => _ImagensPageState();
}

class _ImagensPageState extends State<ImagensPage> {
  final ImagePicker picker = ImagePicker();

  List<File> _imagem = [];

  Future<void> escolherImagem() async {
    final imagemEscolhida = await picker.pickImage(source: ImageSource.gallery);

    if (imagemEscolhida == null) {
      debugPrint('Nenhuma imagem escolhida');
    } else {
      setState(() {
        _imagem.add(File(imagemEscolhida.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: _imagem.length + 1,
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
                            image: FileImage(_imagem[index - 1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
