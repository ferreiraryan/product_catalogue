import 'package:flutter/material.dart';

class CadastroProdutoScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const CadastroProdutoScreen({super.key, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _CadastroProdutoScreenState createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _categoriaSelecionada;

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _descricaoController = TextEditingController();

  final _marcaController = TextEditingController();
  final _garantiaController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _corController = TextEditingController();
  final _validadeController = TextEditingController();
  final _caloriasController = TextEditingController();

  @override
  void dispose() {
    // Limpar os controladores para evitar vazamento de memória
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvarProduto() {
    if (_formKey.currentState!.validate()) {
      final novoProduto = <String, dynamic>{
        'categoria': _categoriaSelecionada,
        'nome': _nomeController.text,
        'preco': double.tryParse(_precoController.text) ?? 0.0,
        'descricao': _descricaoController.text,
        'imageUrl': '',
      };

      // Adiciona os campos específicos da categoria
      switch (_categoriaSelecionada) {
        case 'eletronico':
          novoProduto['marca'] = _marcaController.text;
          novoProduto['garantiaMeses'] =
              int.tryParse(_garantiaController.text) ?? 0;
          break;
        case 'roupa':
          novoProduto['tamanho'] = _tamanhoController.text;
          novoProduto['cor'] = _corController.text;
          break;
        case 'alimento':
          novoProduto['dataValidade'] = _validadeController.text;
          novoProduto['calorias'] = int.tryParse(_caloriasController.text) ?? 0;
          break;
      }

      widget.onSave(novoProduto);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Novo Produto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              hint: const Text('Selecione a Categoria'),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSelecionada = newValue;
                });
              },
              items: <String>['eletronico', 'roupa', 'alimento']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value[0].toUpperCase() + value.substring(1)),
                    );
                  })
                  .toList(),
              validator: (value) => value == null ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            if (_categoriaSelecionada == 'eletronico') ...[
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextFormField(
                controller: _garantiaController,
                decoration: const InputDecoration(
                  labelText: 'Garantia (meses)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            if (_categoriaSelecionada == 'roupa') ...[
              TextFormField(
                controller: _tamanhoController,
                decoration: const InputDecoration(labelText: 'Tamanho'),
              ),
              TextFormField(
                controller: _corController,
                decoration: const InputDecoration(labelText: 'Cor'),
              ),
            ],
            if (_categoriaSelecionada == 'alimento') ...[
              TextFormField(
                controller: _validadeController,
                decoration: const InputDecoration(
                  labelText: 'Data de Validade',
                ),
              ),
              TextFormField(
                controller: _caloriasController,
                decoration: const InputDecoration(labelText: 'Calorias'),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarProduto,
              child: const Text('Salvar Produto'),
            ),
          ],
        ),
      ),
    );
  }
}
