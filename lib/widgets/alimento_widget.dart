import 'package:flutter/material.dart';
import 'produto_widget.dart';

/// CLASSE DERIVADA: AlimentoWidget
///
/// Representa um produto "Alimento", herdando de ProdutoWidget e
/// adicionando as propriedades `dataValidade` e `calorias`.
class AlimentoWidget extends ProdutoWidget {
  /// Propriedades específicas de alimentos.
  final String dataValidade;
  final int calorias;

  const AlimentoWidget({
    super.key,
    required super.nome,
    required super.preco,
    required super.descricao,
    required super.imageUrl,
    required super.onTap,
    required this.dataValidade,
    required this.calorias,
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
          'calorias: $calorias',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        Text(
          'Data de Validade: $dataValidade meses',
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
