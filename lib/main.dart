import 'package:animexhub/hive_registrar.g.dart';
import 'package:animexhub/providers/settings_provider.dart';
import 'package:animexhub/screens/home_page.dart';
import 'package:animexhub/theme/theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return Consumer<SettingsProvider>(
          builder: (context, settingsProvider, _) {
            return MaterialApp(
              title: 'Anime X Hub',
              theme: ThemeData(
                colorScheme:
                    lightColorScheme ?? MaterialTheme.lightScheme(),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme:
                    darkColorScheme ?? MaterialTheme.darkScheme(),
                useMaterial3: true,
              ),
              themeMode: settingsProvider.themeMode,
              home:
                  settingsProvider.isLoading
                      ? const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : const HomePage(title: 'Anime X Hub'),
            );
          },
        );
      },
    );
  }
}
