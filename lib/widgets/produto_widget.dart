import 'package:flutter/material.dart';

abstract class ProdutoWidget extends StatelessWidget {
  final String nome;
  final double preco;
  final String descricao;
  final String imageUrl;
  final VoidCallback onTap;

  const ProdutoWidget({
    super.key,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip
            .antiAlias, // Garante que o conteúdo não vaze das bordas arredondadas
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: buildDetalhes(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetalhes(BuildContext context);
}
