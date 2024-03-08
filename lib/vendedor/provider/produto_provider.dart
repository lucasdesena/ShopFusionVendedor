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
      produtoData['preço_frete'] = produtoData;
    }

    notifyListeners();
  }
}