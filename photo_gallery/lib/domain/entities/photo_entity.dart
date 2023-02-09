
class PhotoEntity {
  PhotoEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.promotedAt,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.description,
    this.urls,
    this.likes,
    this.likedByUser,
  });

  String? id;
  String? createdAt;
  String? updatedAt;
  Object? promotedAt;
  int? width;
  int? height;
  String? color;
  String? blurHash;
  String? description;
  UrlsEntity? urls;
  int? likes;
  bool? likedByUser;

}

class UrlsEntity {
  UrlsEntity({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
    this.smallS3,
  });



  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;
  String? smallS3;


}