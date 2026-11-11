import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recetario/styles/app_styles.dart';

class CookingTimer extends StatefulWidget {
  	const CookingTimer({super.key, required this.minutes});

  	final int minutes;

  	@override
  	State<CookingTimer> createState() => _CookingTimerState();
}

class _CookingTimerState extends State<CookingTimer> {

	late int secondsLeft;
	late Timer timer;

	@override
  	void initState() {
		super.initState();
		// Start the timer here
		secondsLeft = widget.minutes * 60;
		timer = Timer.periodic(Duration(seconds: 1), (timer) {
			secondsLeft--;
			if(secondsLeft == 0) {
				timer.cancel();
			}
			setState(() {});
		});
	}

	@override
  	void dispose() {
		timer.cancel();
		super.dispose();
	}

	@override
  	Widget build(BuildContext context) {
    	return Row(
		  mainAxisAlignment: MainAxisAlignment.center,
    	  children: [
			Icon(Icons.alarm, color: AppStyles.primaryColor,size: 20),
    	    Text(
				secondsLeft > 0 ? '${secondsLeft ~/ 60}:${(secondsLeft % 60).toString().padLeft(2, '0')}' : 'Time\'s up!',
				style: TextStyle(
					fontSize: 20,
					fontWeight: FontWeight.bold,
					color: secondsLeft > 0 ? AppStyles.primaryColor : Colors.red,
				),
			),
    	  ],
    	);
  	}
}
