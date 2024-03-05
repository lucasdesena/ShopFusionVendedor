class VendedorModel {
  final bool aprovado;
  final String razaoSocial;
  final String cidade;
  final String email;
  final String estado;
  final String imagemLoja;
  final String idVendedor;

  VendedorModel({
    required this.aprovado,
    required this.razaoSocial,
    required this.cidade,
    required this.email,
    required this.estado,
    required this.imagemLoja,
    required this.idVendedor,
  });

  factory VendedorModel.fromJson(Map<String, dynamic> json) {
    return VendedorModel(
      aprovado: json['aprovado'] as bool,
      razaoSocial: json['razao_social'] as String,
      cidade: json['cidade'] as String,
      email: json['email'] as String,
      estado: json['estado'] as String,
      imagemLoja: json['imagem_loja'] as String,
      idVendedor: json['id_vendedor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aprovado': aprovado,
      'razao_social': razaoSocial,
      'cidade': cidade,
      'email': email,
      'estado': estado,
      'imagem_loja': imagemLoja,
      'id_vendedor': idVendedor,
    };
  }
}
