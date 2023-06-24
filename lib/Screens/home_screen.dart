import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Commons/common_widget.dart';
import 'package:todo_app/Screens/Todo/todo_form.dart';
import 'package:todo_app/Services/Todo/todo_service.dart';

import '../Models/Todo/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  final TodoService todoService = TodoService();

  @override
  void initState() {
    super.initState();
    todoService.isLoading = true;
    _fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo - Application"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text('Hello Flutter', style: CommonWidget.titleText()),
          ),
          Expanded(
            child: todoService.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : todoService.todoList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: todoService.todoList.length,
                        itemBuilder: (context, index) {
                          final todo = todoService.todoList[index];
                          return _todo(todo);
                        },
                      ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  _fetchTodo() async {
    final data = await todoService.getTodoList();
    if (data != null) {
      setState(() {
        todoService.setTodoList = data;
        todoService.isLoading = false;
      });
    }
  }

  Widget _todo(TodoModel todo) {
    return Card(
      color: Colors.blue.shade200,
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.task),
        title: Text(
          todo.title,
          style: CommonWidget.secondaryTitleText(),
        ),
        subtitle: Text(todo.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 18,
              child: IconButton(
                onPressed: () {
                  _showUpdateBottomSheet(todo);
                },
                icon: const Icon(
                  Icons.edit,
                  size: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () {
                    _openConfirmDelete(todo.id!);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showCreateBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TodoForm(
              formKey: formKey,
              titleController: todoService.titleController,
              descriptionController: todoService.descriptionController,
              isUpdate: false,
              onSubmit: (model) async {
                final data = await todoService.createTodo(model);
                if (data != null) {
                  setState(() {
                    todoService.addTodo = data;
                  });
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        );
      },
    ).whenComplete((){
      todoService.titleController.clear();
      todoService.descriptionController.clear();
    });;
  }

  void _showUpdateBottomSheet(TodoModel todo) {
    todoService.titleController.text = todo.title;
    todoService.descriptionController.text = todo.description;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TodoForm(
              formKey: formKey,
              titleController: todoService.titleController,
              descriptionController: todoService.descriptionController,
              isUpdate: true,
              onSubmit: (model) async {
                model.id = todo.id;
                final data = await todoService.updateTodo(todo.id!, model);
                if (data != null) {
                  setState(() {
                    for (var todo in todoService.todoList) {
                      if (todo.id == data.id) {
                        todo.title = data.title;
                        todo.description = data.description;
                      }
                    }
                  });
                }
                setState(() {});
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        );
      },
    ).whenComplete((){
      todoService.titleController.clear();
      todoService.descriptionController.clear();
    });
  }

  void _openConfirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Are you sure you want to delete todo!',
                          style: CommonWidget.secondaryTitleText()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: CommonWidget.secondaryButtonStyle(),
                              child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: () async {
                                bool isDeleted =
                                    await todoService.deleteTodo(id);
                                if (isDeleted) {
                                  setState(() {
                                    todoService.todoList.removeWhere((todo) => todo.id == id);
                                  });
                                }
                                if(mounted){
                                  Navigator.of(context).pop();
                                }
                              },
                              style: CommonWidget.dangerButtonStyle(),
                              child: const Text('Delete')),
                        ],
                      ),
                    )
                  ],
                )));
      },
    );
  }
}
