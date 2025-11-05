import 'package:dio/dio.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  final Dio _dio; 

  factory DioClient() => _instance;

  DioClient._internal() : _dio = _createInstance();

  static Dio _createInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://ls-lms.zoidify.my.id/api', 
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageHelper.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
    return dio;
  }
  
  Dio get dio => _dio;
}