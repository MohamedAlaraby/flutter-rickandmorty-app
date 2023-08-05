import 'package:bloc_playlist/data/models/character_quote.dart';
import 'package:bloc_playlist/data/models/characters_model.dart';
import 'package:bloc_playlist/data/repository/character_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepo repository;
  List<Character> characters = [];
  Quote? quote;

  CharactersCubit({required this.repository}) : super(CharactersInitial());
  static CharactersCubit get(context) =>
      BlocProvider.of<CharactersCubit>(context);
  List<Character>? getCharacters() {
    repository.getCharacters().then((characters) {
      emit(CharactersLoaddedState(characters: characters));
      this.characters = characters;
    });
    return characters;
  }

  void getRandomQuote() {
    repository.getRandomQuote().then((quote) {
      emit(QuoteLoaddedState(quote: quote));
    });
  }
}
