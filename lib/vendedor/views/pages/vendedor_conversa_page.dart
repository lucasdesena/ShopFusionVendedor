import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_fusion_vendedor/vendedor/controller/chat_controller.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/interior_pages/conversa_detalhe.page.dart';

class VendedorConversaPage extends StatefulWidget {
  const VendedorConversaPage({super.key});

  @override
  State<VendedorConversaPage> createState() => _VendedorConversaPageState();
}

class _VendedorConversaPageState extends State<VendedorConversaPage> {
  final ChatController _chatController = Get.find<ChatController>();

  final TextEditingController mensagemController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> chatStream;

  @override
  void initState() {
    chatStream = _chatController.obterListaChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo deu errado');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                Map<String, String> ultimoProdutoPeloIDVendedor = {};

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];

                    Map<String, dynamic> data =
                        documentSnapshot.data()! as Map<String, dynamic>;

                    String mensagem = data['mensagem'];

                    String idRemetente = data['id_remetente'];

                    String idProduto = data['id_produto'];

                    bool isVendedor = idRemetente == _auth.currentUser!.uid;

                    if (!isVendedor) {
                      String key = "${idRemetente}_$idProduto";
                      if (!ultimoProdutoPeloIDVendedor.containsKey(key)) {
                        ultimoProdutoPeloIDVendedor[key] = idProduto;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ConversaDetalhePage(
                                    idComprador: data['id_comprador'],
                                    idVendedor: _auth.currentUser!.uid,
                                    idProduto: idProduto,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    data['imagem_comprador'],
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }

                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Text(mensagem),
                              subtitle: const Text(
                                'Enviada pelo Comprador',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
