import 'package:flutter/material.dart';
import 'package:dart_flutter/res/size_config.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.defaultSize * 2,
              horizontal: SizeConfig.defaultSize),
          child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.defaultSize * 0.5,),
                Container(
                  height: SizeConfig.defaultSize * 13,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.defaultSize,
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("가톨릭대학교 컴퓨터정보공학부",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: SizeConfig.defaultSize * 1.3,
                                ),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                Text("장세연",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.defaultSize * 2,
                                  ),),
                                Text("  21학번",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.defaultSize * 1.6,
                                  ),),
                                ],
                              ),
                              Icon(
                                Icons.settings,
                                size: 20.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              color: Color(0xffeeeeeee),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("   나의 Points",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.defaultSize * 1.6,
                                      ),),
                                    Text("  280",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.defaultSize * 1.6,
                                      ),),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // 사용 내역 페이지로 연결
                                  },
                                  child: Text("사용 내역 ", style: TextStyle(
                                      fontSize: SizeConfig.defaultSize * 1.6,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),

                // =================================================================

                Container( // 구분선
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0,),
                  height: SizeConfig.defaultSize * 2,
                  color: Colors.grey.withOpacity(0.1),
                ),

                SizedBox(height: SizeConfig.defaultSize * 0.5,),
                Container(
                  // height: SizeConfig.defaultSize * 130,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.defaultSize,
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("내 친구",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.defaultSize * 1.6,
                                ),),
                              ElevatedButton(
                                onPressed: () {
                                  // 초대하기 페이지로 연결
                                },
                                child: Text("초대하기", style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.6,
                                  fontWeight: FontWeight.w500,
                                )),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.defaultSize ,),

                          // ================================ 친구 리스트
                          for (int i = 0; i <5; i++) // TODO : 친구의 수만큼 반복시키기
                           Column(
                             children: [
                               SizedBox(height: SizeConfig.defaultSize * 0.1,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     children: [
                                       Text("이이름", style: TextStyle(
                                        fontSize: SizeConfig.defaultSize * 1.9,
                                        fontWeight: FontWeight.w600,
                                        )),
                                       Text("  21학번∙컴퓨터정보공학부", style: TextStyle(
                                         fontSize: SizeConfig.defaultSize * 1.3,
                                         fontWeight: FontWeight.w500,
                                       )),
                                     ],
                                   ),
                                   SizedBox(height: SizeConfig.defaultSize,),

                                   TextButton(
                                     onPressed: () {
                                       // TODO : 신고 기능
                                     },
                                     child: Text("신고하기", style: TextStyle(
                                       fontSize: SizeConfig.defaultSize * 1.3,
                                       fontWeight: FontWeight.w500,
                                       decoration: TextDecoration.underline,
                                       color: Colors.grey,
                                     )),
                                   ),

                                   ElevatedButton(
                                     onPressed: () {
                                       // TODO : 친구 삭제 기능
                                     },
                                     child: Text("삭제", style: TextStyle(
                                       fontSize: SizeConfig.defaultSize * 1.4,
                                       fontWeight: FontWeight.w500,
                                     )),
                                   ),
                                 ],
                               ),
                               SizedBox(height: SizeConfig.defaultSize * 0.1,),
                               Divider(
                                 color: Color(0xffddddddd),
                               ),
                             ],
                           ),
                        ],
                      )
                  ),
                ),

                // =================================================================

                Container( // 구분선
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0,),
                  height: SizeConfig.defaultSize * 2,
                  color: Colors.grey.withOpacity(0.1),
                ),

                SizedBox(height: SizeConfig.defaultSize * 2,),
                Container(
                  // height: SizeConfig.defaultSize * 130,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.defaultSize,
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("알 수도 있는 친구",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.defaultSize * 1.6,
                                ),),
                            ],
                          ),
                          SizedBox(height: SizeConfig.defaultSize * 2 ,),

                          // ================================ 친구 리스트
                          for (int i = 0; i <5; i++) // TODO : 친구의 수만큼 반복시키기
                            Column(
                              children: [
                                SizedBox(height: SizeConfig.defaultSize * 0.1,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("이이름", style: TextStyle(
                                          fontSize: SizeConfig.defaultSize * 1.9,
                                          fontWeight: FontWeight.w600,
                                        )),
                                        Text("  21학번∙컴퓨터정보공학부", style: TextStyle(
                                          fontSize: SizeConfig.defaultSize * 1.3,
                                          fontWeight: FontWeight.w500,
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: SizeConfig.defaultSize,),

                                    TextButton(
                                      onPressed: () {
                                        // TODO : 신고 기능
                                      },
                                      child: Text("신고하기", style: TextStyle(
                                        fontSize: SizeConfig.defaultSize * 1.3,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        color: Colors.grey,
                                      )),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO : 친구 삭제 기능
                                      },
                                      child: Text("추가", style: TextStyle(
                                        fontSize: SizeConfig.defaultSize * 1.4,
                                        fontWeight: FontWeight.w500,
                                      )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.defaultSize * 0.1,),
                                Divider(
                                  color: Color(0xffddddddd),
                                ),
                              ],
                            ),
                        ],
                      )
                  ),
                ),

              ],
          ),
        ),
      ),
    );
  }
}
