import 'package:flutter/material.dart';

//Tudo no flutter é um widget, inclusive o App como um todo

//função main que roda o App
void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Todo App',
        theme: ThemeData(primaryColor: Colors.black),
        home: new TodoList());
  }
}

//widget para mudar os estados
class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  //mensagem pra setar a tarefa como completa, se completa apaga, ou cancela a remoção

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Marcar "${_todoItems[index]}" como completa?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCELAR'),
                    // The alert is actually part of the navigation stack, so to close it, we
                    // need to pop it.
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('Marcar como Completa'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  // Contrói a lista de tarefas/itens
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

  // constrói uma tarefa/item só
  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo App'),
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          backgroundColor: Colors.black,
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well as adding
        // a back button to close it
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text('Adicionar tarefa'),
          ),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // fecha a página de adicionar
            },
            decoration: new InputDecoration(
                hintText: 'Escreva a tarefa...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
