import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/config/theme/dark_theme.dart';
import 'package:tutorados_app/config/theme/light_theme.dart';
import 'package:tutorados_app/config/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Environment.initEnvionment();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? darkTheme : lightTheme,
    );
  }
}
