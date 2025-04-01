import 'package:animexhub/providers/anipic_provider.dart';
import 'package:animexhub/providers/settings_provider.dart';
import 'package:animexhub/views/widgets/image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final ScrollController _scrollController = ScrollController();
  late AnimePicsProvider _animePicsProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animePicsProvider = Provider.of<AnimePicsProvider>(
        context,
        listen: false,
      );
      _animePicsProvider.loadMoreAniPics();
      _animePicsProvider.loadFavorites();
    });
    _scrollController.addListener(_hideBottomNavigation);
    _scrollController.addListener(_loadMoreAniPics);
  }

  void _loadMoreAniPics() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _animePicsProvider.loadMoreAniPics();
    }
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
        if (animePicsProvider.anipics.isEmpty &&
            animePicsProvider.isLoading) {
          return Center(child: CircularProgressIndicator.adaptive());
        } else if (animePicsProvider.anipics.isEmpty &&
            animePicsProvider.isErrored) {
          return Center(child: Text(animePicsProvider.errorMessage));
        } else if (animePicsProvider.anipics.isEmpty) {
          return Center(child: Text(animePicsProvider.errorMessage));
          // return Text('No data');
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const PageScrollPhysics(),
                  itemCount: animePicsProvider.anipics.length,
                  itemBuilder: (context, index) {
                    return ImageCard(
                      aniPic: animePicsProvider.anipics[index],
                    );
                  },
                ),
              ),
              if (animePicsProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_hideBottomNavigation);
    _scrollController.removeListener(_loadMoreAniPics);
    _scrollController.dispose();
    super.dispose();
  }
}
