abstract class Produto {
  final String id;
  final String nome;
  final double preco;
  final String descricao;
  final String imageUrl;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.imageUrl,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    switch (json['categoria']) {
      case 'eletronico':
        return Eletronico.fromJson(json);
      case 'roupa':
        return Roupa.fromJson(json);
      case 'alimento':
        return Alimento.fromJson(json);
      default:
        throw Exception(
          'Categoria de produto desconhecida: ${json['categoria']}',
        );
    }
  }
}

class Eletronico extends Produto {
  final String marca;
  final int garantiaMeses;

  Eletronico({
    required super.nome,
    required super.preco,
    required super.descricao,
    required super.imageUrl,
    required this.marca,
    required this.garantiaMeses,
  });

  factory Eletronico.fromJson(Map<String, dynamic> json) {
    return Eletronico(
      nome: json['nome'],
      preco: json['preco'],
      descricao: json['descricao'],
      imageUrl: json['imageUrl'],
      marca: json['marca'],
      garantiaMeses: json['garantiaMeses'],
    );
  }
}

class Roupa extends Produto {
  final String tamanho;
  final String cor;

  Roupa({
    required super.id,
    required super.nome,
    required super.preco,
    required super.descricao,
    required super.imageUrl,
    required this.tamanho,
    required this.cor,
  });

  factory Roupa.fromJson(Map<String, dynamic> json) {
    return Roupa(
      nome: json['nome'],
      preco: json['preco'],
      descricao: json['descricao'],
      imageUrl: json['imageUrl'],
      tamanho: json['tamanho'],
      cor: json['cor'],
    );
  }
}

class Alimento extends Produto {
  final String dataValidade;
  final int calorias;

  Alimento({
    required super.nome,
    required super.preco,
    required super.descricao,
    required super.imageUrl,
    required this.dataValidade,
    required this.calorias,
  });

  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      nome: json['nome'],
      preco: json['preco'],
      descricao: json['descricao'],
      imageUrl: json['imageUrl'],
      dataValidade: json['dataValidade'],
      calorias: json['calorias'],
    );
  }
}
