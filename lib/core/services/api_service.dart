import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ratek/core/constants/app_constants.dart';

class ApiService {
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        responseType: ResponseType.json,
      ),
    );
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          // final token = await getAuthToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(_handleError(error));
        },
      ),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  DioException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioException(
          requestOptions: error.requestOptions,
          error: AppConstants.networkError,
        );
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      default:
        return DioException(
          requestOptions: error.requestOptions,
          error: AppConstants.unknownError,
        );
    }
  }

  DioException _handleResponseError(DioException error) {
    if (error.response?.statusCode == 401) {
      // Handle unauthorized error
      return DioException(
        requestOptions: error.requestOptions,
        error: 'Unauthorized access',
      );
    } else if (error.response?.statusCode == 404) {
      return DioException(
        requestOptions: error.requestOptions,
        error: 'Resource not found',
      );
    } else {
      return DioException(
        requestOptions: error.requestOptions,
        error: error.response?.data?['message'] ?? AppConstants.serverError,
      );
    }
  }
} 