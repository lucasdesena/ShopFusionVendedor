import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_fusion_vendedor/vendedor/provider/produto_provider.dart';

class AtributosPage extends StatefulWidget {
  const AtributosPage({super.key});

  @override
  State<AtributosPage> createState() => _AtributosPageState();
}

class _AtributosPageState extends State<AtributosPage> {
  final TextEditingController _tamanhoController = TextEditingController();
  bool _isIntroduzido = false;
  bool _isSalvo = false;

  final List<String> _medidas = [];

  @override
  Widget build(BuildContext context) {
    final ProdutoProvider produtoProvider =
        Provider.of<ProdutoProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              produtoProvider.getFormData(marca: value);
            },
            decoration: const InputDecoration(
              labelText: 'Marca',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _tamanhoController,
                    onChanged: (value) {
                      setState(() {
                        _isIntroduzido = value.isNotEmpty;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Tamanho'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Visibility(
                visible: _isIntroduzido,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_medidas.contains(_tamanhoController.text)) {
                      _medidas.add(_tamanhoController.text);
                      setState(() {
                        _isSalvo = false;
                      });
                    }
                    setState(() {
                      _isIntroduzido = false;
                    });
                    _tamanhoController.clear();
                  },
                  child: const Text(
                    'Adicionar tamanho',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: _medidas.isNotEmpty,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _medidas.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _medidas.removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _medidas[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: _medidas.isNotEmpty && !_isSalvo,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isSalvo = true;
                });
                produtoProvider.getFormData(medidas: _medidas);
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
