
import 'package:flutter/material.dart';
import 'package:photo_gallery/presentation/pages/favorite_screen/favorite_page.dart';
import 'package:photo_gallery/presentation/pages/gallery_screen/gallery_page.dart';

class Routes {
  Routes._();

  //static variables
  static const String gallery = '/gallery';
  static const String favorite = '/favorite';

  static final routes = <String, WidgetBuilder>{
    gallery: (BuildContext context) => const GalleryPage(),
    favorite: (BuildContext context) => const FavoritePage(),
  };
}


