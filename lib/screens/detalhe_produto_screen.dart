import 'package:flutter/material.dart';
import '../widgets/produto_widget.dart'; // Importa a classe base do WIDGET

class DetalheProdutoScreen extends StatelessWidget {
  // A tela de detalhes recebe o WIDGET já construído.
  // Isso a mantém simples, sem precisar saber sobre os modelos de dados.
  final ProdutoWidget produto;

  const DetalheProdutoScreen({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
      body: SingleChildScrollView(
        // Permite rolagem se o conteúdo for grande
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    produto.imageUrl,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                produto.nome,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              // Exibe o widget específico para mostrar os detalhes extras
              if (produto is Card) ...[
                (produto as Card).child ?? const SizedBox(),
              ] else ...[
                // Se não for um Card, tenta mostrar a descrição
                Text(
                  'Descrição',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  produto.descricao,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
