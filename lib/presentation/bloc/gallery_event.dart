part of 'gallery_bloc.dart';

abstract class GalleryEvent {}

class GetPhotoListEvent extends GalleryEvent {
  GetPhotoListEvent();
}

class GetPhotoListMoreEvent extends GalleryEvent {

}
class LikePhotoEvent extends GalleryEvent {
  final PhotoEntity photo;
  final bool isLiked;

  LikePhotoEvent({required this.photo, required this.isLiked});

}
