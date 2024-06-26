import 'package:dart_flutter/src/domain/entity/user.dart';

class Comment {
  final int id;
  final User writer;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool liked;

  Comment({
    required this.id,
    required this.writer,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.liked
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final int parsedId = json['id'];
    User parsedWriter = User.fromJson(json['writer']);
    final String parsedContent = json['content'];
    final DateTime parsedCreatedAt = json['createdAt'];
    final int parsedLikes = json['likes'];
    final bool parsedLiked = json['liked'];

    return Comment(
      id: parsedId,
      writer: parsedWriter,
      content: parsedContent,
      createdAt: parsedCreatedAt,
      likes: parsedLikes,
      liked: parsedLiked
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['writer'] = writer;
    data['content'] = content;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  String toString() {
    return 'Comment{id: $id, writer: $writer, content: $content, createdAt: $createdAt, likes: $likes, liked: $liked}';
  }
}