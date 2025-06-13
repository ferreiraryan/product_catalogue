import 'dart:io';

import 'package:catalogo_produtos/models/produto_model.dart';

import '../widgets/produto_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DetalheProdutoScreen extends StatelessWidget {
  // A tela de detalhes recebe o WIDGET já construído.
  final ProdutoWidget widgetProduto;
  final Function(Map<String, dynamic>) onRemove;
  final Produto produto;

  const DetalheProdutoScreen({
    super.key,
    required this.widgetProduto,
    required this.onRemove,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widgetProduto.nome)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widgetProduto.imageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widgetProduto.nome,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'R\$ ${widgetProduto.preco.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              // Exibe o widget específico para mostrar os detalhes extras
              if (widgetProduto is Card) ...[
                (widgetProduto as Card).child ?? const SizedBox(),
              ] else ...[
                Text(
                  'Descrição',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  widgetProduto.descricao,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => {},

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 246, 10, 10),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        child: const Text(
          "Remover Produto",
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
