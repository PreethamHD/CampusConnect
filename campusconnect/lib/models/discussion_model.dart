// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DiscussionModel {
  final String id;
  final String senderId;
  final String text;
  final String? imageUrl;
  final DateTime timestamp;
  DiscussionModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.imageUrl,
    required this.timestamp,
  });

  DiscussionModel copyWith({
    String? id,
    String? senderId,
    String? text,
    String? imageUrl,
    DateTime? timestamp,
  }) {
    return DiscussionModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory DiscussionModel.fromMap(Map<String, dynamic> map) {
    return DiscussionModel(
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory DiscussionModel.fromJson(String source) =>
      DiscussionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiscussionModel(id: $id, senderId: $senderId, text: $text, imageUrl: $imageUrl, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant DiscussionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderId == senderId &&
        other.text == text &&
        other.imageUrl == imageUrl &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        text.hashCode ^
        imageUrl.hashCode ^
        timestamp.hashCode;
  }
}
