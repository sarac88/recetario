import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
	int selectedIndex = 0;
	final screens = [
		RecipeListScreen(),
		FavoritesScreen(),
	];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
		body: screens[selectedIndex],
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
			)
     );

  }
}