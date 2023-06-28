import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Screens/Commons/common_widget.dart';
import 'package:todo_app/Screens/Todo/todo_form.dart';
import 'package:todo_app/Services/Todo/todo_service.dart';

import '../Models/Todo/todo_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.put(TodoService());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoService>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Todo - Application"),
          ),
          body: Obx(()=> Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text('Hello Flutter', style: CommonWidget.titleText()),
              ),
              Expanded(
                child: controller.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : controller.todoList.isEmpty
                    ? const Center(
                  child: Center(child: Text('No todo list!')),
                )
                    : ListView.builder(
                  itemCount: controller.todoList.length,
                  itemBuilder: (context, index) {
                    final todo = controller.todoList[index];
                    return _todo(todo, context);
                  },
                ),
              )
            ],
          ),),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateBottomSheet(context),
            child: const Icon(Icons.add),
          ),
        );
      }
    );
  }

  Widget _todo(TodoModel todo, BuildContext context) {
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
                  _showUpdateBottomSheet(todo, context);
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
                    _openConfirmDelete(todo.id!, context);
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

  void _showCreateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TodoForm(
              formKey: controller.formKey,
              titleController: controller.titleController,
              descriptionController: controller.descriptionController,
              isUpdate: false,
              onSubmit: (model) async {
                await controller.createTodo(model);
                Get.back();
              },
            ),
          ),
        );
      },
    ).whenComplete((){
      controller.titleController.clear();
      controller.descriptionController.clear();
    });;
  }

  void _showUpdateBottomSheet(TodoModel todo, BuildContext context) {
    controller.titleController.text = todo.title;
    controller.descriptionController.text = todo.description;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TodoForm(
              formKey: controller.formKey,
              titleController: controller.titleController,
              descriptionController: controller.descriptionController,
              isUpdate: true,
              onSubmit: (model) async {
                model.id = todo.id;
                await controller.updateTodo(todo.id!, model);
                Get.back();
              },
            ),
          ),
        );
      },
    ).whenComplete((){
      controller.titleController.clear();
      controller.descriptionController.clear();
    });
  }

  void _openConfirmDelete(int id, BuildContext context) {
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
                                await controller.deleteTodo(id);
                                if (isDeleted) {
                                  controller.todoList.removeWhere((todo) => todo.id == id);
                                }
                                Get.back();
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
