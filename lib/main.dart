// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'models/produto_model.dart';
import 'widgets/produto_widget.dart';
import 'widgets/eletronico_widget.dart';
import 'widgets/roupa_widget.dart';
import 'widgets/alimento_widget.dart';
import 'screens/detalhe_produto_screen.dart';

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

  Future<void> _carregarProdutos() async {
    final String response = await rootBundle.loadString('assets/produtos.json');
    final data = await json.decode(response) as List;

    setState(() {
      _todosProdutos = data.map((json) => Produto.fromJson(json)).toList();
      _produtosFiltrados = _todosProdutos;
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
    );
  }
}
