
import 'dart:convert';

import 'package:photo_gallery/domain/entities/photo_entity.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class PhotoResponse {
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
  });
  PhotoEntity toEntity() {
    return PhotoEntity(
      id: this.id,
      urls: this.urls?.toEntity()
    );
  }

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      id: asT<String?>(json['id']),
      createdAt: asT<String?>(json['created_at']),
      updatedAt: asT<String?>(json['updated_at']),
      promotedAt: asT<Object?>(json['promoted_at']),
      width: asT<int?>(json['width']),
      height: asT<int?>(json['height']),
      color: asT<String?>(json['color']),
      blurHash: asT<String?>(json['blur_hash']),
      description: asT<Object?>(json['description']),
      urls: json['urls'] == null
          ? null
          : Urls.fromJson(asT<Map<String, dynamic>>(json['urls'])!),
      likes: asT<int?>(json['likes']),
      likedByUser: asT<bool?>(json['liked_by_user']),
    );
  }

  String? id;
  String? createdAt;
  String? updatedAt;
  Object? promotedAt;
  int? width;
  int? height;
  String? color;
  String? blurHash;
  Object? description;
  Object? altDescription;
  Urls? urls;
  int? likes;
  bool? likedByUser;
  List<Object>? currentUserCollections;
  Object? topicSubmissions;

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
}

class Urls {
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
      raw: this.raw,
      full: this.full,
      regular: this.regular,
      small: this.thumb,
      smallS3: this.smallS3
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
}



