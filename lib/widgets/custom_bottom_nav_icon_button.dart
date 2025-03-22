import 'package:flutter/material.dart';

class CustomBottomNavIconButton extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final double iconSize;
  final String label;
  final VoidCallback onPressed;

  const CustomBottomNavIconButton({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    this.iconSize = 24,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor:
            index == selectedIndex
                ? Theme.of(context).colorScheme.onSecondary
                : Colors.transparent,
      ),
      label: index == selectedIndex ? Text(label) : const SizedBox(),
      icon: Icon(
        index == selectedIndex ? selectedIcon : icon,
        size: 24,
      ),
      onPressed: onPressed,
    );
  }
}
