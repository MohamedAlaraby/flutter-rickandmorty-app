import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';
import '../../data/models/characters_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CharacterItem extends StatelessWidget {
  Character character;

  CharacterItem({required this.character, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: MyColors.myWhite,
        borderRadius: BorderRadius.circular(8.0),
        shape: BoxShape.rectangle,
        border: Border.all(color: MyColors.myWhite, width: 2.0),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, characterDetailsScreen,
            arguments: character),
        child: Hero(
          tag: character.id!,
          child: GridTile(
            footer: Card(
              clipBehavior: Clip.antiAlias,
              borderOnForeground: true,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.black54,
                alignment: Alignment.bottomCenter,
                child: Text(
                  character.name!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      height: 1.3,
                      fontSize: 16,
                      color: MyColors.myWhite,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            child: Card(
              clipBehavior: Clip.antiAlias,
              borderOnForeground: true,
              child: character.image!.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      width: double.infinity,
                      placeholder: 'assets/images/loading.gif',
                      image: character.image!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/placeholder.png',
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
