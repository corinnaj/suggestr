import 'package:flutter/material.dart';

class Suggestion {
  final String name;
  final String pictureUrl;
  final String description;
  final bool prepareInAdvance;

  Suggestion(this.name, this.pictureUrl, this.description, {this.prepareInAdvance = false});

  Image getImage({double width, double height}) {
    return Image.asset(
      pictureUrl == '' ? 'images/image_missing.jpg' : 'images/' + pictureUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}

final Suggestion somethingNew = Suggestion(
  'Something New',
  'something_new.jpg',
  'And now, for something completely different...',
);

final List<Suggestion> suggestions = [
  Suggestion(
    'Falafel',
    'falafel.jpg',
    'https://www.bonappetit.com/recipe/fresh-herb-falafel',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Auberginen Gyros',
    'auberginen_gyros.jpg',
    'The Greek Vegetarian Cookbook - page 212',
  ),
  Suggestion(
    'Avocado Pesto with Fried Halloumi',
    'avocado_pesto.jpg',
    'The Greek Vegetarian Cookbook - page 144',
  ),
  Suggestion(
    'Aloo Paratha',
    '',
    'https://www.vegrecipesofindia.com/aloo-paratha-indian-bread-stuffed-with-potato-filling/',
  ),
  Suggestion(
    'Lebanese Chickpeas',
    'lebanese_chickpeas.jpg',
    'Orientalish Vegetarisch - page 206',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Garlic Chicken',
    '',
    'https://www.halfbakedharvest.com/20-minute-basil-cashew-chicken/',
  ),
  Suggestion(
    'Galette',
    '',
    'https://www.marmiton.org/recettes/recette_la-pate-a-galettes-de-ble-noir-traditionnelle_35351.aspx',
  ),
  Suggestion(
    'Dosa & Aloo Masala',
    '',
    'https://cooking.nytimes.com/recipes/1020908-dosa',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Pad Thai',
    '',
    'https://pinchofyum.com/rainbow-vegetarian-pad-thai-with-peanuts-and-basil',
  ),
  Suggestion(
    'Pizza',
    '',
    '',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Bolognese',
    '',
    '',
  ),
  Suggestion(
    'Käsespätzle',
    'kasespatzle.jpg',
    'zB https://emmikochteinfach.de/selbstgemachte-spaetzle/ and https://www.chefkoch.de/rezepte/1062121211526182/Schnelle-Kaesespaetzle.html',
  ),
  Suggestion(
    'Wild Rice and Mushroom Burger',
    '',
    'https://www.pickuplimes.com/single-post/2019/10/24/Wild-Rice-Mushroom-Burger',
  ),
  Suggestion(
    'Banh Mi',
    'banh_mi.jpg',
    'https://www.pickuplimes.com/single-post/2020/01/23/TOFU-VIETNAMESE-SUB-B%C3%81NH-M%C3%8C, optionally with homemade Baguette: https://tasteofartisan.com/french-baguette-recipe/',
  ),
  Suggestion(
    'Little Italy Burger',
    '',
    'Burger Cookbook',
  ),
  Suggestion(
    'Kung Pao Cauliflower',
    'cauliflower_kung_pao.jpg',
    '',
  ),
  Suggestion(
    'Kidney Bean Burger',
    '',
    '',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Butter Cauliflower',
    '',
    'https://tasty.co/recipe/easy-butter-chicken',
  ),
  Suggestion(
    'Massaman Curry',
    'massaman_curry.jpg',
    'Asien Vegetarisch - page 114',
  ),
  Suggestion(
    'Sommerpilaw',
    '',
    'Asien Vegetarisch - page 140',
  ),
  Suggestion(
    'Rote Bete Reis',
    '',
    'Asien Vegetarisch - page 153',
  ),
  Suggestion(
    'Singapore Fried Rice',
    '',
    'https://www.vegrecipesofindia.com/singapore-fried-rice-recipe/',
  ),
  Suggestion(
    'Chilli',
    '',
    '',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Aloo Gobi',
    '',
    'https://www.cookwithmanali.com/aloo-gobi/',
  ),
  Suggestion(
    'Fennel Spaghetti',
    '',
    'https://www.bbcgoodfood.com/recipes/fennel-spaghetti',
  ),
  Suggestion(
    'Pumpkin Soup',
    '',
    '',
  ),
  Suggestion(
    'Holi Burger',
    '',
    'Burger Cookbook',
  ),
  Suggestion(
    'Parsley Walnut Pesto',
    '',
    '',
  ),
  Suggestion(
    'Arrabiata',
    '',
    '',
  ),
  Suggestion(
    'Pasta Salad',
    '',
    'https://www.lecker.de/nudelsalat-mit-getrockneten-tomaten-und-basilikum-31455.html',
  ),
  Suggestion(
    'Lemon Tofu',
    'lemon_tofu.jpg',
    'Lemon Tofu: https://www.reddit.com/r/VegRecipes/comments/hk6lad/sticky_lemon_pepper_tofu/, goes well with rice and vegetables in a soy/oyster sauce with some lemon',
  ),
  Suggestion(
    'Filled Zucchini',
    'filled_zucchini.jpg',
    'Photo in the Cmontland Group',
  ),
  Suggestion(
    'Texas Burger',
    '',
    'Burger Cookbook',
  ),
  Suggestion(
    'Dum Aloo',
    'dum_aloo.jpg',
    'https://www.cilantroandcitronella.com/potato-curry-dum-aloo/',
  ),
  Suggestion(
    'Summer Rolls',
    'summer_rolls.jpg',
    '',
  ),
];
