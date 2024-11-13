import 'package:dio/dio.dart';

class ReqresService {
  final Dio _dio = Dio();
  final String _endpoint = 'https://reqres.in/api/users';

  Future<void> sendUserData(
      String name, String email, String description) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "description": description,
      };

      final response = await _dio.post(_endpoint, data: data);

      if (response.statusCode == 201) {
        print("Dados enviados com sucesso para o Reqres!");
      } else {
        print("Erro ao enviar dados para o Reqres: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao enviar dados para o Reqres: $e");
    }
  }
}
