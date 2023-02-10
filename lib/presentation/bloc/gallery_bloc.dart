
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';

import '../../domain/user_case.dart';

abstract class GalleryEvent {}

class GetPhotoListEvent extends GalleryEvent {
  GetPhotoListEvent();
}

class GetPhotoListMoreEvent extends GalleryEvent {

}

abstract class GalleryState {}

class GalleryStateInit extends GalleryState {}
class GalleryStateInProgress extends GalleryState {}
class GalleryStateLoadMoreInProgress extends GalleryState {}
class GalleryStateFailure extends GalleryState {
  final String message;
  final int page;
  GalleryStateFailure({required this.message, required this.page});

}
class GalleryStateSuccess extends GalleryState {
  GalleryStateSuccess({required this.photos, this.isMoreResultAvailable, this.page});
  final List<PhotoEntity> photos;
  final isMoreResultAvailable;
  final page;
}


class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetPhotoUseCase _getPhotoUseCase;
  var page = 0;
  var pageSize = 20;
  var isMoreResultIsAvailable = true;
  List<PhotoEntity> photos = [];
  GalleryBloc(this._getPhotoUseCase) : super(GalleryStateInit()) {
    on<GetPhotoListEvent>((event, emit) => _onGetPhotoList(event, emit));
    on<GetPhotoListMoreEvent>((event, emit) => _onLoadMorePhotos(event, emit));
  }

  void _onGetPhotoList(GetPhotoListEvent event, Emitter<GalleryState> emit) async {
    page = 0;
    emit(GalleryStateInProgress());
    try {
      final response = await _getPhotoUseCase.getPhotoList(page, pageSize);
      isMoreResultIsAvailable = response.length == pageSize ? true : false;
      photos = response;
      emit(GalleryStateSuccess(
          photos: photos,
        isMoreResultAvailable: isMoreResultIsAvailable,
        page: page,
      ));
    } catch (ex) {
      emit(GalleryStateFailure(message: ex.toString(), page: page));
    }
  }
  void _onLoadMorePhotos(GetPhotoListMoreEvent event, Emitter<GalleryState> emit) async {
    page ++;
    emit(GalleryStateLoadMoreInProgress());
    try {
      final response = await _getPhotoUseCase.getPhotoList(page, pageSize);
      isMoreResultIsAvailable = response.length == pageSize ? true : false;
      photos.addAll(response);
      emit(GalleryStateSuccess(photos: response, isMoreResultAvailable: isMoreResultIsAvailable, page: page));
    } catch (ex) {
      emit(GalleryStateFailure(message: ex.toString(), page: page));
    }
  }

}

