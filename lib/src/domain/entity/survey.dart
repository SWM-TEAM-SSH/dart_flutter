import 'package:dart_flutter/src/domain/entity/option.dart';

class Survey {
  final int id;
  final String question;
  final List<Option> options;
  final bool picked;
  final int pickedOption;
  final DateTime createdAt;
  final String latestComment;

  Survey({
    required this.id,
    required this.question,
    required this.options,
    required this.picked,
    required this.pickedOption,
    required this.createdAt,
    required this.latestComment
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    final int parsedId = json['id'];
    final String parsedQuestion = json['question'];

    List<Option> parsedOptions = [];
    if (json['options'] != null) {
      var optionsList = json['options'] as List<dynamic>;
      parsedOptions = optionsList.map((v) => Option.fromJson(v)).toList();
    }

    final bool parsedPicked = json['picked'];
    final int parsedPickedOption = json['pickedOption'];
    final DateTime parsedCreatedAt = json['createdAt'];
    final String parsedLatestComment = json['latestComment'];

    return Survey(
      id: parsedId,
      question: parsedQuestion,
      options: parsedOptions,
      picked: parsedPicked,
      pickedOption: parsedPickedOption,
      createdAt: parsedCreatedAt,
      latestComment: parsedLatestComment
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['question'] = question;
    data['options'] = options;
    data['picked'] = picked;
    data['pickedOption'] = pickedOption;
    data['createdAt'] = createdAt;
    data['latestComment'] = latestComment;
    return data;
  }

  @override
  String toString() {
    return 'Survey{id: $id, question: $question, options: $options, picked: $picked, pickedOption: $pickedOption, createdAt: $createdAt, latestComment: $latestComment}';
  }

  bool isPicked() {
    if (picked == true) {
      return true;
    } else {
      return false;
    }
  }
}