import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:photo_gallery/data/models/photo_response.dart';
import 'package:photo_gallery/data/repositories/photo_repository_impl.dart';
import 'package:photo_gallery/domain/get_photo_use_case.dart';
import 'package:photo_gallery/presentation/bloc/gallery_bloc.dart';

import '../helpers/json_reader.dart';

class MockGalleryBloc extends MockBloc<GalleryEvent, GalleryState> implements GalleryBloc {}

void main() {

  var json = jsonDecode(readJson('helpers/test_resource/dummy_photo_response.json'));
  var res = List<PhotoResponse>.from(json.map((x) => PhotoResponse.fromJson(x)));
  var photos = res.map((e) => e.toEntity()).toList();

  blocTest<GalleryBloc, GalleryState>(
    'should emit [loading, has data] when data is gotten successfully',
    build: () {
      // arrange
      final jsonMock = readJson('helpers/test_resource/dummy_photo_response.json');
      final repository = PhotoRepositoryImpl(http.Client());
      final userCase = GetPhotoUseCase(repository);

      repository.client = MockClient((request) async {
        return Response(jsonMock, 200);
      });
      return GalleryBloc(userCase);
    },
    act: (bloc) => bloc.add(GetPhotoListEvent()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      GalleryStateInProgress(),
      GalleryStateSuccess(photos: photos, page: 0),
    ],
  );

  blocTest<GalleryBloc, GalleryState>(
    'should emit [loading, error state] when data is not gotten successfully',
    build: () {
      // arrange
      final jsonMock = readJson('helpers/test_resource/dummy_photo_response.json');
      final repository = PhotoRepositoryImpl(http.Client());
      final userCase = GetPhotoUseCase(repository);

      repository.client = MockClient((request) async {
        return Response(jsonMock, 500);
      });
      return GalleryBloc(userCase);
    },
    act: (bloc) => bloc.add(GetPhotoListEvent()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      GalleryStateInProgress(),
      GalleryStateFailure(message: 'An error occurred while connecting to server', page: 0),
    ],
  );


}