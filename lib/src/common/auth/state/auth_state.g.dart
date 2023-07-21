// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) => AuthState(
      isLoading: json['isLoading'] as bool,
      step: $enumDecode(_$AuthStepEnumMap, json['step']),
      dartAccessToken: json['dartAccessToken'] as String,
      socialAccessToken: json['socialAccessToken'] as String,
      expiredAt: DateTime.parse(json['expiredAt'] as String),
      loginType: $enumDecode(_$LoginTypeEnumMap, json['loginType']),
      memo: json['memo'] as String,
    );

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'isLoading': instance.isLoading,
      'step': _$AuthStepEnumMap[instance.step]!,
      'dartAccessToken': instance.dartAccessToken,
      'socialAccessToken': instance.socialAccessToken,
      'expiredAt': instance.expiredAt.toIso8601String(),
      'loginType': _$LoginTypeEnumMap[instance.loginType]!,
      'memo': instance.memo,
    };

const _$AuthStepEnumMap = {
  AuthStep.land: 'land',
  AuthStep.signup: 'signup',
  AuthStep.login: 'login',
};

const _$LoginTypeEnumMap = {
  LoginType.kakao: 'kakao',
  LoginType.apple: 'apple',
  LoginType.email: 'email',
};
