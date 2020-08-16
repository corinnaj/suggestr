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
    '',
    'https://www.bonappetit.com/recipe/fresh-herb-falafel',
    prepareInAdvance: true,
  ),
  Suggestion(
    'Auberginen Gyros',
    'auberginen_gyros.jpg',
    'Greek Cookbook',
  ),
  Suggestion(
    'Avocado Pesto with Fried Halloumi',
    'avocado_pesto.jpg',
    'Greek Cookbook',
  ),
  Suggestion(
    'Aloo Paratha',
    '',
    "https://www.vegrecipesofindia.com/aloo-paratha-indian-bread-stuffed-with-potato-filling/",
  ),
  Suggestion(
    'Lebanese Chickpeas',
    'lebanese_chickpeas.jpg',
    'TODO',
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
    "https://cooking.nytimes.com/recipes/1020908-dosa?action=click&module=Global%20Search%20Recipe%20Card&pgType=search&rank=1",
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
    'zB https://www.gutekueche.at/spaetzleteig-rezept-3858, dann mit Käse (Emmentaler) und Lauch überbacken',
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
    '',
    '',
  ),
  Suggestion(
    'Kidney Bean Burger',
    '',
    'Asien Vegetarisch - page ?',
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
    'https://minimalistbaker.com/curried-cauliflower-rice-with-lentils-crispy-shallot-mujadara-inspired/',
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
];
