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
    bool isSelected = index == selectedIndex;

    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected
                ? Theme.of(context).colorScheme.onSecondary
                : Colors.transparent,
      ),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isSelected ? selectedIcon : icon,
          key: ValueKey(
            isSelected ? selectedIcon : icon,
          ), // Unique key to trigger animation
          size: 24,
        ),
      ),
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          );
        },
        child:
            isSelected
                ? Center(
                  child: Text(label, key: ValueKey(label)),
                ) // Unique key to trigger animation
                : const SizedBox(),
      ),
      onPressed: onPressed,
    );
  }
}
