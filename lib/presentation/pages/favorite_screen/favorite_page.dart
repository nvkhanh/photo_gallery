

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';
import 'package:photo_gallery/widgets/photo_row.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

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
        title: const Text('Favorite'),
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
            setState(() { //reload the screen with the new data
            });
          }
        },
      ),
    );
  }
 
}

