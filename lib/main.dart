// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'models/produto_model.dart';
import 'widgets/produto_widget.dart';
import 'widgets/eletronico_widget.dart';
import 'widgets/roupa_widget.dart';
import 'widgets/alimento_widget.dart';
import 'screens/detalhe_produto_screen.dart';

import 'screens/cadastro_produtos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade300,
          selectedColor: Colors.blueGrey,
          labelStyle: const TextStyle(color: Colors.black87),
          secondaryLabelStyle: const TextStyle(color: Colors.white),
        ),
      ),
      home: const CatalogoScreen(),
    );
  }
}

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  _CatalogoScreenState createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  List<Produto> _todosProdutos = [];
  List<Produto> _produtosFiltrados = [];
  String _categoriaSelecionada = 'Todos';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

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
      if (!await file.exists()) {
        final jsonString = await rootBundle.loadString('assets/produtos.json');
        await file.writeAsString(jsonString);
      }

      final contents = await file.readAsString();
      return jsonDecode(contents) as List;
    } catch (e) {
      print("Erro ao ler JSON: $e");
      return [];
    }
  }

  Future<void> _carregarProdutos() async {
    setState(() {
      _isLoading = true;
    });
    final data = await _lerJson();
    setState(() {
      _todosProdutos = data.map((json) => Produto.fromJson(json)).toList();
      _filtrarProdutos(_categoriaSelecionada);
      _isLoading = false;
    });
  }

  void _filtrarProdutos(String categoria) {
    setState(() {
      _categoriaSelecionada = categoria;
      if (categoria == 'Todos') {
        _produtosFiltrados = _todosProdutos;
      } else {
        _produtosFiltrados = _todosProdutos.where((produto) {
          if (categoria == 'Eletrônicos') return produto is Eletronico;
          if (categoria == 'Roupas') return produto is Roupa;
          if (categoria == 'Alimentos') return produto is Alimento;
          return false;
        }).toList();
      }
    });
  }

  Future<void> _adicionarProduto(Map<String, dynamic> novoProduto) async {
    final data = await _lerJson();
    data.add(novoProduto);
    await _escreverJson(data);
    await _carregarProdutos();
  }

  void _navegarParaCadastro() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CadastroProdutoScreen(onSave: _adicionarProduto),
      ),
    );
  }

  ProdutoWidget _construirWidgetProduto(Produto produto) {
    void navegar() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DetalheProdutoScreen(produto: _construirWidgetProduto(produto)),
        ),
      );
    }

    if (produto is Eletronico) {
      return EletronicoWidget(
        nome: produto.nome,
        preco: produto.preco,
        descricao: produto.descricao,
        imageUrl: produto.imageUrl,
        marca: produto.marca,
        garantiaMeses: produto.garantiaMeses,
        onTap: navegar,
      );
    }
    if (produto is Roupa) {
      return RoupaWidget(
        nome: produto.nome,
        preco: produto.preco,
        descricao: produto.descricao,
        imageUrl: produto.imageUrl,
        tamanho: produto.tamanho,
        cor: produto.cor,
        onTap: navegar,
      );
    }
    if (produto is Alimento) {
      return AlimentoWidget(
        nome: produto.nome,
        preco: produto.preco,
        descricao: produto.descricao,
        imageUrl: produto.imageUrl,
        dataValidade: produto.dataValidade,
        calorias: produto.calorias,
        onTap: navegar,
      );
    }

    return EletronicoWidget(
      nome: "Erro",
      preco: 0,
      descricao: "",
      imageUrl: "",
      marca: "",
      garantiaMeses: 0,
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Produtos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: ['Todos', 'Eletrônicos', 'Roupas', 'Alimentos'].map((
                categoria,
              ) {
                return ChoiceChip(
                  label: Text(categoria),
                  selected: _categoriaSelecionada == categoria,
                  onSelected: (selected) {
                    if (selected) _filtrarProdutos(categoria);
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _produtosFiltrados.length,
                    itemBuilder: (context, index) {
                      final produto = _produtosFiltrados[index];
                      return _construirWidgetProduto(produto);
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                  ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _navegarParaCadastro,

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 10, 159, 246),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        child: const Text(
          "Cadastrar Produtos",
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
