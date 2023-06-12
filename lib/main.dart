import 'package:dart_flutter/res/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:dart_flutter/src/presentation/signup/land_page.dart';

// 랜딩페이지
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'c83df49e14c914b9bda9b902b6624da2',
  );
  runApp(MaterialApp(
    home: MyApp(),
    theme: AppTheme.lightThemeData,
  ));
}

// stless 입력으로 기존 기본 템플릿 -> stateless로 변경
// stless(변경 필요한 data x) vs stful(변경된 부분을 위젯에 반영하는 동적 위젯)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LandingPage();
  }
}
