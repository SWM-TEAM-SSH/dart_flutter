import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/presentation/signup/view/cert_num.dart';
import 'package:dart_flutter/src/presentation/signup/view/choose_gender.dart';
import 'package:dart_flutter/src/presentation/signup/view/choose_id.dart';
import 'package:dart_flutter/src/presentation/signup/view/choose_major.dart';
import 'package:dart_flutter/src/presentation/signup/view/choose_school.dart';
import 'package:dart_flutter/src/presentation/signup/view/user_name.dart';
import 'package:dart_flutter/src/presentation/signup/view/user_phone.dart';
import 'package:dart_flutter/src/presentation/signup/viewmodel/signup_cubit.dart';
import 'package:dart_flutter/src/presentation/signup/viewmodel/state/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPages extends StatefulWidget {
  const SignupPages({Key? key}) : super(key: key);

  @override
  State<SignupPages> createState() => _SignupPagesState();
}

class _SignupPagesState extends State<SignupPages> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<SignupCubit, SignupState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.signupStep.isSchool) {
              AnalyticsUtil.logEvent("회원가입_학교_접속");
              return const ChooseSchool();
            }
            if (state.signupStep.isDepartment) {
              AnalyticsUtil.logEvent("회원가입_학과_접속");
              return const ChooseMajor();
            }
            if (state.signupStep.isAdmissionNumber) {
              AnalyticsUtil.logEvent("회원가입_학번나이_접속");
              return const ChooseId();
            }
            if (state.signupStep.isName) {
              AnalyticsUtil.logEvent("회원가입_이름_접속");
              return const UserName();
            }
            if (state.signupStep.isPhone) {
              return const UserPhone();
            }
            if (state.signupStep.isValidatePhone) {
              return CertNum();
            }
            if (state.signupStep.isGender) {
              AnalyticsUtil.logEvent("회원가입_성별_접속");
              return const ChooseGender();
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
