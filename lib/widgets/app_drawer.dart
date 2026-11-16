import 'package:flutter/material.dart';
import 'package:recetario/screens/about_screen.dart';
import 'package:recetario/styles/app_styles.dart';

class AppDrawer extends StatelessWidget {
	const AppDrawer({super.key});

	@override
	Widget build(BuildContext context) {
		return Drawer(
			child: ListView(
				padding: EdgeInsets.zero,
				children: <Widget>[
					DrawerHeader(
						decoration: BoxDecoration(
							color: AppStyles.primaryColor,
						),
						child: Text(
							'Menú',
							style: TextStyle(
								color: Colors.white,
								fontSize: 24,
							),
						),
					),
					ListTile(
						title: Text('Sobre el recetario'),
						onTap: () {
							Navigator.pop(context);
							Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
						},
					),
				],
			),
		);
	}
}