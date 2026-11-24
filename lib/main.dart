import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recetario/providers/favorites_provider.dart';
import 'package:recetario/screens/home_screen.dart';
import 'package:recetario/styles/app_styles.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavoritesProvider(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: AppStyles.primaryColor,
            foregroundColor: AppStyles.onPrimaryColor,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
