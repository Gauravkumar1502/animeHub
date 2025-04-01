import 'package:animexhub/providers/anipic_provider.dart';
import 'package:animexhub/providers/settings_provider.dart';
import 'package:animexhub/views/widgets/image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_hideBottomNavigation);
  }

  void _hideBottomNavigation() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        context.read<SettingsProvider>().setIsVisible(false);
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        context.read<SettingsProvider>().setIsVisible(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimePicsProvider>(
      builder: (context, animePicsProvider, child) {
        if (animePicsProvider.favorites.isEmpty &&
            animePicsProvider.isLoading) {
          return CircularProgressIndicator.adaptive();
        } else if (animePicsProvider.favorites.isEmpty &&
            animePicsProvider.isErrored) {
          return Text('Something went wrong');
        } else if (animePicsProvider.favorites.isEmpty) {
          return Text('No data');
        } else {
          return ListView.builder(
            controller: _scrollController,
            itemCount: animePicsProvider.favorites.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    'Favorites Count: ${animePicsProvider.favorites.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Stack(
                  children: [
                    ImageCard(
                      aniPic: animePicsProvider.favorites[index - 1],
                    ),
                    Positioned(
                      top: 4,
                      right: 20,
                      child: Text(
                        '$index',
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary,
                              offset: Offset(3, 2),
                            ),
                          ],
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_hideBottomNavigation);
    _scrollController.dispose();
    super.dispose();
  }
}
