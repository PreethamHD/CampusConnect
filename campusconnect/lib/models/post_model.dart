// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';

class PostModel {
  final String id;
  final String authorId;
  final String content;
  final String? imageUrl;
  final List<String> likes;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.authorId,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.timestamp,
  });

  PostModel copyWith({
    String? id,
    String? authorId,
    String? content,
    String? imageUrl,
    List<String>? likes,
    DateTime? timestamp,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      likes: List<String>.from(map['likes'] ?? []),
      timestamp:
          map['timestamp'] != null && map['timestamp'] is int
              ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
              : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, content: $content, imageUrl: $imageUrl, likes: $likes, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.authorId == authorId &&
        other.content == content &&
        other.imageUrl == imageUrl &&
        listEquals(other.likes, likes) &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        authorId.hashCode ^
        content.hashCode ^
        imageUrl.hashCode ^
        likes.hashCode ^
        timestamp.hashCode;
  }
}
