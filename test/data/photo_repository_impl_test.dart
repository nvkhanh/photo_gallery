import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:photo_gallery/data/repositories/photo_repository_impl.dart';

import '../helpers/json_reader.dart';

@GenerateMocks([http.Client])
void main() {
  setUp(() {

  });

  group('fetch photo', () {
    test('returns an list of photo if the http call completes successfully', () async {
      // arrange
      final jsonMock = jsonDecode(readJson('helpers/test_resource/dummy_photo_response.json'));
      final repository = PhotoRepositoryImpl(http.Client());
      repository.client = MockClient((request) async {
        final jsonMap = jsonMock;
        return Response(json.encode(jsonMap), 200);
      });

      // act
      final item = await repository.getPhoto(0, 10);

      //assert
      expect(item.length, 2);
    });

  });

}