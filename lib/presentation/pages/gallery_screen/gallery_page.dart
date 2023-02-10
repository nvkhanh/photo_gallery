

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/constants.dart';
import '../../../data/repositories/photo_repository_impl.dart';
import '../../../domain/get_photo_use_case.dart';

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
  var _showBackToTopIcon = false;

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
    if (current > MediaQuery.of(context).size.height) {
      setState(() {
        _showBackToTopIcon = true;
      });
    }else {
      setState(() {
        _showBackToTopIcon = false;
      });
    }
  }
  _refresh() {
    context.read<GalleryBloc>().add(GetPhotoListEvent());
    return Future<void>.delayed(const Duration(seconds: 1));
  }
  void _scrollToTop() {
    _controller?.animateTo(0,
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery")
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: Stack(
          children: <Widget>[
            BlocConsumer<GalleryBloc, GalleryState>(
                builder: (context, state) {
                  if (state is GalleryStateFailure && state.page == 0) {
                    return Center(child: Text(state.message),);
                  }
                  if (state is GalleryStateInProgress) {
                    return const Center(child: CircularProgressIndicator(),);
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
            if (_showBackToTopIcon)
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    _scrollToTop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      right: 16,
                    ),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                bottom: 0,
                right: 0,
              )
          ],
        ),
      )
    );
  }

  Widget buildEmptyWidget() {
    return const SizedBox(
      height: 40,
      child: Center(child: Text("There is no data"),),
    );
  }
  _buildPhotoItem(BuildContext context, PhotoEntity item) {
    return Stack(
      children: <Widget>[
        GestureDetector(
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
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              Share.share(item.links?.html ?? '');
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(
                bottom: 10,
                right: 20,
              ),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(
                    Icons.share,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          bottom: 0,
          right: 0,
        )
      ],
    );
  }


  @override
  void dispose() {
    _controller?.removeListener(_scrollListener);
    super.dispose();

  }

}
