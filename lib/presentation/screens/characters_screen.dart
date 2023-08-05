import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/characters_model.dart';
import '../widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> allCharacters = [];
  List<Character> searchedCharacters = [];
  bool _isSearching = false;
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("build called");

    BlocProvider.of<CharactersCubit>(context).getCharacters();

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching ? _buildSearchField() : _buildAppbarWithoutSearching(),
        actions: _buildAppBarActions(),
        leading: _isSearching
            ? const BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
        backgroundColor: MyColors.myYellow,
      ),
      body: OfflineBuilder(
        connectivityBuilder: (context, connectivity, child) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return searchController.text.isNotEmpty &&
                    searchedCharacters.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Sorry there is not any character match your search! .',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  )
                : _buildBlocWidget();
          } else {
            //offline
            return _buildOfflineWidget();
          }
        },
        child: _showProgressIndicator(),
      ),
    );
  }

  Widget _buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaddedState) {
          //override the initail characters
          allCharacters = state.characters;
          return _buildLoadedList();
        } else {
          return _showProgressIndicator();
        }
      },
    );
  }

  Widget _buildLoadedList() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            _buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _itemCount(),
      clipBehavior: Clip.antiAlias,
      itemBuilder: (context, index) {
        return _itemBuilder(index);
      },
    );
  }

  Widget _showProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: const InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
      style: const TextStyle(color: MyColors.myGrey, fontSize: 18),
      cursorColor: MyColors.myGrey,
      onChanged: (inputText) {
        _addSearchedForItemsToSearchedList(inputText);
      },
    );
  }

  Widget _buildAppbarWithoutSearching() {
    return const Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey, fontSize: 18),
    );
  }

  void _addSearchedForItemsToSearchedList(String inputText) {
    searchedCharacters = allCharacters.where((Character character) {
      return character.name!.toLowerCase().contains(inputText) |
          character.name!.toLowerCase().startsWith(inputText);
    }).toList();

    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearchFieldText();
            Navigator.pop(context); //to delete the searchBar
          },
          icon: const Icon(
            Icons.close,
          ),
          color: MyColors.myGrey,
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            _startSearch();
          },
          icon: const Icon(
            Icons.search,
          ),
          color: MyColors.myGrey,
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(
      LocalHistoryEntry(
        onRemove: () {
          __stopSearching();
        },
      ),
    );
    setState(() {
      _isSearching = true;
    });
  }

  void __stopSearching() {
    _clearSearchFieldText();
  }

  void _clearSearchFieldText() {
    searchController.clear();
    setState(
      () {
        _isSearching = false;
      },
    );
  }

  int _itemCount() {
    if (searchController.text.isEmpty) {
      return allCharacters.length;
    } else if (searchController.text.isNotEmpty &&
        searchedCharacters.isNotEmpty) {
      return searchedCharacters.length;
    } else {
      return 1;
    }
  }

  Widget _itemBuilder(index) {
    if (searchController.text.isEmpty) {
      return CharacterItem(character: allCharacters[index]);
    } else {
      return CharacterItem(character: searchedCharacters[index]);
    }
  }

  Widget _buildOfflineWidget() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.17),
        Image.asset('assets/images/no_internet.jpg'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16.0, vertical: 16.0),
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  // color: Colors.red,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                    'Can\'t connect to internet! , please check your network.'),
              ],
              repeatForever: true,
            ),
          ),
          // AnimatedText(
          //   child: Text(
          //     'Can\'t connect to internet! , please check your network.',
          //     style: TextStyle(color: Colors.red),
          //   ),
          // ),
        ),
      ],
    );
  }
}//end of the class
