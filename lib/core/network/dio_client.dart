import 'package:dio/dio.dart';
import 'package:flutter_manga_sync/core/constants/api_constants.dart';
import 'package:flutter_manga_sync/core/network/auth_interceptor.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';

class DioClient {
  final Dio dio;

  DioClient(SecureStorageService secureStorageService)
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/vnd.api+json',
            'Accept': 'application/vnd.api+json',
          },
        ),
      ) {
    dio.interceptors.add(AuthInterceptor(secureStorageService));
  }
}
