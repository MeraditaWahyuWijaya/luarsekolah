import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://ls-lms.zoidify.my.id/api';
  final String _apiUrlV1 = 'https://ls-lms.zoidify.my.id/api/v1';

  String? _accessToken;
  String? get accessToken => _accessToken;

  Map<String, String> get _authHeaders {
    if (_accessToken == null) {
      throw Exception('Akses ditolak. Mohon login terlebih dahulu.');
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_accessToken',
    };
  }

  Future<void> signUp({
    required String name, 
    required String email, 
    required String phone, 
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/sign-up/email'); 
    
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'phone': phone, 
        'password': password,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Gagal registrasi.';
      throw Exception('Registrasi Gagal. Status: ${response.statusCode}. Pesan: $message');
    }
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/sign-in/email');
    
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['data'] != null && data['data']['accessToken'] != null) {
          _accessToken = data['data']['accessToken'];
      } else {
          throw Exception("Login berhasil, tapi token tidak ditemukan dalam respons.");
      }
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Gagal login.';
      throw Exception('Login Gagal. Status: ${response.statusCode}. Pesan: $message');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final url = Uri.parse('$_apiUrlV1/courses'); 
    
    final response = await http.get(
      url,
      headers: _authHeaders,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] is List) {
          return (data['data'] as List).map((item) => item as Map<String, dynamic>).toList();
      }
      throw Exception('Format data kursus tidak sesuai.');
    } else {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Gagal memuat data kursus.';
      throw Exception('Gagal memuat data kursus. Status: ${response.statusCode}. Pesan: $message');
    }
  }
  
  Future<void> createCourse({
    required String name, 
    required String price, 
    required String category, 
    required String thumbnailUrl,
  }) async {
    final url = Uri.parse('$_apiUrlV1/courses'); 
    
    final priceInt = int.tryParse(price) ?? 0;

    final response = await http.post(
      url,
      headers: _authHeaders,
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'price': priceInt, 
        'category': category,
        'thumbnailUrl': thumbnailUrl, 
      }),
    );
    
    if (response.statusCode != 201) {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Gagal menambahkan kelas baru.';
      throw Exception('Gagal menambahkan kelas baru. Status: ${response.statusCode}. Pesan: $message');
    }
  }
  
  Future<void> updateCourse({
    required String courseId,
    required String name, 
    required String price, 
    required String category, 
    required String thumbnailUrl,
  }) async {
    final url = Uri.parse('$_apiUrlV1/courses/$courseId'); 
    
    final priceInt = int.tryParse(price) ?? 0;

    final response = await http.put(
      url,
      headers: _authHeaders,
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'price': priceInt, 
        'category': category,
        'thumbnailUrl': thumbnailUrl, 
      }),
    );
    
    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Gagal memperbarui kelas.';
      throw Exception('Gagal memperbarui kelas $courseId. Status: ${response.statusCode}. Pesan: $message');
    }
  }

  Future<void> deleteCourse(String courseId) async {
    final url = Uri.parse('$_apiUrlV1/courses/$courseId'); 

    final response = await http.delete(
      url,
      headers: _authHeaders,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'Gagal menghapus kelas.';
      throw Exception('Gagal menghapus kelas $courseId. Status: ${response.statusCode}. Pesan: $message');
    }
  }
}