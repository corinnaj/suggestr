import 'package:flutter/material.dart';

class DraggedMeal {
  final Meal meal;
  final int swapIndex;

  DraggedMeal(this.meal, {this.swapIndex});
}

class Meal {
  final String name;
  final String pictureUrl;
  final String description;
  final bool prepareInAdvance;

  Meal(this.name, this.pictureUrl, this.description, {this.prepareInAdvance = false});

  Widget getImage({double width, double height}) {
    return Image.asset(
      pictureUrl == '' ? 'images/image_missing.jpg' : 'images/' + pictureUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}

final Meal somethingNew = Meal(
  'Something New',
  'something_new.jpg',
  'And now, for something completely different...',
);

final List<Meal> meals = [
  Meal(
    'Falafel',
    'falafel.jpg',
    'https://www.bonappetit.com/recipe/fresh-herb-falafel',
    prepareInAdvance: true,
  ),
  Meal(
    'Auberginen Gyros',
    'auberginen_gyros.jpg',
    'The Greek Vegetarian Cookbook - page 212',
  ),
  Meal(
    'Avocado Pesto with Fried Halloumi',
    'avocado_pesto.jpg',
    'The Greek Vegetarian Cookbook - page 144',
  ),
  Meal(
    'Aloo Paratha',
    '',
    'https://www.vegrecipesofindia.com/aloo-paratha-indian-bread-stuffed-with-potato-filling/',
  ),
  Meal(
    'Lebanese Chickpeas',
    'lebanese_chickpeas.jpg',
    'Orientalish Vegetarisch - page 206',
    prepareInAdvance: true,
  ),
  Meal(
    'Garlic Chicken',
    '',
    'https://www.halfbakedharvest.com/20-minute-basil-cashew-chicken/',
  ),
  Meal(
    'Galette',
    '',
    'https://www.marmiton.org/recettes/recette_la-pate-a-galettes-de-ble-noir-traditionnelle_35351.aspx',
  ),
  Meal(
    'Dosa & Aloo Masala',
    'aloo_masala.jpg',
    'https://cooking.nytimes.com/recipes/1020908-dosa',
    prepareInAdvance: true,
  ),
  Meal(
    'Pad Thai',
    '',
    'https://pinchofyum.com/rainbow-vegetarian-pad-thai-with-peanuts-and-basil',
  ),
  Meal(
    'Pizza',
    'pizza.jpg',
    '',
    prepareInAdvance: true,
  ),
  Meal(
    'Bolognese',
    '',
    '',
  ),
  Meal(
    'Käsespätzle',
    'kasespatzle.jpg',
    'zB https://emmikochteinfach.de/selbstgemachte-spaetzle/ and https://www.chefkoch.de/rezepte/1062121211526182/Schnelle-Kaesespaetzle.html',
  ),
  Meal(
    'Wild Rice and Mushroom Burger',
    '',
    'https://www.pickuplimes.com/single-post/2019/10/24/Wild-Rice-Mushroom-Burger',
  ),
  Meal(
    'Banh Mi',
    'banh_mi.jpg',
    'https://www.pickuplimes.com/single-post/2020/01/23/TOFU-VIETNAMESE-SUB-B%C3%81NH-M%C3%8C, optionally with homemade Baguette: https://tasteofartisan.com/french-baguette-recipe/',
  ),
  Meal(
    'Little Italy Burger',
    'little_italy_burger.jpg',
    'Burger Cookbook',
  ),
  Meal(
    'Kung Pao Cauliflower',
    'cauliflower_kung_pao.jpg',
    '',
  ),
  Meal(
    'Kidney Bean Burger',
    '',
    '',
    prepareInAdvance: true,
  ),
  Meal(
    'Butter Cauliflower',
    'butter_cauliflower.jpg',
    'https://tasty.co/recipe/easy-butter-chicken',
  ),
  Meal(
    'Massaman Curry',
    'massaman_curry.jpg',
    'Asien Vegetarisch - page 114',
  ),
  Meal(
    'Sommerpilaw',
    'sommerpilaw.jpg',
    'Asien Vegetarisch - page 140',
  ),
  Meal(
    'Rote Bete Reis',
    'rote_bete_reis.jpg',
    'Asien Vegetarisch - page 153',
  ),
  Meal(
    'Singapore Fried Rice',
    '',
    'https://www.vegrecipesofindia.com/singapore-fried-rice-recipe/',
  ),
  Meal(
    'Chili',
    'chili.jpg',
    '',
    prepareInAdvance: true,
  ),
  Meal(
    'Aloo Gobi',
    '',
    'https://www.cookwithmanali.com/aloo-gobi/',
  ),
  Meal(
    'Fennel Spaghetti',
    '',
    'https://www.bbcgoodfood.com/recipes/fennel-spaghetti',
  ),
  Meal(
    'Pumpkin Soup',
    '',
    '',
  ),
  Meal(
    'Holi Burger',
    '',
    'Burger Cookbook',
  ),
  Meal(
    'Parsley Walnut Pesto',
    '',
    '',
  ),
  Meal(
    'Arrabiata',
    '',
    '',
  ),
  Meal(
    'Pasta Salad',
    '',
    'https://www.lecker.de/nudelsalat-mit-getrockneten-tomaten-und-basilikum-31455.html',
  ),
  Meal(
    'Lemon Tofu',
    'lemon_tofu.jpg',
    'Lemon Tofu: https://www.reddit.com/r/VegRecipes/comments/hk6lad/sticky_lemon_pepper_tofu/, goes well with rice and vegetables in a soy/oyster sauce with some lemon',
  ),
  Meal(
    'Filled Zucchini',
    'filled_zucchini.jpg',
    'Photo in the Cmontland Group',
  ),
  Meal(
    'Texas Burger',
    '',
    'Burger Cookbook',
  ),
  Meal(
    'Dum Aloo',
    'dum_aloo.jpg',
    'https://www.cilantroandcitronella.com/potato-curry-dum-aloo/',
  ),
  Meal(
    'Summer Rolls',
    'summer_rolls.jpg',
    '',
  ),
  Meal(
    'Folienkartoffel mit Mojo Rojo',
    'folienkartoffel.jpg',
    'Internationales Kartoffelkochbuch - page 122',
  ),
  Meal(
    'Pav Bhaji',
    '',
    'https://www.vegrecipesofindia.com/pav-bhaji-recipe-mumbai-pav-bhaji-a-fastfood-recipe-from-mumbai/',
  ),
];
