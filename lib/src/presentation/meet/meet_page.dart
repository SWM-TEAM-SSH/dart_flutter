import 'package:flutter/material.dart';
import '../../../res/size_config.dart';
import 'package:like_button/like_button.dart';

class MeetPage extends StatefulWidget {
  const MeetPage({super.key});

  @override
  State<MeetPage> createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage> {

  // 좋아요
  int likes = 0;
  void onLikeButtonPressed() {
    setState(() {
      likes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.defaultSize * 10,),
            Text("9월 OPEN",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.defaultSize * 4,
              ),),
            SizedBox(height: SizeConfig.defaultSize * 5,),

            LikeButton(
              size: SizeConfig.defaultSize * 18,
              // likeCount: likes, // TODO : MVP 이후 복구하기
              countPostion: CountPostion.bottom,
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.favorite,
                  color: isLiked ? Colors.pinkAccent : Colors.red,
                  size: SizeConfig.defaultSize * 17,
                );
              },
              // countBuilder: (int? count, bool isLiked, String text) { // TODO : MVP 이후 복구하기
              //   var color = isLiked ? Colors.red : Colors.grey;
              //   Widget result;
              //   if (count==0) {
              //     result = Text(
              //       'Like',
              //       style: TextStyle(color: color),
              //     );
              //   }
              //   else {
              //     result = Text(
              //       text,
              //       style: TextStyle(color: color),
              //     );
              //     return result;
              //   }
              //   return null;
              // },
              onTap: (isLiked) async {
                bool newStatus = await changedata(isLiked);
                if (newStatus) {
                  setState(() {
                    likes++;
                  });
                } else {
                  setState(() {
                    likes--;
                  });
                }
                return newStatus;
              },
            ),

            Text('얼른 열어주세요!',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.defaultSize * 1.9,
                height: SizeConfig.defaultSize * 0.25,
              ),),

            SizedBox(height: SizeConfig.defaultSize * 5,),
            Text("Dart에서 모은 투표를 프로필로 사용하는\n"
                "과팅이 시작될 예정이에요!\n"
                "친구들과의 재밌는 투표로 어필을 쌓아보세요!", // TODO : 포인트 얼마 써서 과팅할거라고 넣기
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.defaultSize * 1.9,
                height: SizeConfig.defaultSize * 0.25,
              ),),
          ],
        ),
      ),
    );
  }
}

Future<bool> changedata(status) async {
  //your code
  return Future.value(!status);
}