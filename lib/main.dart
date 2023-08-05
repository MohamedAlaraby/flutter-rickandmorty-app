import 'app_router.dart';
import 'package:flutter/material.dart';

void main() {
  //main
  runApp(RickAndMorty(appRouter: AppRouter()));
}

// ignore: must_be_immutable
class RickAndMorty extends StatelessWidget {
  AppRouter appRouter;
  RickAndMorty({required this.appRouter, super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
