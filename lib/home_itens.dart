import 'package:flutter/material.dart';

import 'common_data.dart';
import 'home_item_new_edit.dart';

class HomeItens extends StatefulWidget {
  final Compra compra;

  HomeItens({@required this.compra});

  @override
  _HomeItensState createState() => _HomeItensState();
}

class _HomeItensState extends State<HomeItens> {
  int intSelectedIndex;
  bool boolSelectingMode = false;

  @override
  Widget build(BuildContext context) {
    double doubleTotalDaCompra = 0;

    widget.compra.itens.forEach((Item element) {
      if (element.done)
        doubleTotalDaCompra += (element.preco * element.quantidade);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.compra.nome,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.compra.itens.length,
          itemBuilder: (context, index) {
            Item item = widget.compra.itens[index];
            Color color;
            TextDecoration textDecoration;

            if (item.done) {
              color = Colors.black12;
              textDecoration = TextDecoration.lineThrough;
            }

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              isThreeLine: true,
              title: Text(
                item.nome,
                style: TextStyle(
                  color: color,
                  decoration: textDecoration,
                ),
              ),
              subtitle: Text(
                ('Quantidade: ${item.quantidade}\nPreço unitário: ' +
                    '${currencyFormat(item.preco)}'),
                style: TextStyle(
                  color: color,
                  decoration: textDecoration,
                ),
              ),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: item.done,
                    onChanged: (value) {
                      setState(() {
                        item.done = value;
                      });
                    },
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${currencyFormat(item.preco * item.quantidade)}',
                    style: TextStyle(
                      color: color,
                      decoration: textDecoration,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              onTap: () async {
                Item result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeItemNewEdit(
                      item: widget.compra.itens[index],
                      appBarTitle: 'Editar Item',
                    ),
                  ),
                );
                setState(() {
                  if (result != null) widget.compra.itens[index] = result;
                });
              },
              onLongPress: () {
                setState(() {
                  intSelectedIndex = index;
                  boolSelectingMode = true;
                });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Item result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeItemNewEdit(
                item: null,
                appBarTitle: 'Adicionar Item',
              ),
            ),
          );
          setState(() {
            if (result != null) widget.compra.itens.add(result);
          });
        },
        tooltip: 'Novo Item',
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo[500],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total no carrinho:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${currencyFormat(doubleTotalDaCompra)}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
