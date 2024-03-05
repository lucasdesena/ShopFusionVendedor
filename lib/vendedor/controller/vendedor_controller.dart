import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VendedorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Método para pegar a imagem escolhida
  Future<Uint8List?> pegarImagem(ImageSource source) async {
    final ImagePicker pickImage = ImagePicker();

    XFile? file = await pickImage.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      debugPrint('Nenhuma imagem selecionada');
      return null;
    }
  }

  ///Método para fazer o upload da imagem para o Storage do firebase
  Future<String> _carregarImagemStorage(Uint8List? imagem) async {
    Reference ref =
        _storage.ref().child('imagem_loja').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(imagem!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<String> cadastroVendedor(
      String razaoSocial,
      String email,
      String telefone,
      String pais,
      String estado,
      String cidade,
      Uint8List? imagem) async {
    String res = 'Algo deu errado';

    try {
      String downloadURL = await _carregarImagemStorage(imagem);
      await _firestore
          .collection('vendedores')
          .doc(_auth.currentUser!.uid)
          .set({
        'razao_social': razaoSocial,
        'imagem_loja': downloadURL,
        'email': email,
        'telefone': telefone,
        'pais': pais,
        'estado': estado,
        'cidade': cidade,
        'id_vendedor': _auth.currentUser!.uid,
        'aprovado': false,
      });

      res = 'sucess';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
