import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_data.dart';
import 'home_itens.dart';

class HomeCompra extends StatefulWidget {
  @override
  _HomeCompraState createState() => _HomeCompraState();
}

class _HomeCompraState extends State<HomeCompra> with WidgetsBindingObserver {
  int intSelectedIndex;
  bool boolSelectingMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
        writeDados(jsonEncode(comprasDados));
        break;
      case AppLifecycleState.paused:
        writeDados(jsonEncode(comprasDados));
        break;
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (boolSelectingMode) {
          setState(() {
            cleanSelection();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('Lista de compras'),
            actions: boolSelectingMode
                ? <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: 'Editar Lista',
                      onPressed: () {
                        showTextInputDialog(
                          'Nome',
                          comprasDados.compras[intSelectedIndex].nome,
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              comprasDados.compras[intSelectedIndex].nome =
                                  value;
                            });
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: 'Apagar Lista',
                      onPressed: () {
                        setState(() {
                          comprasDados.compras.removeAt(intSelectedIndex);
                          cleanSelection();
                        });
                      },
                    ),
                  ]
                : null,
            leading: boolSelectingMode
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        cleanSelection();
                      });
                    },
                  )
                : null),
        body: ListView.builder(
          itemCount: comprasDados.compras.length,
          itemBuilder: (context, index) {
            final Compra _compra = comprasDados.compras[index];
            return ListTile(
              selected: index == intSelectedIndex,
              title: Text(_compra.nome),
              onLongPress: () {
                setState(() {
                  boolSelectingMode = true;
                  intSelectedIndex = index;
                });
              },
              onTap: () {
                if (boolSelectingMode) {
                  setState(() {
                    intSelectedIndex = index;
                  });
                } else {
                  setState(() {
                    cleanSelection();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeItens(compra: _compra),
                    ),
                  );
                }
              },
            );
          },
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(''),
                decoration: BoxDecoration(
                  color: Colors.indigo[500],
                ),
              ),
              AboutListTile(
                aboutBoxChildren: [Text('aboutBoxChildren')],
                applicationIcon: Icon(Icons.note_add_sharp),
                applicationLegalese: 'applicationLegalese',
                applicationName: 'applicationName',
                applicationVersion: 'applicationVersion',
                icon: Icon(Icons.admin_panel_settings),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Nova Lista',
          onPressed: () {
            showTextInputDialog(
              'Nome',
              'Lista em ' +
                  DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, stringLocale)
                      .format(DateTime.now().toLocal()),
            ).then(
              (value) {
                if (value != null)
                  setState(() {
                    comprasDados.compras
                        .add(Compra(nome: value, itens: new List<Item>()));
                    writeDados(jsonEncode(comprasDados));
                  });
              },
            );
          },
        ),
      ),
    );
  }

  showTextInputDialog(String labelText, String hintText) async {
    final TextEditingController _textEditingController =
        TextEditingController(text: hintText);
    final _formKey = GlobalKey<FormState>();

    _textEditingController.value = _textEditingController.value.copyWith(
      composing: TextRange.empty,
      text: _textEditingController.text,
      selection: TextSelection(
        baseOffset: 0,
        extentOffset: _textEditingController.text.length,
      ),
    );

    String returnVal = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            controller: _textEditingController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: labelText,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Você deve preencher um nome.';
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
          FlatButton(
            child: Text('Salvar'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(context, _textEditingController.text);
              }
            },
          )
        ],
      ),
    );
    return returnVal;
  }

  void cleanSelection() {
    boolSelectingMode = false;
    intSelectedIndex = null;
  }
}
