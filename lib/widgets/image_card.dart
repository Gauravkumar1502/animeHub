import 'package:animexhub/extensions/string_extension.dart';
import 'package:animexhub/models/ani_pic.dart';
import 'package:animexhub/providers/anipic_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.aniPic});

  final AniPic aniPic;

  void toggleFavorite(
    AnimePicsProvider animePicsProvider,
    AniPic aniPic,
    BuildContext context,
  ) async {
    await animePicsProvider.toggleFavorite(aniPic);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            animePicsProvider.favorites.contains(aniPic)
                ? "Added to favorites"
                : "Removed from favorites",
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              animePicsProvider.toggleFavorite(aniPic);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Hero(
        tag: aniPic.id,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Consumer<AnimePicsProvider>(
            builder: (context, animePicsProvider, child) {
              return InkWell(
                onTap: () {
                  // print parent route
                  debugPrint(
                    "Parent route: ${GoRouter.of(context).routerDelegate.currentConfiguration.uri}",
                  );
                  GoRouter.of(context).pushNamed(
                    "imageDetail",
                    pathParameters: {"id": aniPic.id.toString()},
                    queryParameters: {
                      "fromFavorites":
                          GoRouter.of(context)
                                  .routerDelegate
                                  .currentConfiguration
                                  .uri
                                  .toString()
                                  .contains("favorites")
                              ? "true"
                              : "false",
                    },
                  );
                },
                onDoubleTap: () {
                  toggleFavorite(animePicsProvider, aniPic, context);
                },
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height * 0.3,
                        maxHeight:
                            MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          aniPic.url,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.3,
                              child: Center(
                                child: const Text(
                                  "Failed to load image",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                          loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                          ) {
                            return loadingProgress == null
                                ? child
                                : LoadingAnimationWidget.progressiveDots(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                  size: 32,
                                );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("ID: ${aniPic.id.toString()}"),
                              Text(
                                "Rating: ${aniPic.rating.value.capitalize()}",
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              toggleFavorite(
                                animePicsProvider,
                                aniPic,
                                context,
                              );
                            },
                            icon: Icon(
                              animePicsProvider.favorites.contains(
                                    aniPic,
                                  )
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary,
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
        ),
      ),
    );
  }
}
