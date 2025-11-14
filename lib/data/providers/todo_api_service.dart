import 'package:dio/dio.dart';
import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/data/providers/dio_client.dart'; 

class TodoApiService {
  final Dio _client = DioClient().dio;

  Future<List<Todo>> fetchTodos({bool? completed}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/todos',
        queryParameters: {
          if (completed != null) 'completed': completed,
          'limit': 30,
        },
      );
      final data = response.data;
      if (data == null || data['todos'] is! List<dynamic>) {
        throw Exception('Response tidak valid dari server');
      }
      return (data['todos'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(Todo.fromJson)
          .toList();
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    }
  }

  Future<Todo> createTodo(String text, String description) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/todos',
        data: {'text': text, 'description': description, 'completed': false},
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Server mengembalikan data kosong');
      }
      return Todo.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    }
  }

  Future<Todo> toggleTodo(String id) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        '/todos/$id/toggle',
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Server mengembalikan data kosong');
      }
      return Todo.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _client.delete<void>('/todos/$id');
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    }
  }

  String _mapDioError(DioException error) {
    final status = error.response?.statusCode;
    final responseData = error.response?.data;
    
    String message = 'Terjadi kesalahan pada server';

    if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
      message = responseData['message'] as String;
    } else if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Koneksi melebihi batas waktu.';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Tidak dapat terhubung ke server.';
    } else if (error.message != null) {
      message = error.message!;
    }

    return '(${status ?? 'N/A'}) $message';
  }
}
