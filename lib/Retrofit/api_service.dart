import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'user.dart';

part 'api_service.g.dart';

// flutter pub run build_runner build --delete-conflicting-outputs
@RestApi(baseUrl: "https://reqres.in/api/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  
  @GET("users?page=2")
  Future<DemoApiModel> getUsers();
}
