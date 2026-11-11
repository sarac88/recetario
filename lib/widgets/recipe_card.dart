import 'package:flutter/material.dart';
import 'package:recetario/models/recipe.dart';
import 'package:recetario/widgets/icon_text.dart';

import '../styles/app_styles.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
	super.key, 
	required this.recipe, 
	required this.isFavorite, 
	required this.onFavoritePressed, 
	required this.onTap
});

  final Recipe recipe;
  final bool isFavorite;
  final Function() onFavoritePressed;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
		clipBehavior: Clip.antiAlias,
		child: InkWell(
		  onTap: onTap,
		  child: Column(
		  	children: [
		  		Expanded(
		  		  child: Image.network(
		  		  	recipe.imageUrl,
		  		  	width: double.infinity,
		  		  	fit: BoxFit.cover,
		  		  ),
		  		),
		  		Column(
		  		  crossAxisAlignment: .center,
		  		  children: [
		  		    Text(recipe.title,
		  			maxLines: 1,
		  			overflow: TextOverflow.ellipsis,
		  			style: AppStyles.cardTitle,
		  			),
		  			Row(
		  			  mainAxisAlignment: .spaceBetween,
		  			  children: [
		  			    IconText(
		  			    	icon: Icons.timer_outlined, 
		  			    	text: '${recipe.minutes} min'
		  			    ),
		  				IconButton(
		  					onPressed: onFavoritePressed, 
		  					icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
		  				),
		  			  ],
		  			),
		  		  ],
		  		),
		  	],
		  ),
		),
	);
  }
}