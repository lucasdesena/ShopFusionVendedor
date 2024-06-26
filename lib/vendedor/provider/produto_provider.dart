import 'package:flutter/material.dart';

class ProdutoProvider with ChangeNotifier {
  Map<String, dynamic> produtoData = {};

  getFormData({
    String? nomeProduto,
    double? precoProduto,
    int? quantidadeProduto,
    String? categoria,
    String? descicao,
    bool? cobrarFrete,
    double? precoFrete,
    String? marca,
    List<String>? medidas,
    List<String>? imagensProduto,
  }) {
    if (nomeProduto != null) {
      produtoData['nome_produto'] = nomeProduto;
    }
    if (precoProduto != null) {
      produtoData['preço_produto'] = precoProduto;
    }
    if (quantidadeProduto != null) {
      produtoData['quantidade_produto'] = quantidadeProduto;
    }
    if (categoria != null) {
      produtoData['categoria'] = categoria;
    }
    if (descicao != null) {
      produtoData['descrição'] = descicao;
    }
    if (cobrarFrete != null) {
      produtoData['cobrar_frete'] = cobrarFrete;
    }
    if (precoFrete != null) {
      produtoData['preço_frete'] = precoFrete;
    }
    if (marca != null) {
      produtoData['marca'] = marca;
    }
    if (medidas != null) {
      produtoData['medidas'] = medidas;
    }
    if (imagensProduto != null) {
      produtoData['imagens_produto'] = imagensProduto;
    }

    notifyListeners();
  }

  clearData() {
    produtoData.clear();
    notifyListeners();
  }
}
