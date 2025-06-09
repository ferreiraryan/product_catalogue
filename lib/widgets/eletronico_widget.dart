import 'package:flutter/material.dart';
import 'produto_widget.dart';

/// CLASSE DERIVADA: EletronicoWidget
///
/// Representa um produto "Eletrônico", herdando de ProdutoWidget e
/// adicionando as propriedades `marca` e `garantiaMeses`.
class EletronicoWidget extends ProdutoWidget {
  /// Propriedades específicas de eletrônicos.
  final String marca;
  final int garantiaMeses;

  const EletronicoWidget({
    super.key,
    required super.nome,
    required super.preco,
    required super.descricao,
    required super.imageUrl,
    required super.onTap,
    required this.marca,
    required this.garantiaMeses,
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
        Text('Marca: $marca', style: TextStyle(color: Colors.grey.shade700)),
        Text(
          'Garantia: $garantiaMeses meses',
          style: TextStyle(color: Colors.grey.shade700),
        ),
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
