import 'package:json_annotation/json_annotation.dart';
part 'auth_state.g.dart';

enum LoginType {
  kakao, apple, email;
}

enum AuthStep {
  land, signup, login;
}

@JsonSerializable()
class AuthState {
  bool isLoading;
  AuthStep step;
  String socialAccessToken;
  DateTime expiredAt;
  LoginType loginType;

  AuthState({
    required this.isLoading,
    required this.step,
    required this.socialAccessToken,
    required this.expiredAt,
    required this.loginType
  });

  AuthState setSocialAuth({
    required LoginType loginType,
    required String socialAccessToken,
    required DateTime expiredAt,
  }) {
    this.loginType = loginType;
    this.socialAccessToken = socialAccessToken;
    this.expiredAt = expiredAt;
    return this;
  }

  AuthState setStep(AuthStep step) {
    this.step = step;
    return this;
  }

  AuthState setLoading(bool boolean) {
    isLoading = boolean;
    return this;
  }

  AuthState copy() => AuthState(
    isLoading: isLoading,
    step: step,
    socialAccessToken: socialAccessToken,
    expiredAt: expiredAt,
    loginType: loginType,
  );

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
  AuthState fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);

  @override
  String toString() {
    return 'AuthState{isLoading: $isLoading, step: $step, accessToken: $socialAccessToken, expiredAt: $expiredAt, loginType: $loginType}';
  }
}