
import 'package:photo_gallery/domain/entities/photo_entity.dart';
import 'package:photo_gallery/domain/repository.dart';

class GetPhotoUseCase {
  final PhotoRepository repository;

  GetPhotoUseCase(this.repository);

  Future<List<PhotoEntity>> getPhotoList(int page, int pageSize) async {
    var res = await repository.getPhoto(page, pageSize);
    return res;
  }

}