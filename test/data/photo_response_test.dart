import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:photo_gallery/data/models/photo_response.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';

import '../helpers/json_reader.dart';


void main() {
  var photoResponse = PhotoResponse(
    id: "KR0WW6bjtt0",
    createdAt: "2022-08-31T14:36:55Z",
    updatedAt: "2023-02-09T13:18:06Z",
    promotedAt: null,
    width: 4928,
    height: 3264,
    color: "#d9d9d9",
    blurHash: "LZM7x_I9o\$og~V.8M|t7p0NGMw%M",
    description: "",
    urls: Urls(
      regular: "https://images.unsplash.com/photo-1661956601031-4cf09efadfce?ixid=Mnw0MDg0MDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NTk5NDk0MQ&ixlib=rb-4.0.3",
      full:  "https://images.unsplash.com/photo-1661956601031-4cf09efadfce?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDg0MDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NTk5NDk0MQ&ixlib=rb-4.0.3&q=80",
      smallS3: "https://images.unsplash.com/photo-1661956601031-4cf09efadfce?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDg0MDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NTk5NDk0MQ&ixlib=rb-4.0.3&q=80&w=400",
    )

  );

  var photoEntity = PhotoEntity(
      id: "KR0WW6bjtt0",
      createdAt: "2022-08-31T14:36:55Z",
      updatedAt: "2023-02-09T13:18:06Z",
      promotedAt: null,
      width: 4928,
      height: 3264,
      color: "#d9d9d9",
      blurHash: "LZM7x_I9o\$og~V.8M|t7p0NGMw%M",
      description: "",
      urls: UrlsEntity(
        regular: "https://images.unsplash.com/photo-1661956601031-4cf09efadfce?ixid=Mnw0MDg0MDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NTk5NDk0MQ&ixlib=rb-4.0.3",
        full:  "https://images.unsplash.com/photo-1661956601031-4cf09efadfce?crop=entropy&cs=tinysrgb&fm=jpg&ixid=Mnw0MDg0MDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NTk5NDk0MQ&ixlib=rb-4.0.3&q=80",
        smallS3: "https://images.unsplash.com/photo-1661956601031-4cf09efadfce?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw0MDg0MDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTY3NTk5NDk0MQ&ixlib=rb-4.0.3&q=80&w=400",
      )
  );

  group('to entity', () {
    test(
      'should be a subclass of photo entity',
          () async {
        // assert
        final result = photoResponse.toEntity();

        expect(result, equals(photoEntity));
      },
    );
  });

  group('from json', () {
    test(
      'should return a valid model from json',
          () async {
        // arrange
        final json = jsonDecode(readJson('helpers/test_resource/dummy_photo_response.json'));

        // act
        final result = List<PhotoResponse>.from(json.map((x) => PhotoResponse.fromJson(x)));

        // assert
        expect(result, isA<List<PhotoResponse>>());
        expect(result.length, 2);
      },
    );
  });

}
