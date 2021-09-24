
import 'package:dio/dio.dart';
import 'package:phytopathy_prediction/common/error_handler.dart';

class Network{

  Network._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://47.94.169.41:8081/'
    ),
  );


  static late final Network _instance;
  static bool _initialized = false;

  static Network get instance{
    if(!_initialized){
      _instance = Network._();
      _initialized = true;
    }
    return _instance;
  }

  Future<dynamic?> post(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {

    try{
      final result = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress
      );

      if(result.statusCode == 200){
        return result.data;
      }else{
        return null;
      }
    }
    catch(e,s){
      errorPrintHandler(e, s);
    }
  }

  Future<dynamic?> get(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {

    try{
      final result = await _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress
      );

      if(result.statusCode == 200){
        return result.data;
      }else{
        return null;
      }
    }
    catch(e,s){
      errorPrintHandler(e, s);
    }
  }
}