

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/helpers/utils.dart';
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

class GalleryView extends StatelessWidget {

  GalleryView({super.key});

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
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: Style.padding20),
          child: Column(
            children: <Widget>[
              SizedBox(height: Style.padding20,),
              Expanded(child: BlocConsumer<GalleryBloc, GalleryState>(
                listener: (context, state) {

                },
                builder: (context, state) {
                  if (state is GalleryStateInProgress) {
                    return _buildLoadingWidget();
                  }else if (state is GalleryStateSuccess) {
                    return state.photos.isNotEmpty ? _buildPhotoList(context, state.photos) : buildEmptyWidget();
                  }else if (state is GalleryStateFailure) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, Style.padding20, 0, 0),
                      child: const Text("There was an error please try again"),
                    );
                  }
                  return Container();
                },
              ))
            ],
          )
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: double.infinity,
      child: const Center(child: CircularProgressIndicator(
        color: Colors.green,
      ),),
    );
  }
  Widget buildEmptyWidget() {
    return SizedBox(
      height: 40,
      child: Center(child: Text("There is no data"),),
    );
  }
  Widget _buildPhotoList(BuildContext context, List<dynamic> items) {
    return ListView.builder (
        itemCount: items.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0.0),
        itemBuilder: (BuildContext context, int index) {
          var item = items[index] as PhotoEntity;
          return _buildPhotoItem(context, item);
        }
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


}
