import '../models/character_quote.dart';
import '../models/characters_model.dart';
import '../web_sevices/characters_web_services.dart';

class CharactersRepo {
  final CharactersWebServices characterWebServices;
  CharactersRepo(this.characterWebServices);

  Future<List<Character>> getCharacters() async {
    final characters = await characterWebServices.getCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<Quote> getRandomQuote() async {
    final quote = await characterWebServices.getRandomQuote();
    return Quote.fromJson(quote);
  }
}
