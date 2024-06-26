import 'package:dart_flutter/res/environment/app_environment.dart';
import 'package:dart_flutter/res/theme/app_theme.dart';
import 'package:dart_flutter/res/config/size_config.dart';
import 'package:dart_flutter/src/common/auth/dart_auth_cubit.dart';
import 'package:dart_flutter/src/common/auth/state/dart_auth_state.dart';
import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/common/util/appsflyer_util.dart';
import 'package:dart_flutter/src/common/util/crashlytics_util.dart';
import 'package:dart_flutter/src/common/util/push_notification_util.dart';
import 'package:dart_flutter/src/common/util/shared_preferences_util.dart';
import 'package:dart_flutter/src/common/util/timeago_util.dart';
import 'package:dart_flutter/src/common/util/toast_util.dart';
import 'package:dart_flutter/src/presentation/landing/land_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 랜딩페이지
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 초기화 순서에 유의할 것
  const BUILD_TYPE = String.fromEnvironment('BUILD_TYPE', defaultValue: 'DEFAULT');
  AppEnvironment.setupEnv(BuildType.from(BUILD_TYPE));
  if (AppEnvironment.buildType.isLocal) ToastUtil.showToast("실행환경: Local");
  if (AppEnvironment.buildType.isDev) ToastUtil.showToast("실행환경: Develop");
  if (AppEnvironment.buildType.isStage) ToastUtil.showToast("실행환경: Staging");
  print("실행환경: ${AppEnvironment.getEnv.toString()}");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AnalyticsUtil.initialize();
  KakaoSdk.init(nativeAppKey: AppEnvironment.getEnv.getKakaoSdkKey());
  PushNotificationUtil.init();
  await Supabase.initialize(url: AppEnvironment.getEnv.getSupabaseUrl(), anonKey: AppEnvironment.getEnv.getSupabaseApiKey());
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getTemporaryDirectory());
  AppsflyerUtil.init();
  if (AppEnvironment.buildType.isProd) { await CrashlyticsUtil.init(enabled: true);}
  else {await CrashlyticsUtil.init();}
  await MobileAds.instance.initialize();
  await SharedPreferencesUtil.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark
  ));

  runApp(BlocProvider(
      create: (BuildContext context) => DartAuthCubit()..appVersionCheck()..setLandPage(),
      child: MaterialApp(
        home: const MyApp(),
        theme: AppTheme.lightThemeData,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // 기준 사이즈 지정
    TimeagoUtil().initKorean();

    // 로그인하지 않은 유저는 LandingPages로, 로그인한 유저는 MainPage로 이동
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DartAuthCubit, DartAuthState>(
          builder: (context, state) {
            if (state.step == AuthStep.login && state.dartAccessToken.length > 20 && DateTime.now().microsecondsSinceEpoch < state.expiredAt.microsecondsSinceEpoch) {
              print("now accessToken: ${state.dartAccessToken}");
              BlocProvider.of<DartAuthCubit>(context).setAccessToken(state.dartAccessToken);
            }
            return const LandPages();
          },
        ),
      ),
    );
  }
}
