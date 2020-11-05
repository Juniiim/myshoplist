import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_data.dart';

class HomeItemNewEdit extends StatefulWidget {
  final Item item;
  final String appBarTitle;

  HomeItemNewEdit({
    @required this.item,
    @required this.appBarTitle,
  });

  @override
  _HomeItemNewEditState createState() => _HomeItemNewEditState();
}

class _HomeItemNewEditState extends State<HomeItemNewEdit> {
  TextEditingController _textEditingControllerNome =
      TextEditingController(text: '');
  TextEditingController _textEditingControllerQuantidade =
      TextEditingController(text: '0');
  TextEditingController _textEditingControllerPreco =
      TextEditingController(text: 'R\$ 0,00');
  bool boolAddingNew;

  @override
  void initState() {
    super.initState();

    boolAddingNew = (widget.item == null);

    if (!boolAddingNew) {
      _textEditingControllerNome =
          TextEditingController(text: widget.item.nome);
      _textEditingControllerQuantidade =
          TextEditingController(text: '${widget.item.quantidade}');
      _textEditingControllerPreco =
          TextEditingController(text: currencyFormat(widget.item.preco));
    }

    _textEditingControllerQuantidade.addListener(
      () {
        String stringResult = _textEditingControllerQuantidade.text
            .padLeft(1, '0')
            .replaceAll(RegExp(r'^0+(?=.)'), '');

        _textEditingControllerQuantidade.value =
            _textEditingControllerQuantidade.value.copyWith(
          composing: TextRange.empty,
          text: stringResult,
          selection: TextSelection(
            baseOffset: stringResult.length,
            extentOffset: stringResult.length,
          ),
        );
      },
    );

    _textEditingControllerPreco.addListener(
      () {
        _textEditingControllerPreco.value =
            _textEditingControllerPreco.value.copyWith(
          composing: TextRange.empty,
          text: _textEditingControllerPreco.text,
          selection: TextSelection(
            baseOffset: _textEditingControllerPreco.text.length,
            extentOffset: _textEditingControllerPreco.text.length,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingControllerNome.dispose();
    _textEditingControllerQuantidade.dispose();
    _textEditingControllerPreco.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              autofocus: true,
              controller: _textEditingControllerNome,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Você deve preencher um nome.';
                }
                return null;
              },
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _textEditingControllerQuantidade,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantidade',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.all(8.0)),
              Expanded(
                child: TextFormField(
                  controller: _textEditingControllerPreco,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Preço',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                ),
              ),
            ]),
            Padding(padding: const EdgeInsets.all(8.0)),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.all(4.0)),
              Expanded(
                child: ElevatedButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print(_textEditingControllerPreco.text);
                      final Item item = new Item(
                        done: boolAddingNew ? false : widget.item.done,
                        nome: _textEditingControllerNome.text,
                        preco: (double.parse(_textEditingControllerPreco.text
                            .replaceAll(RegExp('[^-,0-9]'), '')
                            .replaceAll(',', '.'))),
                        quantidade:
                            int.parse(_textEditingControllerQuantidade.text),
                      );
                      Navigator.pop(context, item);
                    }
                  },
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
