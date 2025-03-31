import 'package:animexhub/models/ani_pic.dart';
import 'package:animexhub/providers/anipic_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ImageDetail extends StatelessWidget {
  const ImageDetail({
    super.key,
    required this.id,
    required this.fromFavorites,
  });
  final int id;
  final bool fromFavorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AnimePicsProvider>(
        builder: (context, anipicProvider, child) {
          final aniPic =
              fromFavorites
                  ? anipicProvider.getFavoriteById(id)
                  : anipicProvider.getAniPicById(id);
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.1,
                    maxScale: 5.0,
                    child: Hero(
                      tag: aniPic.id,
                      transitionOnUserGestures: true,
                      child: Image(
                        height: double.infinity,
                        image: NetworkImage(aniPic.url),
                        loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                        ) {
                          return loadingProgress == null
                              ? child
                              : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        size: 50,
                                      ),
                                ),
                              );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                          tooltip: 'Share',
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon:
                              anipicProvider.favorites.contains(
                                    aniPic,
                                  )
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border),
                          tooltip: 'Toggle favorite',
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          tooltip: 'Download',
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.wallpaper),
                          tooltip: 'Set as wallpaper',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
