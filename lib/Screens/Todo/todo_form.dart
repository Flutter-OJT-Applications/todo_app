import 'package:flutter/material.dart';
import 'package:todo_app/Models/Todo/todo_model.dart';
import 'package:todo_app/Screens/Commons/common_widget.dart';
import 'package:todo_app/Screens/Commons/config.dart';

class TodoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final FormSubmitCallback onSubmit;
  final bool isUpdate;

  const TodoForm(
      {super.key,
      required this.formKey,
      required this.titleController,
      required this.descriptionController,
      required this.isUpdate,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(isUpdate ? 'Update Todo' : 'Create Todo',
                style: CommonWidget.titleText()),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: titleController,
              decoration: CommonWidget.inputStyle(placeholder: 'Enter title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration:
                  CommonWidget.inputStyle(placeholder: 'Enter description'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    onSubmit(TodoModel(
                      title: titleController.text,
                      description: descriptionController.text,
                    ));
                  },
                  style: CommonWidget.primaryButtonStyle(),
                  child: Text(isUpdate ? "Update" : "Create"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
