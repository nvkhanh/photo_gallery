import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../data/constants.dart';
import '../domain/entities/photo_entity.dart';
import '../presentation/bloc/gallery_bloc.dart';

class PhotoRow extends StatefulWidget {
  final PhotoEntity photo;

  const PhotoRow({super.key, required this.photo});

  @override
  State<StatefulWidget> createState() => _PhotoRowState();

}
class _PhotoRowState extends State<PhotoRow> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildPhotoItem(context, widget.photo);
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
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      var currentStatus = item.isLiked ?? false;
                      item.isLiked = !(item.isLiked ?? false);
                      context.read<GalleryBloc>().add(LikePhotoEvent(photo: item, isLiked: !currentStatus));
                    });
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
                          item.isLiked == true ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
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
                )
              ],
            ),
          ),
          bottom: 0,
          right: 0,
        )
      ],
    );
  }
}