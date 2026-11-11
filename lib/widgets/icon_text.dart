import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
	const IconText({super.key, required this.icon, required this.text});

	final IconData icon;
	final String text;

	@override
	Widget build(BuildContext context) {
		return Row(
			mainAxisSize: .min,
			children: [Icon(icon), SizedBox(width: 4), Text(text)]
		);
	}
}
