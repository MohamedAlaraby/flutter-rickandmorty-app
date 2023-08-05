part of 'characters_cubit.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoaddedState extends CharactersState {
  final List<Character> characters;

  CharactersLoaddedState({required this.characters});
}

class QuoteLoaddedState extends CharactersState {
  final Quote quote;
  QuoteLoaddedState({required this.quote});
}
