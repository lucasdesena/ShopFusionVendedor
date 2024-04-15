import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PedidosPage extends StatelessWidget {
  PedidosPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> pedidosStream = _firestore
        .collection('pedidos')
        .where('id_vendedor', isEqualTo: _auth.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pedidosStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(),
                  ),
                  child: Slidable(
                    key: const ValueKey(0),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(9),
                          onPressed: (context) async {
                            await _firestore
                                .collection('pedidos')
                                .doc(data['id_pedido'])
                                .update({'aceito': false});
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Rejeitar',
                          padding: const EdgeInsets.all(8.0),
                        ),
                        const SizedBox(width: 2),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(9),
                          onPressed: (context) async {
                            await _firestore
                                .collection('pedidos')
                                .doc(data['id_pedido'])
                                .update({'aceito': true});
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: 'Aceitar',
                          padding: const EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: data['aceito']
                                ? const Icon(Icons.delivery_dining)
                                : const Icon(Icons.access_time),
                          ),
                          title: data['aceito']
                              ? Text(
                                  'Aceito',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                )
                              : Text(
                                  'Não Aceito',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                          trailing: Text(
                            'R\$ ${data['preço'].toStringAsFixed(2).toString().replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Detalhes',
                            style: TextStyle(
                              color: Colors.deepPurple.shade900,
                            ),
                          ),
                          subtitle: const Text('Veja os detalhes do pedido'),
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              leading: CircleAvatar(
                                radius: 40,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    data['imagens_produto'][0],
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
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['nome_produto'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Quantidade',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        data['quantidade_requisitada']
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.deepPurple.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                title: const Text(
                                  'Detalhes do cliente',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      'Nome:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      data['nome'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Email:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      data['email'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Data do Pedido:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${data['data_pedido']}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
