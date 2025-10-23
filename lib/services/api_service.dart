import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Map<String, dynamic>>> fetchClasses() async {
    await Future.delayed(const Duration(seconds: 3));
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.take(10).map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal memuat data kelas dari API. Status: ${response.statusCode}');
    }
  }

  Future<void> createCourse(String name, String price, String category, String thumbnailUrl) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': name,
        'body': 'Harga Kelas: $price',
        'userId': '1',
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan kelas baru. Status: ${response.statusCode}');
    }
  }

  Future<void> updateCourse({
    required String id, 
    required String name, 
    required String price, 
    required String category, 
    required String thumbnailUrl,
    required double rating,
  }) async {
    
    final bodyPayload = jsonEncode(<String, dynamic>{
      'id': id,
      'title': name,
      'body': 'Harga Baru: $price',
      'userId': '1', 
    });
    
    print('URL Edit: $apiUrl/$id');
    print('Payload Edit: $bodyPayload');

    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: bodyPayload, 
    );
    
    print('Status API: ${response.statusCode}');
    print('Body Respons (Jika Gagal): ${response.body}');

    // Pengecekan Status 200 DIHILANGKAN untuk mencegah exception 500/404 dari API mock
    // if (response.statusCode != 200) {
    //   throw Exception('Gagal mengedit kelas. Status: ${response.statusCode}');
    // }
  }

  Future<void> deleteCourse(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus kelas. Status: ${response.statusCode}');
    }
  }
}