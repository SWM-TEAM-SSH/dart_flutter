import 'package:dart_flutter/src/domain/entity/blind_date_team_detail.dart';
import 'package:dart_flutter/src/presentation/component/meet_one_member_cardview_novote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../res/config/size_config.dart';
import '../../../common/util/toast_util.dart';
import '../../../domain/mapper/student_mapper.dart';
import '../viewmodel/meet_cubit.dart';
import '../viewmodel/state/meet_state.dart';

class MeetOtherTeamDetail extends StatelessWidget {
  int teamId;
  int myTeamId;

  MeetOtherTeamDetail({super.key, required this.teamId, required this.myTeamId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetCubit, MeetState>(
      builder: (context, state) {
        return FutureBuilder<BlindDateTeamDetail>(
          future: context.read<MeetCubit>().getBlindDateTeam(teamId),
          builder: (context, futureState) {
            if (futureState.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Color(0xffFE6059)),
                          SizedBox(height: SizeConfig.defaultSize * 5,),
                        Text("팀 정보를 불러오고 있어요 . . .", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),)
                      ],
                    ),
                ),
              );
            } else if (futureState.hasError) {
              return Text('Error: ${futureState.error}');
            } else if (futureState.hasData) {
              BlindDateTeamDetail blindDateTeamDetail = futureState.data!;

              return Scaffold(
                backgroundColor: Colors.grey.shade50,

                appBar: AppBar(
                  toolbarHeight: SizeConfig.defaultSize * 7,
                  automaticallyImplyLeading: false,
                  surfaceTintColor: Colors.white,
                  title: _TopBarSection(team: blindDateTeamDetail),
                ),

                body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.defaultSize * 1.5),
                      child: Column(
                        children: [
                          ...List.generate(blindDateTeamDetail.teamUsers.length, (index) {
                            return Column(
                              children: [
                                MeetOneMemberCardviewNoVote(userResponse:StudentMapper.toBlindDateUserDetail(blindDateTeamDetail.teamUsers[index]), university: blindDateTeamDetail.universityName,),
                                SizedBox(height: SizeConfig.defaultSize * 1.5),
                              ],
                            );
                          }),
                        ],
                      ),
                    )
                ),

                bottomNavigationBar: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.defaultSize * 12,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.defaultSize * 1.5),
                    child: Column(
                      children: [
                        // Container(
                        //   width: SizeConfig.screenWidth,
                        //   height: SizeConfig.defaultSize * 5.5,
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(10),
                        //       border: Border.all(
                        //           color: Colors.grey.shade200,
                        //           width: 2
                        //       )
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.only(left: SizeConfig.defaultSize * 2, right: SizeConfig.defaultSize * 1.5),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text("우리 팀 이름", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),),  // TODO : 팀 이름
                        //         Row(
                        //           children: [
                        //             Text("팀 바꾸기"),
                        //             Icon(Icons.expand_more_rounded, color: Colors.grey,)
                        //           ],
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: SizeConfig.defaultSize,),

                        state.proposalStatus == false || blindDateTeamDetail.proposalStatus == true
                          ? Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.defaultSize * 5.5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text("이미 채팅 요청을 보냈어요!", style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 2,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),)

                              // TODO : 포인트 제도 생겼을 때 위 Text 지우고 아래 복구
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text("2000", style: TextStyle(
                              //         decoration: TextDecoration.lineThrough,
                              //         fontSize: SizeConfig.defaultSize * 1.5,
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.white
                              //     ),),
                              //     Text(" 500 포인트로 대화 시작하기", style: TextStyle(
                              //         fontSize: SizeConfig.defaultSize * 2,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.white
                              //     ),),
                              //   ],
                              // ),
                            ),
                          )
                          : GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext modalContext) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  content: Container(
                                      width: SizeConfig.screenWidth * 0.9,
                                      height: SizeConfig.screenHeight * 0.15,
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: SizeConfig.defaultSize * 0.8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8, fontWeight: FontWeight.w500),
                                                        children: <TextSpan>[
                                                          const TextSpan(text: "지금 바로 ", style: TextStyle(color: Colors.black)),
                                                          TextSpan(text: "\'${blindDateTeamDetail.name}\'", style: const TextStyle(color: Color(0xffFF5C58), fontWeight: FontWeight.w600)),
                                                          const TextSpan(text: "에게", style: TextStyle(color: Colors.black)),
                                                        ]
                                                    )
                                                ),
                                                Text("호감을 보낼 수 있어요!", style: TextStyle(
                                                  fontSize: SizeConfig.defaultSize * 1.8,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("상대 팀이 내 호감을 수락하면", style: TextStyle(
                                                  fontSize: SizeConfig.defaultSize * 1.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),),
                                                Text("바로 채팅을 시작할 수 있어요!", style: TextStyle(
                                                  fontSize: SizeConfig.defaultSize * 1.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),),
                                              ],
                                            )

                                            // TODO : 포인트 제도 재개 시 복구하기
                                            // Column(
                                            //   children: [
                                            //     Text("팀원 중 신청하는 사람의 포인트가 소모돼요!", style: TextStyle(
                                            //       fontSize: SizeConfig.defaultSize * 1.5,
                                            //       fontWeight: FontWeight.w500,
                                            //       color: Colors.black,
                                            //     ),),
                                            //     Text("한 번 사용한 포인트는 되돌릴 수 없어요!", style: TextStyle(
                                            //       fontSize: SizeConfig.defaultSize * 1.5,
                                            //       fontWeight: FontWeight.w500,
                                            //       color: Colors.black,
                                            //     ),),
                                            //   ],
                                            // ),
                                            // Column(
                                            //   children: [
                                            //     Text("현재 내 포인트 : 00000 포인트", style: TextStyle(
                                            //       fontSize: SizeConfig.defaultSize * 1.5,
                                            //       fontWeight: FontWeight.w500,
                                            //       color: Colors.grey,
                                            //     ),),
                                            //     Text("현재 설정된 내 팀 : 아아아아아아아아 팀", style: TextStyle(
                                            //       fontSize: SizeConfig.defaultSize * 1.5,
                                            //       fontWeight: FontWeight.w500,
                                            //       color: Colors.grey,
                                            //     ),),
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      )),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(modalContext, false);
                                            },
                                            child: Container(
                                              height: SizeConfig.defaultSize * 4.5,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey.shade200,
                                              ),
                                              child: const Center(child: Text("취소")),
                                            ),
                                          ),
                                        ),
                                          SizedBox(width: SizeConfig.defaultSize,),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(modalContext, true);
                                            context.read<MeetCubit>().postProposal(myTeamId, blindDateTeamDetail.id);
                                            showDialog<String>(
                                                context: modalContext,
                                                builder: (BuildContext dialogContext) {
                                                  Future.delayed(const Duration(seconds: 2), () {
                                                    Navigator.pop(dialogContext);
                                                  });
                                                  return AlertDialog(
                                                    surfaceTintColor: Colors.white,
                                                    title: Container(alignment: Alignment.center, child: Text('내 호감이 성공적으로 전달됐어요!', style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5, fontWeight: FontWeight.w600, color: const Color(0xffFF5C58)),)),
                                                    content: Container(alignment: Alignment.center, height: SizeConfig.defaultSize * 4, child: const Text('곧 상대의 채팅 수락 결과를 알려드릴게요!',)),
                                                  );
                                                }
                                            );
                                          },
                                          child: Container(
                                            height: SizeConfig.defaultSize * 4.5,
                                            width: SizeConfig.defaultSize * 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: const Color(0xffFF5C58),
                                            ),
                                            child: const Center(child: Text("호감 보내기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)),
                                            // TODO : 포인트 재개하면 복구하기
                                            // child: Center(child: Text("500 포인트로 채팅 요청", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                          },
                          child: Container(
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.defaultSize * 5.5,
                            decoration: BoxDecoration(
                              color: const Color(0xffFE6059),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("호감 보내기", style: TextStyle(
                                fontSize: SizeConfig.defaultSize * 2,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                              ),)

                                // TODO : 포인트 제도 생겼을 때 위 Text 지우고 아래 복구
                                // child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Text("2000", style: TextStyle(
                                //         decoration: TextDecoration.lineThrough,
                                //         fontSize: SizeConfig.defaultSize * 1.5,
                                //         fontWeight: FontWeight.w400,
                                //         color: Colors.white
                                //     ),),
                                //     Text(" 500 포인트로 대화 시작하기", style: TextStyle(
                                //         fontSize: SizeConfig.defaultSize * 2,
                                //         fontWeight: FontWeight.w600,
                                //         color: Colors.white
                                //     ),),
                                //   ],
                                // ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.defaultSize * 2)
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Text("데이터 정보가 없습니다.");
            }
          }
        );
      }
    );
  }
}

class _TopBarSection extends StatelessWidget {
  BlindDateTeamDetail team;

  _TopBarSection({
    super.key,
    required this.team
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: SizeConfig.defaultSize * 2,),
                    padding: EdgeInsets.zero,
                  ),
                  Text(team.name, style: TextStyle(
                      fontSize: SizeConfig.defaultSize * 1.7,
                      fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("${(team.averageAge > 1000 ? 2023-team.averageAge+1 : team.averageAge).toStringAsFixed(1)}세", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.7),),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz_rounded, color: Colors.grey.shade300,),
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    onSelected: (value) {
                      if (value == 'report') {
                        // AnalyticsUtil.logEvent("내정보_마이_내친구더보기_신고");
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('팀을 신고하시겠어요?'),
                            content: const Text('팀을 신고하면 엔대생에서 빠르게 신고 처리를 해드려요!'),
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, '취소');
                                  // AnalyticsUtil.logEvent("내정보_마이_내친구신고_취소");
                                },
                                child: const Text('취소', style: TextStyle(color: Color(0xffFE6059)),),
                              ),
                              TextButton(
                                onPressed: () => {
                                  // AnalyticsUtil.logEvent("내정보_마이_내친구신고_신고확정"), // TODO : properties로 신고한 팀 넘기기
                                  Navigator.pop(context, '신고'),
                                  ToastUtil.showMeetToast("사용자가 신고되었어요!", 1),
                                  // TODO : 신고 기능 (서버 연결)
                                },
                                child: const Text('신고', style: TextStyle(color: Color(0xffFE6059)),),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Text("신고하기", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5)),
                        ),
                      ];
                    },
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(team.universityName, style: TextStyle(
                //   fontSize: SizeConfig.defaultSize * 1.7,),
                // ),
                // Text("       "),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(team.regions.map((location) => location.name).join(' '),
                      style: TextStyle(fontSize: SizeConfig.defaultSize * 1.7, color: Colors.grey, overflow: TextOverflow.ellipsis),),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.defaultSize * 1.5,)
        ],
      ),
    );
  }
}
