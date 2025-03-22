import 'package:animexhub/models/settings.dart';
import 'package:animexhub/providers/settings_provider.dart';
import 'package:animexhub/widgets/custom_bottom_nav_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.isVisible});
  final bool isVisible;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    _selectedIndex = context.read<SettingsProvider>().themeMode.index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: widget.isVisible ? kBottomNavigationBarHeight + 40 : 0,
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          spacing: 4,
          children: [
            CustomBottomNavIconButton(
              index: 0,
              selectedIndex: _selectedIndex,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_sharp,
              label: 'Home',
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  context.read<SettingsProvider>().setThemeMode(
                    Mode.values[_selectedIndex],
                  );
                });
              },
            ),
            CustomBottomNavIconButton(
              index: 1,
              selectedIndex: _selectedIndex,
              icon: Icons.favorite_outline,
              selectedIcon: Icons.favorite_sharp,
              label: 'Favorites',
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                  context.read<SettingsProvider>().setThemeMode(
                    Mode.values[_selectedIndex],
                  );
                });
              },
            ),
            CustomBottomNavIconButton(
              index: 2,
              selectedIndex: _selectedIndex,
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_sharp,
              label: 'Settings',
              iconSize: 40,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                  context.read<SettingsProvider>().setThemeMode(
                    Mode.values[_selectedIndex],
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
