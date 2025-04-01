import 'package:animexhub/providers/anipic_provider.dart';
import 'package:animexhub/utils/dio_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
                      /// Share button
                      Expanded(
                        child: IconButton(
                          onPressed: () async {
                            // show loading dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierLabel: 'Loading',
                              builder: (context) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Downloading image...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    CircularProgressIndicator(),
                                  ],
                                );
                              },
                            );
                            // get image bytes
                            final file = await DefaultCacheManager()
                                .getSingleFile(aniPic.url);
                            // close loading dialog
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            final ShareResult result =
                                await Share.shareXFiles(
                                  [XFile(file.path)],
                                  fileNameOverrides: [
                                    '${aniPic.id}.jpg',
                                  ],
                                  text: 'Check out this image!',
                                  subject: 'Image from AnimeXHub',
                                );
                            String msg = '';
                            if (result.status ==
                                ShareResultStatus.dismissed) {
                              msg = 'Share dismissed';
                            } else if (result.status ==
                                ShareResultStatus.unavailable) {
                              msg = 'Share unavailable';
                            } else if (result.status ==
                                ShareResultStatus.success) {
                              msg = 'Image shared successfully';
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  duration: const Duration(
                                    seconds: 2,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.share),
                          tooltip: 'Share',
                        ),
                      ),

                      /// Favorite button
                      Expanded(
                        child: IconButton(
                          onPressed: () async {
                            await anipicProvider.toggleFavorite(
                              aniPic,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    anipicProvider.favorites.contains(
                                          aniPic,
                                        )
                                        ? "Added to favorites"
                                        : "Removed from favorites",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(
                                    seconds: 2,
                                  ),
                                  action: SnackBarAction(
                                    label: "Undo",
                                    onPressed: () {
                                      anipicProvider.toggleFavorite(
                                        aniPic,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          icon:
                              anipicProvider.favorites.contains(
                                    aniPic,
                                  )
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border),
                          tooltip: 'Toggle favorite',
                        ),
                      ),

                      /// Download button
                      Expanded(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          tooltip: 'Download',
                        ),
                      ),

                      /// Set as wallpaper button
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
                // DraggableScrollableActuator(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}
