import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/tuuuur_theme.dart';
import 'navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: TuuurTheme.brandDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TuuurApp());
}

class TuuurApp extends StatelessWidget {
  const TuuurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tuuuur - Quiz Gaming',
      debugShowCheckedModeBanner: false,
      theme: TuuurTheme.theme,
      routerConfig: appRouter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.noScaling, // Empêche le scaling automatique du texte
          ),
          child: child!,
        );
      },
    );
  }
}
