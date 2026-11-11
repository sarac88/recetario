import 'package:flutter/material.dart';

class AppStyles {
	static final Color primaryColor = Color.fromARGB(255, 255, 189, 6);
	static final Color onPrimaryColor = Color.fromARGB(255, 0, 0, 0);
	static final Color tagBackgroundColor = Colors.green.shade100;

	static final sectionTitle = TextStyle(
		fontSize: 20,
		fontWeight: FontWeight.bold,
		color: Colors.black87,
	);

	static final TextStyle cardTitle = TextStyle(
		fontSize: 15,
		fontWeight: .bold,
		color: Colors.black,
	);

	static final mainTitle = TextStyle(
		fontSize: 28,
		fontWeight: FontWeight.bold,
		color: const Color.fromARGB(221, 248, 248, 248),
	);

	static final imageShade = BoxDecoration(
		gradient: LinearGradient(
			begin: Alignment.topCenter,
			end: Alignment.bottomCenter,
			colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
		),
	);

	static final Widget tinySeparator = SizedBox(height: 4);
	static final Widget smallSeparator = SizedBox(height: 8);
	static final Widget mediumSeparator = SizedBox(height: 16);
	static final Widget largeSeparator = SizedBox(height: 24);

}
