import '../../constants/my_strings.dart';
import 'package:dio/dio.dart';

class CharactersWebServices {
  late Dio dio;
  CharactersWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      receiveDataWhenStatusError:
          true, //to give me info about the error if exist
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getCharacters() async {
    try {
      Response response =
          await dio.get('https://rickandmortyapi.com/api/character');
      print(response.data["results"][0].toString());
      return response.data["results"];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<dynamic> getRandomQuote() async {
    try {
      Response response =
          await dio.get('https://api.breakingbadquotes.xyz/v1/quotes');
      print(response.data.toString());
      return response.data[0];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
