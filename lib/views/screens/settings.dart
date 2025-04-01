import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 8,
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: const Center(child: Text('Settings')),
    );
  }
}
