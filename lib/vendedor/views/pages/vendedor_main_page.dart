import 'package:flutter/material.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/carregamento_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/ganhos_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/pedidos_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/sair_page.dart';
import 'package:shop_fusion_vendedor/vendedor/views/pages/vendedor_conversa_page.dart';

class VendedorMainPage extends StatefulWidget {
  const VendedorMainPage({super.key});

  @override
  State<VendedorMainPage> createState() => _VendedorMainPageState();
}

class _VendedorMainPageState extends State<VendedorMainPage> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    GanhosPage(),
    const CarregamentoPage(),
    PedidosPage(),
    const VendedorConversaPage(),
    SairPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Ganhos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload),
              label: 'Carregar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Conversas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Sair',
            ),
          ],
        ));
  }
}
