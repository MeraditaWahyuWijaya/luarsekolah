import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoDetailPage extends StatelessWidget { 
  const TodoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Logic untuk mengambil ID dari Deep Link
    final String? todoId = Get.parameters['id'];
    
    return Scaffold(
      appBar: AppBar(title: const Text('Detail To-Do')),
      body: Center(
        child: Text('Memuat detail untuk To-Do ID: ${todoId ?? "ID tidak ditemukan"}'),
      ),
    );
  }
}