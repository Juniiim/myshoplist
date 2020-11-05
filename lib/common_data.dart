import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Compras comprasDados;

final String stringLocale = 'pt_BR';

Future<Compras> getDados() async {
  String directory = (await getApplicationDocumentsDirectory()).path;
  try {
    return Compras.fromJson(
      jsonDecode(await File('$directory/data.json').readAsString()),
    );
  } catch (e) {
    return Compras(compras: new List<Compra>());
  }
}

writeDados(String jsonData) async {
  final directory = await getApplicationDocumentsDirectory();
  await File('${directory.path}/data.json').writeAsString(jsonData);
}

class Compras {
  List<Compra> compras;

  Compras({this.compras});

  Compras.fromJson(Map<String, dynamic> json) {
    if (json['compras'] != null) {
      compras = new List<Compra>();
      json['compras'].forEach((v) {
        compras.add(new Compra.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.compras != null) {
      data['compras'] = this.compras.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Compra {
  String nome;
  List<Item> itens;

  Compra({this.nome, this.itens});

  Compra.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    if (json['itens'] != null) {
      itens = new List<Item>();
      json['itens'].forEach((v) {
        itens.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    if (this.itens != null) {
      data['itens'] = this.itens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String nome;
  double preco;
  int quantidade;
  bool done;

  Item({this.nome, this.preco, this.quantidade, this.done});

  Item.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    preco = json['preco'];
    quantidade = json['quantidade'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['preco'] = this.preco;
    data['quantidade'] = this.quantidade;
    data['done'] = this.done;
    return data;
  }
}

String currencyFormat(value) {
  final formatter = new NumberFormat('#,##0.00', 'pt_BR');
  return 'R\$ ' + formatter.format(value);
}

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    double value = double.parse(newValue.text);
    final formatter = new NumberFormat('#,##0.00', stringLocale);
    String newText = 'R\$ ' + formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
