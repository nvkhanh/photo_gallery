part of 'gallery_bloc.dart';


abstract class GalleryState  extends Equatable {}

class GalleryStateInit extends GalleryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GalleryStateInProgress extends GalleryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GalleryStateLoadMoreInProgress extends GalleryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GalleryStateFailure extends GalleryState {
  final String message;
  final int page;
  GalleryStateFailure({required this.message, required this.page});
  @override
  // TODO: implement props
  List<Object?> get props => [
    message,
    page
  ];

}
class GalleryStateSuccess extends GalleryState {

  GalleryStateSuccess({required this.photos, required this.page});
  final List<PhotoEntity> photos;
  final int page;

  @override
  // TODO: implement props
  List<Object?> get props => [
    photos,
    page
  ];
}

class GalleryFavoriteState extends GalleryState {
  final List<PhotoEntity> favorites;

  GalleryFavoriteState(this.favorites);

  @override
  // TODO: implement props
  List<Object?> get props => [identityHashCode(this)];
}
