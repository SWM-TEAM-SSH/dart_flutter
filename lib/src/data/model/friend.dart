import 'package:dart_flutter/src/data/model/university.dart';

class Friend {
  int? userId;
  String? name;
  int? admissionYear;
  String? gender;
  University? university;

  Friend({this.userId, this.name, this.admissionYear, this.gender, this.university});

  Friend.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    admissionYear = json['admissionYear'];
    university = json['university'] != null
        ? University.fromJson(json['university'])
        : null;
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['name'] = name;
    data['admissionYear'] = admissionYear;
    if (university != null) {
      data['university'] = university!.toJson();
    }
    data['gender'] = gender;
    return data;
  }

  @override
  bool operator == (Object other) {
    if (userId == (other as Friend).userId) {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'Friend{userId: $userId, name: $name, gender: $gender, admissionYear: $admissionYear, university: $university}';
  }
}

// import 'package:dart_flutter/src/data/model/university.dart';
// import 'package:json_annotation/json_annotation.dart';
// part 'friend.g.dart';
//
// @JsonSerializable()
// class Friend {
//   final int userId;
//   final int admissionNum;
//   final int mutualFriend;
//   final String name;
//   final University university;
//
//   Friend({
//     required this.userId,
//     required this.admissionNum,
//     this.mutualFriend = 0,
//     required this.name,
//     required this.university,
//   });
//
//   Map<String, dynamic> toJson() => _$FriendToJson(this);
//   static Friend fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
//
//   @override
//   String toString() {
//     return 'Friend{userId: $userId, admissionNumber: $admissionNum, name: $name, university: $university}';
//   }
// }
