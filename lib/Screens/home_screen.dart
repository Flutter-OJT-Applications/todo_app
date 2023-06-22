import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Commons/common_widget.dart';
import 'package:todo_app/Screens/Todo/todo_form.dart';

import '../Models/Todo/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TodoModel> todoList = [];
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

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
            child: todoList.isEmpty
                ? const Center(
                    child: Text('No todo list!'),
                  )
                : ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      var todo = todoList[index];
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
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, size: 18,),
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
              titleController: titleController,
              descriptionController: descriptionController,
              isUpdate: false,
              onSubmit: (model) {
                model.setId = UniqueKey().hashCode;
                setState(() {
                  todoList.add(model);
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
