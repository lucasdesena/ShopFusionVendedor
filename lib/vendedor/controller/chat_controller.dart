import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool _loading = false.obs;

  bool get loading => _loading.value;

  Future<String> enviarMensagem(
      String mensagem, String idComprador, String idProduto) async {
    String mensagemErro = '';
    _loading.value = true;

    try {
      DocumentSnapshot vendedorDoc = await _firestore
          .collection('vendedores')
          .doc(_auth.currentUser!.uid)
          .get();

      DocumentSnapshot compradorDoc =
          await _firestore.collection('compradores').doc(idComprador).get();

      await _firestore.collection('chats').add({
        'id_produto': idProduto,
        'nome_comprador': (compradorDoc.data() as Map<String, dynamic>)['nome'],
        'imagem_comprador':
            (compradorDoc.data() as Map<String, dynamic>)['imagem_perfil'],
        'imagem_vendedor':
            (vendedorDoc.data() as Map<String, dynamic>)['imagem_loja'],
        'id_comprador': idComprador,
        'id_vendedor': _auth.currentUser!.uid,
        'mensagem': mensagem,
        'id_remetente': _auth.currentUser!.uid,
        'data_envio': DateTime.now(),
      });
    } catch (_) {
      mensagemErro = 'Houve um erro ao enviar a mensagem!';
    }

    _loading.value = false;

    return mensagemErro;
  }

  Stream<QuerySnapshot> obterListaChat() {
    return _firestore
        .collection('chats')
        .where('id_vendedor', isEqualTo: _auth.currentUser!.uid)
        .orderBy('data_envio', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> obterChat(String idComprador, String idProduto) {
    return _firestore
        .collection('chats')
        .where('id_comprador', isEqualTo: idComprador)
        .where('id_vendedor', isEqualTo: _auth.currentUser!.uid)
        .where('id_produto', isEqualTo: idProduto)
        .orderBy('data_envio', descending: true)
        .snapshots();
  }
}
