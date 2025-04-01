import 'package:animexhub/views/screens/favorites.dart';
import 'package:animexhub/views/screens/home.dart';
import 'package:animexhub/views/screens/image_detail.dart';
import 'package:animexhub/views/screens/settings.dart';
import 'package:animexhub/views/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _favoritesNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) {
          String title = 'AnimeXHUB';
          debugPrint('State: ${state.fullPath}');
          if (state.fullPath != null) {
            if (state.fullPath!.startsWith('/home')) {
              title = 'AnimeXHUB';
            } else if (state.fullPath!.startsWith('/favorites')) {
              title = 'Favorites';
            } else if (state.fullPath!.startsWith('/settings')) {
              title = 'Settings';
            }
          }

          return HomePage(title: title, child: child);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const ImageList(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _favoritesNavigatorKey,
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const Favorites(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/details/:id',
        name: 'imageDetail',
        builder: (context, state) {
          final String? id = state.pathParameters['id'];
          final String? fromFavorites =
              state.uri.queryParameters['fromFavorites'];
          debugPrint(
            'ImageDetail: id: $id, fromFavorites: $fromFavorites',
          );
          return ImageDetail(
            id: int.parse(id ?? '0'),
            fromFavorites: fromFavorites == 'true',
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Settings(),
      ),
    ],
    errorBuilder: (context, state) {
      // 404 error page
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: ${state.error}')),
      );
    },
  );
}
