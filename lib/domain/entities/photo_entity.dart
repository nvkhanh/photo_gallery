
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PhotoEntity extends Equatable {
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
    this.links,
    this.isLiked,
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
  LinkEntity? links;
  int? likes;
  bool? likedByUser;
  bool? isLiked;

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    urls,
  ];

}
// ignore: must_be_immutable
class LinkEntity extends Equatable {
  LinkEntity({this.html});
  String? html;

  @override
  // TODO: implement props
  List<Object?> get props => [html];
}

// ignore: must_be_immutable
class UrlsEntity extends Equatable {
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

  @override
  // TODO: implement props
  List<Object?> get props => [
    raw,
    full,
    regular,
  ];

}