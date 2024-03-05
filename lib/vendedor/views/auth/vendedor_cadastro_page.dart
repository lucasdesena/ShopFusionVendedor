import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_fusion_vendedor/vendedor/controller/vendedor_controller.dart';

class VendedorCadastroPage extends StatefulWidget {
  const VendedorCadastroPage({super.key});

  @override
  State<VendedorCadastroPage> createState() => _VendedorCadastroPageState();
}

class _VendedorCadastroPageState extends State<VendedorCadastroPage> {
  final VendedorController _vendedorcontroller = VendedorController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final razaoController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();

  Uint8List? _image;

  late String pais;
  late String estado;
  late String cidade;

  Future<void> selectGalleryImage() async {
    Uint8List? img = await _vendedorcontroller.pegarImagem(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  Future<void> selectCameraImage() async {
    Uint8List? img = await _vendedorcontroller.pegarImagem(ImageSource.camera);

    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple,
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Center(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: _image != null
                          ? Container(
                              decoration:
                                  BoxDecoration(border: Border.all(width: 4)),
                              child: Image.memory(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                await selectGalleryImage();
                              },
                              icon: const Icon(Icons.photo),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor insira uma razão social';
                        }
                        return null;
                      },
                      controller: razaoController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Razão Social',
                        hintText: 'Razão Social',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor insira um endereço de e-mail';
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        hintText: 'E-mail',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor insira um número de telefone';
                        }
                        return null;
                      },
                      controller: telefoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        hintText: 'Telefone',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SelectState(
                      spacing: 20,
                      labelStyle:
                          const TextStyle(fontSize: 20, color: Colors.black),
                      selectedCountryLabel: 'Escolha o Pais',
                      onCountryChanged: (value) {
                        setState(() {
                          pais = value;
                        });
                      },
                      selectedStateLabel: 'Escolha o Estado',
                      onStateChanged: (value) {
                        setState(() {
                          estado = value;
                        });
                      },
                      selectedCityLabel: 'Escolha a Cidade',
                      onCityChanged: (value) {
                        setState(() {
                          cidade = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              EasyLoading.show(status: 'Carregando');
                              await _vendedorcontroller
                                  .cadastroVendedor(
                                    razaoController.text,
                                    emailController.text,
                                    telefoneController.text,
                                    pais,
                                    estado,
                                    cidade,
                                    _image,
                                  )
                                  .whenComplete(() => EasyLoading.dismiss());
                            } else {
                              debugPrint('Deu ruim');
                            }
                          },
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
