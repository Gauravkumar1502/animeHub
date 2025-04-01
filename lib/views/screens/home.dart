import 'package:animexhub/providers/settings_provider.dart';
import 'package:animexhub/views/widgets/bottom_navigation.dart';
import 'package:animexhub/views/widgets/filter_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final String title;
  final StatefulNavigationShell child;
  const HomePage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 8,
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: child,
      extendBody: true,
      floatingActionButton:
          child.currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const FilterModal(),
                  );
                },
                elevation:
                    context.watch<SettingsProvider>().isVisible
                        ? 1
                        : null,
                tooltip: 'Filter',
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.filter_alt_sharp),
              )
              : null,
      floatingActionButtonLocation:
          context.watch<SettingsProvider>().isVisible
              ? FloatingActionButtonLocation.endContained
              : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigation(
        isVisible: context.watch<SettingsProvider>().isVisible,
        selectedIndex: child.currentIndex,
        onSwitch: (index) {
          if (index == 2) {
            GoRouter.of(context).push('/settings');
            return;
          }
          child.goBranch(
            index,
            initialLocation: index == child.currentIndex,
          );
        },
      ),
    );
  }
}
