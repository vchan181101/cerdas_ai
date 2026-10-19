import 'package:dio/dio.dart';
import '../../core/core.dart';

/// Interceptor untuk mencetak log request dan response API secara rapi
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerUtil.debug('--> ${options.method} ${options.uri}');
    if (options.data != null) {
      LoggerUtil.debug('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerUtil.info('<-- ${response.statusCode} ${response.requestOptions.uri}');
    LoggerUtil.debug('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerUtil.error(
      'NETWORK ERROR: ${err.message}',
      err.response?.data,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}
