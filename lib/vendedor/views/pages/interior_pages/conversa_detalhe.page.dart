import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_fusion_vendedor/vendedor/controller/chat_controller.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/shared/box_text_field.dart';

class ConversaDetalhePage extends StatefulWidget {
  final String idComprador;
  final String idVendedor;
  final String idProduto;
  final dynamic data;

  const ConversaDetalhePage({
    super.key,
    required this.idComprador,
    required this.idVendedor,
    required this.idProduto,
    this.data,
  });

  @override
  State<ConversaDetalhePage> createState() => _ConversaDetalhePageState();
}

class _ConversaDetalhePageState extends State<ConversaDetalhePage> {
  final ChatController _chatController = Get.find<ChatController>();

  final TextEditingController mensagemController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> chatStream;

  String nome = '';

  @override
  void initState() {
    chatStream =
        _chatController.obterChat(widget.idComprador, widget.idProduto);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversa'),
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

                return ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    String idRemetente = data['id_remetente'];

                    bool isComprador = idRemetente != _auth.currentUser!.uid;

                    String tipoRemetente =
                        isComprador ? 'Comprador' : 'Vendedor';

                    return ListTile(
                      leading: isComprador
                          ? CircleAvatar(
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
                            )
                          : CircleAvatar(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  data['imagem_vendedor'],
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
                      title: Text(data['mensagem']),
                      subtitle: Text(
                        'Enviada pelo $tipoRemetente',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => SingleChildScrollView(
                  child: Row(
                    children: [
                      Expanded(
                        child: BoxTextField(
                          controller: mensagemController,
                          icon: Icons.message_outlined,
                          label: 'Mensagem',
                          hintText: 'Insira a sua mensagem',
                          textInputType: TextInputType.multiline,
                          maxLines: null,
                          isChat: true,
                          onFieldSubmitted: (_) async => _chatController.loading
                              ? null
                              : await enviarMensagem(),
                        ),
                      ),
                      _chatController.loading
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: () async => await enviarMensagem(),
                              icon: const Icon(Icons.send),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }

  Future<void> enviarMensagem() async {
    String mensagem = mensagemController.text.trim();
    if (mensagem.isNotEmpty) {
      await _chatController
          .enviarMensagem(
        mensagemController.text,
        widget.idComprador,
        widget.idProduto,
      )
          .then((mensagemErro) {
        if (mensagemErro.isEmpty) {
          mensagemController.clear();
        } else {
          Get.showSnackbar(GetSnackBar(
            message: mensagemErro,
          ));
        }
      });
    }
  }
}
