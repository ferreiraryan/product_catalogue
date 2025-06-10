import 'dart:io';

import '../widgets/produto_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DetalheProdutoScreen extends StatelessWidget {
  // A tela de detalhes recebe o WIDGET já construído.
  final ProdutoWidget produto;

  const DetalheProdutoScreen({super.key, required this.produto});

  //   GERA AS VARIAVEIS DE ARMAZENAMENTO DE DADOS

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/produtos.json');
  }

  Future<void> _escreverJson(List<dynamic> jsonList) async {
    final file = await _localFile;
    final jsonString = jsonEncode(jsonList);
    await file.writeAsString(jsonString);
  }

  Future<List<dynamic>> _lerJson() async {
    try {
      final file = await _localFile;

      //Feito apenas para popular de dados, so descomente se quiser reescrever
      //pelos dados no json

      // final jsonString = await rootBundle.loadString('assets/produtos.json');
      // await file.writeAsString(jsonString);

      final contents = await file.readAsString();
      return jsonDecode(contents) as List;
    } catch (e) {
      print("Erro ao ler JSON: $e");
      return [];
    }
  }

  Future<void> _removerProduto(Map<String, dynamic> Produto) async {
    final data = await _lerJson();
    data.remove(Produto);
    await _escreverJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),
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
      floatingActionButton: ElevatedButton(
        onPressed: _removerProduto,

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
