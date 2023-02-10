
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:photo_gallery/domain/entities/photo_entity.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class PhotoResponse extends Equatable {
  PhotoResponse({
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
  });
  PhotoEntity toEntity() {
    return PhotoEntity(
      id: id,
      createdAt: createdAt,
      promotedAt: promotedAt,
      updatedAt: updatedAt,
      width: width,
      height: height,
      color: color,
      blurHash: blurHash,
      description: description,
      likedByUser: likedByUser,
      likes: likes,
      urls: this.urls?.toEntity(),
      links: this.links?.toEntity(),
    );
  }

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      id: asT<String?>(json['id']),
      createdAt: asT<String?>(json['created_at']),
      updatedAt: asT<String?>(json['updated_at']),
      promotedAt: asT<String?>(json['promoted_at']),
      width: asT<int?>(json['width']),
      height: asT<int?>(json['height']),
      color: asT<String?>(json['color']),
      blurHash: asT<String?>(json['blur_hash']),
      description: asT<String?>(json['description']),
      urls: json['urls'] == null
          ? null
          : Urls.fromJson(asT<Map<String, dynamic>>(json['urls'])!),
      likes: asT<int?>(json['likes']),
      likedByUser: asT<bool?>(json['liked_by_user']),
      links: json['links'] == null
          ? null
          : LinkResponse.fromJson(asT<Map<String, dynamic>>(json['links'])!),
    );
  }

  String? id;
  String? createdAt;
  String? updatedAt;
  String? promotedAt;
  int? width;
  int? height;
  String? color;
  String? blurHash;
  String? description;
  String? altDescription;
  Urls? urls;
  int? likes;
  bool? likedByUser;
  List<Object>? currentUserCollections;
  Object? topicSubmissions;
  LinkResponse? links;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'promoted_at': promotedAt,
    'width': width,
    'height': height,
    'color': color,
    'blur_hash': blurHash,
    'description': description,
    'alt_description': altDescription,
    'urls': urls,
    'likes': likes,
    'liked_by_user': likedByUser,
    'current_user_collections': currentUserCollections,
    'topic_submissions': topicSubmissions,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    urls,
  ];
}

class LinkResponse extends Equatable {
  LinkResponse({this.html});
  String? html;
  factory LinkResponse.fromJson(Map<String, dynamic> json) => LinkResponse(
    html: asT<String?>(json['html']),
  );

  String? raw;

  @override
  // TODO: implement props
  List<Object?> get props => [html];

  LinkEntity toEntity() {
    return LinkEntity(html: this.html);
  }
}
class Urls extends Equatable {
  Urls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
    this.smallS3,
  });

  UrlsEntity toEntity() {
    return UrlsEntity(
      raw: raw,
      full: full,
      regular: regular,
      small: thumb,
      smallS3: smallS3
    );
  }
  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    raw: asT<String?>(json['raw']),
    full: asT<String?>(json['full']),
    regular: asT<String?>(json['regular']),
    small: asT<String?>(json['small']),
    thumb: asT<String?>(json['thumb']),
    smallS3: asT<String?>(json['small_s3']),
  );

  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;
  String? smallS3;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'raw': raw,
    'full': full,
    'regular': regular,
    'small': small,
    'thumb': thumb,
    'small_s3': smallS3,
  };

  @override
  // TODO: implement props
  List<Object?> get props => [
    raw,
    full,
    regular,
  ];
}



