import 'package:dart_flutter/res/config/size_config.dart';
import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/common/util/university_finder.dart';
import 'package:dart_flutter/src/domain/entity/university.dart';
import 'package:dart_flutter/src/presentation/signup/viewmodel/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../component/webview_fullscreen.dart';

class ChooseMajor extends StatelessWidget {
  const ChooseMajor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: ScaffoldBody(),
      ))
    );
  }
}
class ScaffoldBody extends StatefulWidget {
  const ScaffoldBody({
    super.key,
  });

  @override
  State<ScaffoldBody> createState() => _ScaffoldBodyState();
}

class _ScaffoldBodyState extends State<ScaffoldBody> {
  late UniversityFinder universityFinder;
  final TextEditingController _typeAheadController = TextEditingController();
  late bool isSelectedOnTypeAhead = false;
  late String universityName;
  String universityDepartment = "";
  late University university;

  @override
  void initState() {
    super.initState();
    List<University> universities = BlocProvider.of<SignupCubit>(context).getUniversities;
    universityFinder = UniversityFinder(universities: universities);
    universityName = BlocProvider.of<SignupCubit>(context).state.inputState.tempUnivName!;
    setState(() {
      isSelectedOnTypeAhead = false;
    });
  }

  // void _typeOnTypeAhead() { // ver.1
  //   setState(() {
  //     isSelectedOnTypeAhead = false;
  //   });
  // }
  // void _typeOnTypeAhead() { // ver.2
  //   if (!_typeAheadController.text.isEmpty) { // 텍스트 필드가 비어있을 때에만 업데이트
  //     setState(() {
  //       isSelectedOnTypeAhead = false;
  //     });
  //   }
  // }
  void _typeOnTypeAhead() { // ver.3
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_typeAheadController.text.isNotEmpty) {
        setState(() {
          isSelectedOnTypeAhead = false;
        });
      }
    });
  }

  void _selectOnTypeAhead() {
    setState(() {
      isSelectedOnTypeAhead = true;
      AnalyticsUtil.logEvent("회원가입_학과_선택");
    });
  }

  void _setUniversity(University university) {
    _setUniversityDepartment(university.department);
    this.university = university;
  }

  void _setUniversityDepartment(String name) {
    universityDepartment = name;
    _typeAheadController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.15,
          ),
          Text("학과를 선택해주세요!", style: TextStyle(fontSize: SizeConfig.defaultSize * 2.7, fontWeight: FontWeight.w700)),
          SizedBox(
            height: SizeConfig.defaultSize * 1.5,
          ),
          Text("이후 변경할 수 없어요! 신중히 선택해주세요!",
              style: TextStyle(fontSize: SizeConfig.defaultSize * 1.2, color: Colors.grey)),
          SizedBox(
              height: SizeConfig.defaultSize * 10
          ),
          SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
                child: TypeAheadField(
                  noItemsFoundBuilder: (context) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        "학과를 입력해주세요!",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  },
                  suggestionsBoxDecoration: const SuggestionsBoxDecoration( // 목록 배경색
                    color: Colors.white,
                    elevation: 2.0,
                  ),
                  // 학과 찾기
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _typeAheadController,
                      autofocus: false, // 키보드 자동으로 올라오는 거
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontStyle: FontStyle.normal,
                          fontSize: getFlexibleSize(target: 15),
                          fontWeight: FontWeight.w400,
                          color: isSelectedOnTypeAhead ? const Color(0xff7C83FD) : Colors.black),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade200, // 테두리 색상
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff7C83FD), // 테두리 색상
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.school_rounded, color: Color(0xff7C83FD),),
                          hintText: "학과 이름")),

                  suggestionsCallback: (pattern) {
                    // 입력된 패턴에 기반하여 검색 결과를 반환
                    _typeOnTypeAhead();
                    if (pattern.isEmpty || isSelectedOnTypeAhead) {
                      return [];
                    }
                    return universityFinder.getDepartmentSuggestions(universityName, pattern);
                  },

                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(suggestion['department']),
                      subtitle: Text('${suggestion['name']}'),
                    );
                  },

                  // 추천 text를 눌렀을 때 일어나는 액션 (밑의 코드는 ProductPage로 넘어감)
                  onSuggestionSelected: (suggestion) {
                    if (isSelectedOnTypeAhead == false) {
                      _selectOnTypeAhead();
                    }

                    _setUniversity(University.fromJson(suggestion));
                  },
                ),
              )),
          SizedBox( height: SizeConfig.defaultSize * 10, ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.9,
            height: SizeConfig.defaultSize * 5,
            child: isSelectedOnTypeAhead
                ? ElevatedButton(
                onPressed: () {
                  AnalyticsUtil.logEvent("회원가입_학과_다음");
                  if (isSelectedOnTypeAhead) {BlocProvider.of<SignupCubit>(context).stepDepartment(university);}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff7C83FD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // 모서리 둥글기 설정
                  ),
                ),
                child: Text("다음으로", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.7, fontWeight: FontWeight.w600, color: Colors.white),)
            )
                : ElevatedButton(
                onPressed: () {
                  if (isSelectedOnTypeAhead) {
                    BlocProvider.of<SignupCubit>(context).stepSchool(universityName);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
                child: Text("학과를 선택해주세요", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.7, fontWeight: FontWeight.w600, color: Colors.black38),)
            ),
          ),
            SizedBox(height: SizeConfig.defaultSize * 3),
          Center(
            child: InkWell(
              onTap: () {
                AnalyticsUtil.logEvent("회원가입_학과_도움말터치");
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WebViewFullScreen(url: 'https://tally.so/r/merode', title: '학과 정보 추가 문의')))
                    .then((_) {
                  AnalyticsUtil.logEvent("회원가입_학과_도움말_뒤로가기(회원가입_접속)");
                });
              },
              child: Container(
                width: SizeConfig.defaultSize * 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 0.9, vertical: SizeConfig.defaultSize * 0.75),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: SizeConfig.defaultSize * 1.5, color: Colors.black.withOpacity(0.6)),
                      Text(" 학과가 검색되지 않아요!", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
