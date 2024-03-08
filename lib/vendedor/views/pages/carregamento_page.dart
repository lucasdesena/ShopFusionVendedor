import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/atributos_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/envio_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/geral_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/tab_bar_page/imagens_page.dart';

class CarregamentoPage extends StatelessWidget {
  const CarregamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdutoProvider _produtoProvider =
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
        body: const TabBarView(
          children: [
            GeralPage(),
            EnvioPage(),
            AtributosPage(),
            ImagensPage(),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                debugPrint(_produtoProvider.produtoData['nome_produto']);
                debugPrint(_produtoProvider.produtoData['categoria']);
                debugPrint(_produtoProvider.produtoData['preço_frete']);
              },
              child: const Center(
                  child: Text(
                'Enviar produto',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
