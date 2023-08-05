import 'business_logic/cubit/characters_cubit.dart';
import 'data/models/characters_model.dart';
import 'data/repository/character_repo.dart';
import 'data/web_sevices/characters_web_services.dart';
import 'presentation/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/my_strings.dart';
import 'presentation/screens/details_screen.dart';

class AppRouter {
  late CharactersRepo characterRepo;
  late CharactersCubit charactersCubit;
  AppRouter() {
    characterRepo = CharactersRepo(CharactersWebServices());
    charactersCubit = CharactersCubit(repository: characterRepo);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => charactersCubit,
            child: const CharactersScreen(),
          ),
        );
      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => charactersCubit,
            child: CharacterDetailsScreen(character: character),
          ),
        );
    }
    return null;
  }
}
