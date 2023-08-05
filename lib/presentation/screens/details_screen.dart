import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/characters_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// ignore: must_be_immutable
class CharacterDetailsScreen extends StatefulWidget {
  Character character;

  CharacterDetailsScreen({required this.character, super.key});

  @override
  State<CharacterDetailsScreen> createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  @override
  void initState() {
    super.initState();
    CharactersCubit.get(context).getRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCharacterInfo('Status', widget.character.status!),
                      _buildDivider((MediaQuery.of(context).size.width) - 100),
                      _buildCharacterInfo('Species', widget.character.species!),
                      _buildDivider((MediaQuery.of(context).size.width) - 120),
                      _buildCharacterInfo('Gender', widget.character.gender!),
                      _buildDivider((MediaQuery.of(context).size.width) - 110),
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: _buildCharacterInfo('Origin Name',
                                  widget.character.origin!.name!),
                            ),
                          )
                        ],
                      ),
                      _buildDivider((MediaQuery.of(context).size.width) - 167),
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: _buildCharacterInfo(
                                'Location Name',
                                widget.character.location!.name!,
                              ),
                            ),
                          )
                        ],
                      ),
                      _buildDivider((MediaQuery.of(context).size.width) - 195),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return _checkIfQuoteIsAvailable(state);
                        },
                      ),
                      const SizedBox(
                        height: 500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.7,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          widget.character.name!,
          style: const TextStyle(color: MyColors.myWhite, fontSize: 18),
        ),
        background: Hero(
          tag: widget.character.id!,
          child: Image(
            image: NetworkImage('${widget.character.image}'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      text: TextSpan(children: [
        TextSpan(
          text: "$title : ",
          style: const TextStyle(
            color: MyColors.myWhite,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(
            color: MyColors.myWhite,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ]),
    );
  }

  Widget _buildDivider(endIndent) {
    return Divider(
      height: 20,
      endIndent: endIndent,
      color: MyColors.myYellow,
      thickness: 2,
    );
  }

  Widget _checkIfQuoteIsAvailable(CharactersState state) {
    if (state is QuoteLoaddedState) {
      return _displayAnimatedQuoteText(state);
    } else {
      return _showProgressIndicator();
    }
  }

  Widget _displayAnimatedQuoteText(QuoteLoaddedState state) {
    var quote = state.quote;
    if (quote.quote.isNotEmpty) {
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: MyColors.myWhite,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColors.myYellow,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(quote.quote),
            ],
            repeatForever: true,
          ),
        ),
      );
    }
    return Container();
  }
}

Widget _showProgressIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: MyColors.myYellow,
    ),
  );
}
