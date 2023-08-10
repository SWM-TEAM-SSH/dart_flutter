import 'package:dart_flutter/src/domain/entity/user_response.dart';

class UserRequestDto {
  static const String DEFAULT_VALUE = "DEFAULT";

  String? nickname;
  String? profileImageUrl;

  UserRequestDto({this.nickname, this.profileImageUrl});

  UserRequestDto.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nickname'] = nickname;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }

  Map<String, dynamic> toBody() {
    nickname = checkAndSetDefault(nickname);
    profileImageUrl = checkAndSetDefault(profileImageUrl);
    return toJson();
  }

  dynamic checkAndSetDefault(dynamic value) {
      if (value == null || value == "") {
        value = DEFAULT_VALUE;
      }
      return value;
  }

  static UserRequestDto fromUserResponse(UserResponse userResponse) {
    return UserRequestDto(
      nickname: userResponse.user!.nickname,
      profileImageUrl: userResponse.user!.profileImageUrl
    );
  }

  @override
  String toString() {
    return 'UserRequestDto{nickname: $nickname, profileImageUrl: $profileImageUrl}';
  }
}
