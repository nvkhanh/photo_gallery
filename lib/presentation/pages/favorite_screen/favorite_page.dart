

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';
import 'package:photo_gallery/widgets/photo_row.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/constants.dart';
import '../../../data/repositories/photo_repository_impl.dart';
import '../../../domain/get_photo_use_case.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FavoritePageState();
  }

}
class _FavoritePageState extends State<FavoritePage> {

  List<PhotoEntity> _photos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _photos = context.read<GalleryBloc>().favorites;

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite'),
      ),
      body: BlocConsumer<GalleryBloc, GalleryState>(builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Container(
                  height: 20,
                )
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return PhotoRow(photo: _photos[index]);
                }, childCount: _photos.length))
          ],
        );
        },
        listener: (context, state) {
          if (state is GalleryFavoriteState) {
            _photos = state.favorites;
            setState(() {
            });
          }
        },
      ),
    );
  }
 
}

