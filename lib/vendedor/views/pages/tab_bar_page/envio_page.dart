import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';

class EnvioPage extends StatefulWidget {
  const EnvioPage({super.key});

  @override
  State<EnvioPage> createState() => _EnvioPageState();
}

class _EnvioPageState extends State<EnvioPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _cobrarFrete = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProdutoProvider produtoProvider =
        Provider.of<ProdutoProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          CheckboxListTile(
              title: const Text('Cobrar Frete'),
              value: _cobrarFrete,
              onChanged: (value) {
                setState(() {
                  _cobrarFrete = value!;
                });

                produtoProvider.getFormData(cobrarFrete: value);
              }),
          _cobrarFrete
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira o valor do frete';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      produtoProvider.getFormData(
                          precoFrete: double.parse(value));
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Valor do Frete',
                      hintText: 'Insira o valor do frete',
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
