import 'dart:io';

import 'package:dio/dio.dart';

class ImgBBService {
  final Dio _dio = Dio();
  final String _apiKey = 'cb3cf89c0fb400823807c4b1f2c609f4';
  final String _endpoint = 'https://api.imgbb.com/1/upload';

  Future<String?> uploadImage(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        'key': _apiKey,
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post(_endpoint, data: formData);

      if (response.statusCode == 200) {
        return response.data['data']['url'];
      } else {
        print('Erro no upload da imagem: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro no upload da imagem: $e');
      return null;
    }
  }
}
