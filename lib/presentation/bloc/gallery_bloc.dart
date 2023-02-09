
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';

import '../../domain/user_case.dart';

abstract class GalleryEvent {}

class GetPhotoListEvent extends GalleryEvent {
  GetPhotoListEvent();
}


abstract class GalleryState {}

class GalleryStateInit extends GalleryState {}
class GalleryStateInProgress extends GalleryState {}
class GalleryStateFailure extends GalleryState {
  final String message;

  GalleryStateFailure(this.message);

}
class GalleryStateSuccess extends GalleryState {
  GalleryStateSuccess({required this.photos, this.isMoreResultAvailable});
  final List<PhotoEntity> photos;
  final isMoreResultAvailable;
}


class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetPhotoUseCase _getPhotoUseCase;
  var page = 0;
  var pageSize = 20;
  GalleryBloc(this._getPhotoUseCase) : super(GalleryStateInit()) {
    on<GetPhotoListEvent>((event, emit) => onGetPhotoList(event, emit));
  }

  void onGetPhotoList(GetPhotoListEvent event, Emitter<GalleryState> emit) async {
    page = 0;
    emit(GalleryStateInProgress());
    try {
      final response = await _getPhotoUseCase.getPhotoList(page, pageSize);
      emit(GalleryStateSuccess(photos: response, isMoreResultAvailable: true));
    } catch (ex) {
      emit(GalleryStateFailure(ex.toString()));
    }
  }

}

