import 'package:animexhub/widgets/custom_bottom_nav_icon_button.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.isVisible,
    required this.selectedIndex,
    required this.onSwitch,
  });
  final int selectedIndex;
  final bool isVisible;
  final void Function(int) onSwitch;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isVisible ? kBottomNavigationBarHeight + 32 : 0,
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          spacing: 4,
          children: [
            CustomBottomNavIconButton(
              index: 0,
              selectedIndex: selectedIndex,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_sharp,
              label: 'Home',
              onPressed: () {
                onSwitch(0);
              },
            ),
            CustomBottomNavIconButton(
              index: 1,
              selectedIndex: selectedIndex,
              icon: Icons.favorite_outline,
              selectedIcon: Icons.favorite_sharp,
              label: 'Favorites',
              onPressed: () {
                onSwitch(1);
              },
            ),
            CustomBottomNavIconButton(
              index: 2,
              selectedIndex: selectedIndex,
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_sharp,
              label: 'Settings',
              iconSize: 40,
              onPressed: () {
                onSwitch(2);
              },
            ),
          ],
        ),
      ),
    );

    // NavigationBar
    // return NavigationBar(
    //   selectedIndex: selectedIndex,
    //   destinations: [
    //     NavigationDestination(
    //       icon: const Icon(Icons.home_outlined),
    //       selectedIcon: const Icon(Icons.home_sharp),
    //       label: 'Home',
    //     ),
    //     NavigationDestination(
    //       icon: const Icon(Icons.favorite_outline),
    //       selectedIcon: const Icon(Icons.favorite_sharp),
    //       label: 'Favorites',
    //     ),
    //     NavigationDestination(
    //       icon: const Icon(Icons.settings_outlined),
    //       selectedIcon: const Icon(Icons.settings_sharp),
    //       label: 'Settings',
    //     ),
    //   ],
    //   onDestinationSelected: (index) {
    //     onSwitch(index);
    //   },
    // );
  }
}
