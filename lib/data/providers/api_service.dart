import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:luarsekolah/data/providers/storage_helper.dart';
import 'dart:io';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  final String _baseUrl = 'https://ls-lms.zoidify.my.id/api';

  // Catatan: _accessToken ini harus diisi secara manual 
  // setelah berhasil login menggunakan sistem otentikasi API lama
  // Jika kamu sudah pindah total ke Firebase, token ini mungkin tidak lagi relevan
  // untuk data user, tetapi mungkin masih relevan untuk data kursus.
  String? _accessToken;

  // Dipanggil saat aplikasi diinisialisasi
  Future<void> initializeToken() async {
    _accessToken ??= await StorageHelper.getAccessToken();
  }
  
  // Set token secara manual (misalnya setelah login via API lama)
  // Ini mungkin kamu butuhkan jika API lama masih dipakai untuk kursus
  void setAccessToken(String token) {
    _accessToken = token;
  }

  Future<Map<String, String>> getAuthHeaders({bool isMultipart = false}) async { 
    _accessToken ??= await StorageHelper.getAccessToken();

    if (_accessToken == null) {
      // PENTING: Untuk API lama, kita masih harus throw error jika token tidak ada
      throw Exception('Akses ditolak. Mohon login terlebih dahulu (Memerlukan token API lama).');
    }
    
    if (isMultipart) {
      return {
        'Authorization': 'Bearer $_accessToken',
      };
    }
    
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_accessToken',
    };
  }

  // --- METODE AUTH LAMA DIHAPUS, DIGANTIKAN OLEH FIREBASE AUTH SERVICE ---

  Future<List<Map<String, dynamic>>> fetchCourses(String category) async { 
    String endpointPath = '/courses'; 
    final headers = await getAuthHeaders();
    
    String tag = '';
    if (category.toLowerCase() == 'populer') {
      tag = 'prakerja'; 
    } else if (category.toLowerCase() == 'spl') {
      tag = 'spesial'; 
    }

    Map<String, String> queryParameters = {
      'limit': '10', 
      'offset': '0',
    };
    if (tag.isNotEmpty) {
      queryParameters['categoryTag[0]'] = tag;
    }
    
    final uri = Uri.parse('$_baseUrl$endpointPath').replace(queryParameters: queryParameters); 
    
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['data'] is List) {
          return (data['data'] as List).map((item) => item as Map<String, dynamic>).toList();
      } else if (data['data'] == null) {
          return [];
      }
      
      throw Exception('Format data kursus tidak sesuai. Respon server tidak valid.');
    } else {
      String message = 'Gagal memuat data kursus. Status: ${response.statusCode}';
      if (response.body.isNotEmpty) { 
          try {
              final errorData = jsonDecode(response.body);
              message = errorData['message'] ?? 'Gagal memuat data kursus. Status: ${response.statusCode}';
          } catch (_) {
              message = 'Gagal memuat data kursus: ${response.body}. Status: ${response.statusCode}';
          }
      }
      throw Exception(message);
    }
  }
  
  Future<void> createCourseWithImage({
    required String name, 
    required String price, 
    required String category, 
    required File imageFile,
  }) async {
    final url = Uri.parse('$_baseUrl/courses'); 
    final formattedPrice = double.tryParse(price)?.toStringAsFixed(2) ?? '0.00';
    
    final headers = await getAuthHeaders(isMultipart: true);

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    
    request.fields['name'] = name;
    request.fields['price'] = formattedPrice;
    request.fields['categoryTag[0]'] = category;
    
    request.files.add(
        await http.MultipartFile.fromPath(
            'thumbnail', 
            imageFile.path,
        )
    );
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode != 201 && response.statusCode != 200) { 
      String message = 'Gagal menambahkan kelas baru. Status: ${response.statusCode}';

      if (response.body.isNotEmpty) {
        try {
          final errorData = jsonDecode(response.body);
          message = errorData['message'] ?? 'Error status ${response.statusCode}. Pesan server tidak jelas.';
        } catch (_) {
          message = 'Server merespons non-JSON: ${response.body}. Status: ${response.statusCode}';
        }
      }
      
      throw Exception(message); 
    }
  }
  
  Future<void> createCourseWithoutImage({
    required String name, 
    required String price, 
    required String category, 
    required String thumbnailUrl,
  }) async {
    final url = Uri.parse('$_baseUrl/courses'); 
    final formattedPrice = double.tryParse(price)?.toStringAsFixed(2) ?? '0.00';
    final headers = await getAuthHeaders();

    final payload = jsonEncode({
      'name': name,
      'price': formattedPrice,
      'categoryTag': [category], 
      'thumbnail': thumbnailUrl,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: payload,
    );
    
    if (response.statusCode != 201 && response.statusCode != 200) { 
      String message = 'Gagal menambahkan kelas baru via URL.';

      if (response.body.isNotEmpty) {
        try {
          final errorData = jsonDecode(response.body);
          message = errorData['message'] ?? 'Error status ${response.statusCode}. Pesan server tidak jelas.';
        } catch (_) {
          message = 'Server merespons non-JSON: ${response.body}. Status: ${response.statusCode}';
        }
      }
      
      throw Exception(message); 
    }
  }

  Future<void> updateCourse({
    required String courseId,
    required String name, 
    required String price, 
    required String category, 
    required String thumbnailUrl,
  }) async {
    final url = Uri.parse('$_baseUrl/course/$courseId'); 
    
    final formattedPrice = double.tryParse(price)?.toStringAsFixed(2) ?? '0.00';
    final headers = await getAuthHeaders();

    final payload = jsonEncode({
      "data": { 
        'name': name,
        'price': formattedPrice, 
        'categoryTag': [category], 
        'thumbnail': thumbnailUrl,
      }
    });

    final response = await http.put(
      url,
      headers: headers,
      body: payload,
    );
    
    if (response.statusCode != 200) {
      String message = 'Gagal memperbarui kelas.';
      if (response.body.isNotEmpty) {
          try {
              final errorData = jsonDecode(response.body);
              message = errorData['message'] ?? 'Gagal memperbarui kelas. Status: ${response.statusCode}';
          } catch (_) {
              message = 'Gagal memperbarui kelas: ${response.body}. Status: ${response.statusCode}';
          }
      }
      throw Exception(message);
    }
  }

  Future<void> deleteCourse(String courseId) async {
    final url = Uri.parse('$_baseUrl/course/$courseId'); 
    final headers = await getAuthHeaders();

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      String message = 'Gagal menghapus kelas.';
      if (response.body.isNotEmpty) {
          try {
              final errorData = jsonDecode(response.body);
              message = errorData['message'] ?? 'Gagal menghapus kelas. Status: ${response.statusCode}';
          } catch (_) {
              message = 'Gagal menghapus kelas: ${response.body}. Status: ${response.statusCode}';
          }
      }
      throw Exception(message);
    }
  }
}