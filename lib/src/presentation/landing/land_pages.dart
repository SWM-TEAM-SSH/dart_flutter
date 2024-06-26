import 'dart:io';
import 'package:dart_flutter/src/common/auth/dart_auth_cubit.dart';
import 'package:dart_flutter/src/common/auth/state/dart_auth_state.dart';
import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/presentation/landing/view/land_page.dart';
import 'package:dart_flutter/src/presentation/signup/signup_pages.dart';
import 'package:dart_flutter/src/presentation/signup/viewmodel/signup_cubit.dart';
import 'package:dart_flutter/src/presentation/standby/standby_loading.dart';
import 'package:dart_flutter/src/presentation/standby/viewmodel/standby_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class LandPages extends StatefulWidget {
  const LandPages({Key? key}) : super(key: key);

  @override
  State<LandPages> createState() => _LandPagesState();
}

class _LandPagesState extends State<LandPages> {
  Future<String> getAndroidKeyHash() async {
    String key = await KakaoSdk.origin;
    return key;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<DartAuthCubit, DartAuthState>(builder: (context, state) {
          // 업데이트 여부 판단
          if (state.appVersionStatus.isUpdate || state.appVersionStatus.isMustUpdate) {
            return Container(
              color: Colors.black.withOpacity(0.4),
              child: AlertDialog(
                surfaceTintColor: Colors.white,
                title: const Text('새로운 버전이 나왔어요!'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(state.appUpdateComment),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // TextButton(
                  //   child: const Text('다음에하기'),
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  TextButton(
                    child: const Text('업데이트'),
                    onPressed: () {
                      AnalyticsUtil.logEvent('업데이트_버튼터치');
                      bool isAppleUser = Platform.isIOS;
                      if (isAppleUser) {
                        launchUrl(Uri.parse("https://apps.apple.com/us/app/dart/id6451335598"));
                      } else {
                        launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.sshdart.dart_flutter"), mode: LaunchMode.externalNonBrowserApplication);
                      }
                    },
                  ),
                ],
              ),
            );
          }

          // 화면 그리기
          if (state.step == AuthStep.land) {
            // if (state.tutorialStatus == TutorialStatus.notShown) {
            //   AnalyticsUtil.logEvent("온보딩슬라이드_접속");
            //   return TutorialSlide(
            //     onTutorialFinished: () {
            //       // 튜토리얼이 완료되면 AuthCubit을 사용하여 상태 변경
            //       BlocProvider.of<DartAuthCubit>(context).markTutorialShown();
            //     },
            //   );
            // }
            AnalyticsUtil.logEvent("로그인_접속");
            return const LoginPage();
          }
          if (state.step == AuthStep.signup || state.step == AuthStep.login) {
            BlocProvider.of<DartAuthCubit>(context).healthCheck();
          }
          if (state.step == AuthStep.signup) {
            // 소셜 로그인을 했지만, 아직 우리 회원가입은 안햇을 때
            return BlocProvider<SignupCubit>(
              create: (BuildContext context) => SignupCubit()..initState(
                BlocProvider.of<DartAuthCubit>(context).state.memo,
                BlocProvider.of<DartAuthCubit>(context).state.loginType.toString(),
              ),
              child: const SignupPages(),
            );
          }
          if (state.step == AuthStep.login) {
            BlocProvider.of<DartAuthCubit>(context).setAnalyticsUserInformation();
            BlocProvider.of<DartAuthCubit>(context).setPushNotificationUserId();
            AnalyticsUtil.logEvent("로그인_로그인성공");
            return BlocProvider<StandbyCubit>(
              create: (BuildContext context) => StandbyCubit()..initPages(),
              child: StandbyLoading(),
            );
          }
          return const SizedBox();
        }),

        BlocBuilder<DartAuthCubit, DartAuthState> (
          builder: (context, state) {
            if (!state.isLoading) {
              return const SizedBox.shrink();
            }
            return const SafeArea(child: Center(child: CircularProgressIndicator()));
          },
        ),
      ],
      // 화면 분배
    );
  }
}
