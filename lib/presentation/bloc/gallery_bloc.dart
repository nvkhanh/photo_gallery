
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';

import '../../domain/get_photo_use_case.dart';


part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetPhotoUseCase _getPhotoUseCase;

  var page = 0;
  var pageSize = 20;
  List<PhotoEntity> favorites = [];
  List<PhotoEntity> photos = [];

  GalleryBloc(this._getPhotoUseCase) : super(GalleryStateInit()) {
    on<GetPhotoListEvent>((event, emit) => _onGetPhotoList(event, emit));
    on<GetPhotoListMoreEvent>((event, emit) => _onLoadMorePhotos(event, emit));
    on<LikePhotoEvent>((event, emit) => _onFavoriteEvent(event, emit));
  }

  void _onFavoriteEvent(LikePhotoEvent event, Emitter<GalleryState> emit) async {
    if (event.isLiked) {
      favorites.add(event.photo);
    }else {
      favorites.remove(event.photo);
    }
    emit(GalleryFavoriteState(favorites));
  }
  void _onGetPhotoList(GetPhotoListEvent event, Emitter<GalleryState> emit) async {
    page = 0;
    favorites.clear();
    photos.clear();
    emit(GalleryStateInProgress());
    try {
      final response = await _getPhotoUseCase.getPhotoList(page, pageSize);
      photos = response;
      emit(GalleryStateSuccess(
          photos: photos,
        page: page,
      ));
    } catch (ex) {
      emit(GalleryStateFailure(message: 'An error occurred while connecting to server', page: page));
    }
  }
  void _onLoadMorePhotos(GetPhotoListMoreEvent event, Emitter<GalleryState> emit) async {
    page ++;
    emit(GalleryStateLoadMoreInProgress());
    try {
      final response = await _getPhotoUseCase.getPhotoList(page, pageSize);
      photos.addAll(response);
      emit(GalleryStateSuccess(photos: response, page: page));
    } catch (ex) {
      emit(GalleryStateFailure(message: 'An error occurred while connecting to server', page: page));
    }
  }

}

