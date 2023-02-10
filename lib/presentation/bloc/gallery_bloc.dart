
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';

import '../../domain/get_photo_use_case.dart';

abstract class GalleryEvent {}

class GetPhotoListEvent extends GalleryEvent {
  GetPhotoListEvent();
}

class GetPhotoListMoreEvent extends GalleryEvent {

}

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
  GalleryStateSuccess({required this.photos, this.page});

  final List<PhotoEntity> photos;
  final page;

  @override
  // TODO: implement props
  List<Object?> get props => [
    photos,
    page
  ];
}


class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetPhotoUseCase _getPhotoUseCase;
  var page = 0;
  var pageSize = 20;
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

