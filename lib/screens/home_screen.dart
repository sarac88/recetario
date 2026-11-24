import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/providers/favorites_provider.dart';
import 'package:recetario/screens/favorites_screen.dart';
import 'package:recetario/screens/recipe_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  Future<void> confirmClearFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text(
            '¿Estás seguro de que deseas eliminar todos los favoritos?',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                setState(() {
                  context.read<FavoritesProvider>().clearFavorites();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    debugPrint('Confirmación de eliminación de favoritos: $confirmed');
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      RecipeListScreen(),
      FavoritesScreen(onClearFavorites: confirmClearFavorites),
    ];

    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          selectedIndex = 0;
          setState(() {});
        }
      },
      child: Scaffold(
        body: IndexedStack(index: selectedIndex, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            selectedIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}
