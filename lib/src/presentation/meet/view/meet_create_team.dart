import 'package:dart_flutter/res/config/size_config.dart';
import 'package:dart_flutter/src/domain/entity/location.dart';
import 'package:dart_flutter/src/domain/entity/meet_team.dart';
import 'package:dart_flutter/src/presentation/meet/viewmodel/meet_cubit.dart';
import 'package:dart_flutter/src/presentation/meet/viewmodel/state/meet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_flutter/src/domain/entity/user.dart';

class MeetCreateTeam extends StatefulWidget {
  final VoidCallback onFinish;

  MeetCreateTeam({super.key, required this.onFinish});

  @override
  State<MeetCreateTeam> createState() => _MeetCreateTeamState();
}

class _MeetCreateTeamState extends State<MeetCreateTeam> {
  // 수정일 때 late int id;
  String name = '';

  void handleTeamNameChanged(String newName) {
    name = newName;
  }

  late MeetState ancestorState;

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackKey() async {
      return await showDialog(
          context: context,
          builder: (BuildContext sheetContext) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text("팀 만들기를 종료하시겠어요?", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                  },
                  child: Text('취소', style: TextStyle(color: Color(0xffFF5C58))),
                ),
                TextButton(
                  onPressed: () {
                    widget.onFinish();
                    Navigator.pop(context, true);
                  },
                  child: Text('끝내기', style: TextStyle(color: Color(0xffFF5C58))),
                )
              ],
            );
          });
    };

    return WillPopScope(
      onWillPop: () {
        return _onBackKey();
      },
      child: BlocProvider<MeetCubit>(
        create: (context) => MeetCubit(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: BlocBuilder<MeetCubit, MeetState>(
                  builder: (context, state) {
                    context.read<MeetCubit>().initState();
                    print(state.userResponse);
                    var friendsList = state.friends.toList();
                    var teamMemberList = state.teamMembers.toList();
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.defaultSize * 1.3),
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfig.defaultSize),
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await _onBackKey();
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                                          size: SizeConfig.defaultSize * 2)),
                                  Text("과팅 팀 만들기",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: SizeConfig.defaultSize * 2,
                                      )),
                                ]),
                            SizedBox(height: SizeConfig.defaultSize * 1.5),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.3),
                                  child: Column(
                                    children: [
                                      _CreateTeamTopSection(userResponse: state.userResponse, handleTeamNameChanged: handleTeamNameChanged, state: state),
                                      // 나
                                      _MemberCardView(userResponse: state.userResponse, state: state),
                                      // 친구1
                                      state.isMemberOneAdded
                                          ? _MemberCardView(userResponse: teamMemberList[0], state: state)
                                          : Container(),
                                      // 친구2
                                      state.isMemberTwoAdded
                                          ? _MemberCardView(userResponse: teamMemberList[1], state: state)
                                          : Container(),
                                      // 버튼
                                      state.isMemberTwoAdded
                                          ? Container()
                                          : InkWell( // 팀원 추가하기 버튼 *******
                                        onTap: () {
                                          _ShowModalBottomSheet(context, state, friendsList);
                                          // context.read<MeetCubit>().pressedMemberAddButton();
                                        },
                                        child: Container(
                                            width: SizeConfig.screenWidth,
                                            height: SizeConfig.defaultSize * 6,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("+   팀원 추가하기", style: TextStyle(
                                                fontSize: SizeConfig.defaultSize * 1.6
                                            ),)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
            bottomNavigationBar: BlocBuilder<MeetCubit, MeetState>(
                builder: (buildContext, state) {
                  return _CreateTeamBottomSection(state: state, name: name, ancestorContext: context);
                }
            )
        ),
      ),
    );
  }

  Future<dynamic> _ShowModalBottomSheet(BuildContext context, MeetState state, List<User> friendsList) {
    return showModalBottomSheet( // 친구 목록 ********
        context: context,
        builder: (BuildContext _) {
          return Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.05,
                      alignment: Alignment.center,
                      child: Container(
                        width: SizeConfig.screenWidth * 0.15,
                        height: SizeConfig.defaultSize * 0.3,
                        color: Colors.grey,
                      )
                  ),
                  Flexible(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("우리 학교 친구 ${state.friends.length}명", style: TextStyle(
                                fontSize: SizeConfig.defaultSize * 1.6,
                                fontWeight: FontWeight.w600
                            ),),
                              SizedBox(height: SizeConfig.defaultSize * 0.5,),
                            Text("같은 학교 친구 \'최대 2명\'과 과팅에 참여할 수 있어요!", style: TextStyle(
                                fontSize: SizeConfig.defaultSize * 1.3
                            ),),
                              SizedBox(height: SizeConfig.defaultSize,),
                            Flexible(
                              child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (int i=0; i<state.friends.length; i++)
                                        _OneFriendComponent(friend: friendsList[i], count: state.friends.length, nowNum: i, sheetContext: context,),
                                    ],
                                  )
                              ),
                            ),
                          ]
                      )
                  )
                ],
              )
          );
        }
    );
  }
}

class _OneFriendComponent extends StatefulWidget {
  BuildContext sheetContext;
  late User friend;
  late int count;
  late int nowNum;

  _OneFriendComponent({
    super.key,
    required this.friend,
    required this.count,
    required this.nowNum,
    required this.sheetContext,
  });

  @override
  State<_OneFriendComponent> createState() => _OneFriendComponentState();
}

class _OneFriendComponentState extends State<_OneFriendComponent> {
  String get profileImageUrl => widget.friend.personalInfo?.profileImageUrl ?? 'DEFAULT';
  // RadioButton 설정
  late int selectedRadio;
  late int selectedRadioTile;
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = 0;
  }
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }
  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) { // 친구 한 명 View *******
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.9, right: SizeConfig.defaultSize * 1),
      child: Column(
        children: [
            SizedBox(height: SizeConfig.defaultSize * 0.6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.75,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    profileImageUrl == "DEFAULT"
                        ? ClipOval(
                          child: Image.asset('assets/images/profile-mockup3.png', width: SizeConfig.defaultSize * 4.3, fit: BoxFit.cover,),
                          )
                        : ClipOval(
                        child: Image.network(profileImageUrl,
                          width: SizeConfig.defaultSize * 4.3,
                          height: SizeConfig.defaultSize * 4.3,
                          fit: BoxFit.cover,)
                    ),
                      SizedBox(width: SizeConfig.defaultSize,),
                    Text(widget.friend.personalInfo?.name ?? "XXX", style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    )),
                      SizedBox(width: SizeConfig.defaultSize * 0.5,),
                    Flexible(
                      child: Container(
                        child: Text("${widget.friend.university?.department}", style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.4,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black
                        )),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                child: Text("추가", style: TextStyle(color: Color(0xffFF5C58)),),
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(0)
                ),
                onPressed: () {
                  widget.sheetContext.read<MeetCubit>().pressedMemberAddButton(widget.friend);
                  Navigator.pop(widget.sheetContext);
                  print(widget.nowNum+1);
                },
              ),
            ],
          ),
            SizedBox(height: SizeConfig.defaultSize * 0.6,),
        ],
      ),
    );
  }
}

class _CreateTeamTopSection extends StatefulWidget {
  User userResponse;
  MeetState state;
  final handleTeamNameChanged;

  _CreateTeamTopSection({
    super.key,
    required this.userResponse,
    required this.state,
    this.handleTeamNameChanged
  });
  @override
  State<_CreateTeamTopSection> createState() => _CreateTeamTopSectionState();
}

class _CreateTeamTopSectionState extends State<_CreateTeamTopSection> {
  // textfield
  late TextEditingController _controller;

  void onTeamNameChanged(String value) {
    (value); // Callback to parent widget
    widget.state.teamName = value;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(children: [
              Text("학교",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.defaultSize * 1.6,
                      color: Colors.grey
                  )),
              SizedBox(width: SizeConfig.defaultSize,),
              Text("${widget.userResponse.university?.name ?? '학교를 불러오지 못 했어요'}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.defaultSize * 1.6,
                      color: Colors.grey
                  ))
            ]),
              SizedBox(height: SizeConfig.defaultSize * 0.5),
            Row(children: [
              Text("팀명",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.defaultSize * 1.6,
                      color: Colors.black
                  )),
              SizedBox(width: SizeConfig.defaultSize,),
              Flexible(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      setState(() {
                        widget.state.teamName = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "이성에게 보여질 팀명을 입력해주세요!",
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 0.6)),
                    ),

                  )
              )
            ]),
              SizedBox(height: SizeConfig.defaultSize),
          ],
        )
      ],
    );
  }
}

class _MemberCardView extends StatelessWidget {
  late User userResponse;
  late MeetState state;

  _MemberCardView({
    super.key,
    required this.userResponse,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 0.8),
      child: Container( // 카드뷰 시작 *****************
        width: SizeConfig.screenWidth,
        height: SizeConfig.defaultSize * 21.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xffFF5C58).withOpacity(0.5),
            width: 1.5
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 1.2, horizontal: SizeConfig.defaultSize * 1.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row( // 위층 (받은 투표 위까지)
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // AnalyticsUtil.logEvent("내정보_마이_내사진터치");
                        },
                        child: userResponse.personalInfo?.profileImageUrl == "DEFAULT"
                            ? ClipOval(
                              child: Image.asset('assets/images/profile-mockup3.png', width: SizeConfig.defaultSize * 6.2, fit: BoxFit.cover,),
                              )
                            : ClipOval(
                              child: Image.network(userResponse.personalInfo!.profileImageUrl,
                              width: SizeConfig.defaultSize * 6.2,
                              height: SizeConfig.defaultSize * 6.2,
                              fit: BoxFit.cover,)
                        ),
                      ),
                      SizedBox(width: SizeConfig.defaultSize * 0.8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row( // 1층
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        children: [
                                            SizedBox(width: SizeConfig.defaultSize * 0.5,),
                                          Text(
                                            userResponse.personalInfo?.nickname == 'DEFAULT'
                                                ? ('${userResponse.personalInfo?.name}' ?? '친구 이름')
                                                : (userResponse.personalInfo?.nickname ?? '친구 닉네임'),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeConfig.defaultSize * 1.6,
                                              color: Colors.black,
                                            ),),
                                            SizedBox(width: SizeConfig.defaultSize * 0.3),

                                          if (userResponse.personalInfo!.verification.isVerificationSuccess)
                                            Image.asset("assets/images/check.png", width: SizeConfig.defaultSize * 1.3),

                                            SizedBox(width: SizeConfig.defaultSize * 0.5),
                                          Text(
                                            "∙ ${userResponse.personalInfo?.birthYear.toString().substring(2,4)??"??"}년생",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: SizeConfig.defaultSize * 1.6,
                                              color: Colors.black,
                                            ),),
                                        ]
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_horiz_rounded, color: Colors.grey.shade300,),
                                      color: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      onSelected: (value) {
                                        // 팝업 메뉴에서 선택된 값 처리
                                        if (value == 'remove') {
                                          Navigator.pop(context, 'remove');
                                          state.deleteTeamMember(userResponse);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem<String>(
                                            value: 'remove',
                                            child: Text("삭제하기", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5)),
                                          ),
                                        ];
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row( // 2층
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                      SizedBox(width: SizeConfig.defaultSize * 0.5,),
                                    Container(
                                      width: SizeConfig.screenWidth * 0.56,
                                      child: Text(
                                        userResponse.university?.department ?? "??학부", // TODO : 학과 길면 ... 처리
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeConfig.defaultSize * 1.6,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // TODO : 받은 투표가 있다면 VoteView, 없으면 NoVoteView
              Container(
                height: SizeConfig.defaultSize * 11.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _VoteView(),
                    _NoVoteView(),
                    _NoVoteView(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _VoteView extends StatelessWidget { // 받은 투표 있을 때
  const _VoteView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.defaultSize * 3.5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xffFF5C58)
      ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("첫인상이 좋은", style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.defaultSize * 1.3
              ),),
              Text("5+",  style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.defaultSize * 1.3
              ),)
            ],
          ),
        )
    );
  }
}

class _NoVoteView extends StatelessWidget { // 받은 투표 없을 때
  const _NoVoteView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.defaultSize * 3.5,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text("내정보 탭에서 받은 투표를 프로필로 넣어보세요!", style: TextStyle(
        color: Color(0xffFF5C58),
        fontSize: SizeConfig.defaultSize * 1.3
      ),)
    );
  }
}

class _CreateTeamBottomSection extends StatefulWidget {
  MeetState state;
  String name;
  BuildContext ancestorContext;

  _CreateTeamBottomSection({
    super.key,
    required this.state,
    required this.name,
    required this.ancestorContext,
  });

  @override
  State<_CreateTeamBottomSection> createState() => _CreateTeamBottomSectionState();
}

class _CreateTeamBottomSectionState extends State<_CreateTeamBottomSection> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.defaultSize * 21,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: Color(0xffeeeeee),
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.defaultSize * 1.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 0.2),
                child: Row( // 만나고싶은지역 Row ********
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("만나고 싶은 지역", style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 1.6),),
                    TextButton(
                        onPressed: () {
                          List<Map<String, dynamic>> citiesData = [
                            {"id": 1, "name": "서울", "isChecked": false},
                            {"id": 2, "name": "대구", "isChecked": false},
                            {"id": 3, "name": "부산", "isChecked": false},
                            // {"id": 3, "name": "대구", "isChecked": false},
                            // {"id": 4, "name": "제주도", "isChecked": false},
                          ];
                          List<Map<String, dynamic>> newCitiesData = [];

                          showDialog<String>
                            (context: context,
                              builder: (BuildContext dialogContext) {
                                return StatefulBuilder(
                                  builder: (statefulContext, setState) =>
                                      AlertDialog(
                                        backgroundColor: Colors.white,
                                        surfaceTintColor: Colors.white,
                                        title: Text('',
                                          style: TextStyle(
                                              fontSize: SizeConfig.defaultSize *
                                                  2),
                                          textAlign: TextAlign.center,),
                                        content: Container(
                                          width: SizeConfig.screenWidth * 0.9,
                                          height: SizeConfig.screenHeight * 0.4,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('이성과 만나고 싶은 지역을 선택해주세요!',
                                                style: TextStyle(
                                                    fontSize: SizeConfig.defaultSize * 1.4),
                                                textAlign: TextAlign.start,),
                                              Flexible(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: citiesData.map((favorite) {
                                                      return CheckboxListTile(
                                                          activeColor: Color(0xffFE6059),
                                                          title: Text(favorite['name']),
                                                          value: favorite['isChecked'],
                                                          onChanged: (val) {
                                                            setState(() {
                                                              favorite['isChecked'] = val;
                                                            });
                                                            if (favorite['isChecked']) {
                                                              newCitiesData.add({'id': favorite['id'], 'name': favorite['name']});
                                                            } else {
                                                              newCitiesData.removeWhere((item) => item['id'] == favorite['id']);
                                                            }
                                                          }
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  dialogContext, '취소');
                                            },
                                            child: const Text('취소',
                                              style: TextStyle(
                                                  color: Colors.grey),),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                List<Location> newCities = newCitiesData.map((cityData) => Location(id: cityData["id"], name: cityData["name"])).toList();
                                                context.read<MeetCubit>().pressedCitiesAddButton(newCities);
                                                Navigator.pop(dialogContext);
                                              },
                                              child: Text('완료',
                                                  style: TextStyle(
                                                      color: Color(0xffFE6059)))
                                          ),
                                        ],
                                      ),
                                );
                              }
                          );
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero
                        ),
                        child: Text(
                          widget.state.getCities().isEmpty
                            ? "선택해주세요"
                            : widget.state.getCities().map((city) => city.name).join(', '),
                          style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.6,
                            color: Colors.grey.shade400),))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.defaultSize * 0.2),
                child: Row( // 학교 사람들에게 보이지 않기 Row ********
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("우리 학교 사람들에게 보이지 않기", style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 1.6),),
                    Switch(
                      value: light,
                      activeColor: Color(0xffFE6059),
                      activeTrackColor: Color(0xffFE6059).withOpacity(0.2),
                      inactiveTrackColor: Colors.grey.shade200,
                      onChanged: (bool value) {
                        setState(() {
                          light = value;
                          widget.state.setIsChecked(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize * 0.3,),
              GestureDetector(
                onTap: () {
                  // TODO : 위에꺼 다 선택해야 활성화되도록 만들기 (팀명 && 팀원 && 만나고 싶은 지역 추가)
                  MeetTeam myNewTeam = MeetTeam(id: 0, name: widget.state.teamName, university: widget.state.userResponse!.university, locations: widget.state.getCities(), canMatchWithSameUniversity: widget.state.isChecked, members: widget.state.teamMembers.toList());
                  if ((widget.state.isMemberOneAdded || widget.state.isMemberTwoAdded) && widget.state.teamName!='' && widget.state.getCities().isNotEmpty) {
                    context.read<MeetCubit>().createNewTeam(myNewTeam);
                    print("${widget.state.teamName} 이름 전달합니다");
                    print("${widget.state.userResponse!.university}");
                    print("${myNewTeam.toString()}");
                    Navigator.pop(widget.ancestorContext);
                  }
                },
                child: Container(
                  height: SizeConfig.defaultSize * 6,
                  width: SizeConfig.screenHeight,
                  decoration: BoxDecoration(
                    color:((widget.state.isMemberOneAdded || widget.state.isMemberTwoAdded) && widget.state.teamName!='' && widget.state.getCities().isNotEmpty)
                  ? Color(0xffFF5C58) : Color(0xffddddddd),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text("팀 만들기", style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.defaultSize * 2,
                      fontWeight: FontWeight.w600
                  )),
                ),
              )
            ],
          ),
        )
    );
  }
}