
import 'package:photo_gallery/domain/entities/photo_entity.dart';

abstract class PhotoRepository {
  Future<List<PhotoEntity>> getPhoto(int page, int pageSize);
}