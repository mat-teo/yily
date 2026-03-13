// services/api_service.dart
import 'package:dio/dio.dart';
import 'package:yily_app/models/reason.dart';
import 'package:yily_app/services/storage_service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api/v0.1.0',  // backend url
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService().getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Crea coppia
  Future<Map<String, dynamic>> createCouple(String name) async {
    final response = await _dio.post('/couples/', data: {'name': name});
    final token = response.data['access_token'];
    await StorageService().saveToken(token);
    return response.data;
  }

  // Join coppia
  Future<Map<String, dynamic>> joinCouple(String token, String name) async {
    final response = await _dio.post('/couples/join', data: {'token': token, 'name': name});
    final accessToken = response.data['access_token'];
    await StorageService().saveToken(accessToken);
    return response.data;
  }

  // Recover
  Future<Map<String, dynamic>> recover(String token, String name) async {
    final response = await _dio.post('/auth/recover', data: {'token': token, 'name': name});
    final accessToken = response.data['access_token'];
    await StorageService().saveToken(accessToken);
    return response.data;
  }

  // Aggiungi motivo
  Future<Reason> addReason(String content) async {
    final response = await _dio.post('/reasons/', data: {
      'content': content
    });
    return Reason.fromJson(response.data);
  }

  // Lista motivi ricevuti
  Future<List<Reason>> getReceivedReasons() async {
    final response = await _dio.get('/reasons/my', queryParameters: {'received_only': true});
    return (response.data as List).map((json) => Reason.fromJson(json)).toList();
  }

  // Counts
  Future<Map<String, dynamic>> getCounts() async {
    final response = await _dio.get('/reasons/counts');
    return response.data;
  }

  // Random
  Future<Reason?> getRandomReason() async {
    final response = await _dio.get('/reasons/random');
    if (response.statusCode == 404) return null;
    return Reason.fromJson(response.data);
  }

  // Delete reason
  Future<void> deleteReason(int id) async {
    await _dio.delete('/reasons/$id');
  }

}