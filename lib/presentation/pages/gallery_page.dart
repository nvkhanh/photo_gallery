

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';

import '../../data/constants.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../../domain/user_case.dart';


class GalleryPage extends StatelessWidget {
  GalleryPage({super.key});

  final getPhotoUseCase = GetPhotoUseCase(PhotoRepositoryImpl(http.Client()));


  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => GalleryBloc(getPhotoUseCase)..add(GetPhotoListEvent()),
      child: GalleryView(),
    );
  }
}

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});
  @override
  State<StatefulWidget> createState() => _GalleryViewState();

}
class _GalleryViewState extends State<GalleryView> {

  ScrollController? _controller;
  List<PhotoEntity> _photos = [];
  var _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    var max = _controller?.position.maxScrollExtent ?? 1;
    var current = _controller?.position.pixels ?? 0;
    var percent = current / max;
    if (percent >= 1 && !_loading) {
      _loading = true;
      context.read<GalleryBloc>().add(GetPhotoListMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            context.read<GalleryBloc>().add(GetPhotoListEvent());
          },
          child: Text("Gallery"),
        ),
      ),
      body: BlocConsumer<GalleryBloc, GalleryState>(
          builder: (context, state) {
            if (state is GalleryStateFailure) {
              return Center(child: Text(state.message),);
            }
            return CustomScrollView(
              controller: _controller,
              slivers: [
                SliverToBoxAdapter(
                  child: _photos.isEmpty ? buildEmptyWidget() : Container(),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildPhotoItem(context, _photos[index]);
                    }, childCount: _photos.length)),
                state is GalleryStateLoadMoreInProgress
                    ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 60),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
                    : const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 80,
                  ),
                ),
              ],
            );
          }, listener: (context, state) {
        if (state is GalleryStateInProgress) {

        }else if (state is GalleryStateSuccess) {
          var list = state.photos;
          _loading = false;
          if (state.page == 0) {
            _photos.clear();
            _photos.addAll(list);;
          }else {
            _photos.addAll(list);
          }
          setState(() {

          });
        }
      }),
    );
  }

  Widget buildEmptyWidget() {
    return SizedBox(
      height: 40,
      child: Center(child: Text("There is no data"),),
    );
  }
  _buildPhotoItem(BuildContext context, PhotoEntity item) {
    return GestureDetector(
      onTap: () {
        var imageProvider = CachedNetworkImageProvider(item.urls?.regular ?? '');
        showImageViewer(context, imageProvider, onViewerDismissed: () {
        });
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: item.urls?.regular ?? '',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width - Style.padding20 * 2,height: 100,),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }



  bool get _isBottom {
    final maxScroll = _controller?.position.maxScrollExtent ?? 0;
    final currentScroll = _controller?.offset ?? 0;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  void dispose() {
    _controller?.removeListener(_scrollListener);
    super.dispose();

  }

}
