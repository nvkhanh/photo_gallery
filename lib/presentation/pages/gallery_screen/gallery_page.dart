

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';
import 'package:photo_gallery/widgets/photo_row.dart';

import '../../../routers.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(context) {
    return const GalleryView();
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
  List<PhotoEntity> _favorites = [];
  var _loading = false;
  var _showBackToTopIcon = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController()..addListener(_scrollListener);
    context.read<GalleryBloc>().add(GetPhotoListEvent());
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

  void _scrollToTop() {
    _controller?.animateTo(0,
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    _photos = context.read<GalleryBloc>().photos;
    _favorites = context.read<GalleryBloc>().favorites;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        actions: <Widget>[
          GestureDetector(
            child: SizedBox(
              height: 30,
              width: 40,
              child: Center(child: Text("${_favorites.length}"),),
            ),
            onTap: () async {
               Navigator.of(context).pushNamed(Routes.favorite, arguments: {
              });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          BlocConsumer<GalleryBloc, GalleryState>(
              builder: (context, state) {
                if (state is GalleryStateFailure && state.page == 0 && _photos.isEmpty) {
                  return Center(child: Text(state.message),);
                }
                if (state is GalleryStateInProgress) {
                  return const Center(child: CircularProgressIndicator(),);
                }
                return CustomScrollView(
                  controller: _controller,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _photos.isEmpty ? buildEmptyWidget() : Container(
                        height: 20,
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return PhotoRow(photo: _photos[index]);
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
            if (state is GalleryStateSuccess) {
              _loading = false;
              setState(() {});
            } else if (state is GalleryFavoriteState) {
              setState(() {
              });
            }

          }),
          if (_showBackToTopIcon)
            Positioned(
              bottom: 0,
              right: 0,
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
                    child: const Center(
                      child: Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      )
    );
  }

  Widget buildEmptyWidget() {
    return const SizedBox(
      height: 40,
      child: Center(child: Text("There is no data"),),
    );
  }

 


  @override
  void dispose() {
    _controller?.removeListener(_scrollListener);
    super.dispose();

  }

}
