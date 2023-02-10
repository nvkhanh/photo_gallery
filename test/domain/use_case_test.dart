import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:photo_gallery/data/repositories/photo_repository_impl.dart';
import 'package:photo_gallery/domain/get_photo_use_case.dart';

import '../helpers/json_reader.dart';

@GenerateMocks([http.Client])
void main() {
  setUp(() {

  });

  group('test use case', () {
    test('returns an list of photo if the http call completes successfully', () async {
      // arrange
      final jsonMock = jsonDecode(readJson('helpers/test_resource/dummy_photo_response.json'));
      final repository = PhotoRepositoryImpl(http.Client());
      final userCase = GetPhotoUseCase(repository);

      repository.client = MockClient((request) async {
        final jsonMap = jsonMock;
        return Response(json.encode(jsonMap), 200);
      });

      // act
      final item = await userCase.getPhotoList(0, 2);

      //assert
      expect(item.length, 2);
    });

  });

}