import 'package:flutter/material.dart';
import 'produto_widget.dart';

/// CLASSE DERIVADA: RoupaWidget
///
/// Representa um produto "Roupa", herdando de ProdutoWidget e
/// adicionando as propriedades `tamanho` e `cor`.
class RoupaWidget extends ProdutoWidget {
  /// Propriedades específicas de roupas.
  final String tamanho;
  final String cor;

  const RoupaWidget({
    super.key,
    required super.nome,
    required super.preco,
    required super.descricao,
    required super.imageUrl,
    required super.onTap,
    required this.tamanho,
    required this.cor,
  });

  @override
  Widget buildDetalhes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          'tamanho: $tamanho',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        Text('cor: $cor meses', style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            'R\$ ${preco.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
