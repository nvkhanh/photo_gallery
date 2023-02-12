import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';
import 'package:photo_gallery/presentation/pages/gallery_screen/gallery_page.dart';
import 'package:photo_gallery/routers.dart';

import 'data/repositories/photo_repository_impl.dart';
import 'domain/get_photo_use_case.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryBloc(GetPhotoUseCase(PhotoRepositoryImpl(http.Client()))),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: Routes.routes,
        home: const GalleryPage(),
      ),
    );

  }
}
