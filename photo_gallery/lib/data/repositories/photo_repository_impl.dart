
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_gallery/data/constants.dart';
import 'package:photo_gallery/data/models/photo_response.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/domain/repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {

  Client client;
  PhotoRepositoryImpl(this.client);


  @override
  Future<List<PhotoEntity>> getPhoto(int page, int pageSize) async {
    var apiFullPath = "${Constants.baseURL}photos?client_id=${Constants.clientId}&page=$page&per_page=$pageSize";
    final http.Response response = await client.get(Uri.parse(apiFullPath));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var res = List<PhotoResponse>.from(json.map((x) => PhotoResponse.fromJson(x)));
      return res.map((e) => e.toEntity()).toList();
    } else {
      throw Exception('An error occurred while connecting to server');
    }
  }
}
