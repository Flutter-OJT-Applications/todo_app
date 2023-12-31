import 'package:flutter/material.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Services/Commons/entity_service.dart';

final entityManager = EntityService();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await entityManager.initialize();
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget{
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo Application',
      home: HomeScreen(),
    );
  }
}