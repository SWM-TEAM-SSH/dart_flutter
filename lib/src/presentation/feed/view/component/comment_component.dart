import 'package:dart_flutter/res/config/size_config.dart';
import 'package:dart_flutter/src/common/util/toast_util.dart';
import 'package:dart_flutter/src/presentation/feed/viewmodel/feed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:dart_flutter/src/domain/entity/comment.dart';
import 'package:intl/intl.dart';

import '../../../../common/util/analytics_util.dart';

class CommentComponent extends StatefulWidget {
  late int surveyId;
  late Comment comment;
  late FeedCubit feedCubit;
  late Function() refreshComment;

  CommentComponent({super.key, required this.surveyId, required this.comment, required this.feedCubit, required this.refreshComment});

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  late int commentId;
  late int userId;
  late bool liked;
  late int likes;
  late String universityName;
  late String nickname;
  late String createdAt;
  late String content;

  @override
  void initState() {
    super.initState();
    setState(() {
      commentId = widget.comment.id;
      liked = widget.comment.liked;
      likes = widget.comment.likes;
      universityName = widget.comment.writer.university?.name ?? "XX대학교";
      nickname = widget.comment.writer.personalInfo?.id == null
          ? "∙ 익명"
          : "∙ 익명 ${widget.comment.writer.personalInfo!.id.toString()[widget.comment.writer.personalInfo!.id.toString().length - 1]}***";
      createdAt = DateFormat('MM/dd HH:mm').format(widget.comment.createdAt);
      content = widget.comment.content;
      userId = widget.comment.writer.personalInfo?.id ?? 0;
    });
    print("new $commentId");
  }

  @override
  void didUpdateWidget(CommentComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 여기서는 오래된 위젯의 정보와 새 위젯의 정보를 비교하여
    // 필요한 경우 상태를 업데이트합니다.
    if (widget.comment != oldWidget.comment) {
      // 코멘트가 변경된 경우 상태를 업데이트합니다.
      setState(() {
        commentId = widget.comment.id;
        liked = widget.comment.liked;
        likes = widget.comment.likes;
        universityName = widget.comment.writer.university?.name ?? "XX대학교";
        nickname = widget.comment.writer.personalInfo?.id == null
            ? "∙ 익명"
            : "∙ 익명 ${widget.comment.writer.personalInfo!.id.toString()[widget.comment.writer.personalInfo!.id.toString().length - 1]}***";
        createdAt = DateFormat('MM/dd HH:mm').format(widget.comment.createdAt);
        content = widget.comment.content;
        userId = widget.comment.writer.personalInfo?.id ?? 0;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("$commentId $content}");
  }

  void pressedLikeButton() {
    if (liked) {
      return;
    }
    setState(() {
      liked = !liked;
      likes++;
    });

    try {
      AnalyticsUtil.logEvent('피드_오늘의질문_댓글_좋아요_터치', properties: {
        '질문 id': widget.surveyId,
        '댓글 id': commentId
      });
      widget.feedCubit.postLikeComment(widget.surveyId, commentId);
    } catch (e, trace) {
      // 좋아요 요청 실패시 원상복구
      setState(() {
        liked = !liked;
        likes--;
      });
    }
  }

  void pressedDeleteButton() {
    AnalyticsUtil.logEvent('피드_오늘의질문_댓글_더보기_삭제하기_터치', properties: {
      '질문 id': widget.surveyId,
      '댓글 내용': content,
      '댓글 id': commentId
    });

    showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('댓글을 삭제하시겠어요?', style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8), textAlign: TextAlign.center,),
        content: const Text("삭제시에 복구할 수 없어요!"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              AnalyticsUtil.logEvent('피드_오늘의질문_댓글_더보기_삭제하기_취소', properties: {
                '질문 id': widget.surveyId,
                '댓글 내용': content,
                '댓글 id': commentId
              });
              Navigator.pop(dialogContext, '취소');
            },
            child: const Text('취소', style: TextStyle(color: Color(0xffFF5C58)),),
          ),
          TextButton(
            onPressed: () async {
              AnalyticsUtil.logEvent('피드_오늘의질문_댓글_더보기_삭제하기_삭제확정', properties: {
                '질문 id': widget.surveyId,
                '댓글 내용': content,
                '댓글 id': commentId
              });
              Navigator.pop(dialogContext);
              await widget.feedCubit.deleteComment(widget.surveyId, commentId);
              widget.refreshComment();
            },
            child: const Text('삭제', style: TextStyle(color: Color(0xffFF5C58)),),
          ),
        ],
      ),
    );
  }

  void pressedReportButton() {
    AnalyticsUtil.logEvent('피드_오늘의질문_댓글_더보기_신고하기_터치', properties: {
      '질문 id': widget.surveyId,
      '댓글 내용': content,
      '댓글 id': commentId
    });
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('사용자를 신고하시겠어요?'),
        content: const Text('엔대생에서 빠르게 신고 처리를 해드려요!'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, '취소');
              AnalyticsUtil.logEvent('피드_오늘의질문_댓글_더보기_신고하기_취소', properties: {
                '질문 id': widget.surveyId,
                '댓글 내용': content,
                '댓글 id': commentId
              });
            },
            child: const Text('취소', style: TextStyle(color: Color(0xffFE6059)),),
          ),
          TextButton(
            onPressed: () => {
              AnalyticsUtil.logEvent('피드_오늘의질문_댓글_더보기_신고하기_신고확정', properties: {
                '질문 id': widget.surveyId,
                '댓글 내용': content,
                '댓글 id': commentId
              }),
              widget.feedCubit.reportComment(widget.surveyId, commentId),
              Navigator.pop(context, '신고'),
              ToastUtil.showMeetToast("사용자가 신고되었어요!", 1),
            },
            child: const Text('신고', style: TextStyle(color: Color(0xffFE6059)),),
          ),
        ],
      ),
    );


  }

  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.blue, width: 100, height: 100,);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("$universityName ", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5, fontWeight: FontWeight.w600)),
                Text(nickname, style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5, fontWeight: FontWeight.w600)),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: pressedLikeButton,
                  icon: Icon(
                    Icons.thumb_up_alt_outlined,
                    size: SizeConfig.defaultSize * 1.5,
                    color: liked ? Colors.red : Colors.grey,
                  ),
                ),

                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz_rounded, size: SizeConfig.defaultSize * 1.5, color: Colors.grey,),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    // 팝업 메뉴에서 선택된 값 처리
                    if (value == 'remove') {
                      pressedDeleteButton();
                    }
                    if (value == 'report') {
                      pressedReportButton();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      widget.feedCubit.state.userResponse.personalInfo?.id == userId
                        ? PopupMenuItem<String>(
                          value: 'remove',
                          child: Text("삭제하기", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5)),
                        )
                        : PopupMenuItem<String>(
                          value: 'report',
                          child: Text("신고하기", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5)),
                        )
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
        Container(height: SizeConfig.defaultSize * 1,),

        Text(content, style: TextStyle(fontSize: SizeConfig.defaultSize * 1.5)),
        Container(height: SizeConfig.defaultSize * 1,),

        Row(
          children: [
            Text('$createdAt   ', style: TextStyle(color: Colors.grey, fontSize: SizeConfig.defaultSize * 1.2),),
            Icon(Icons.thumb_up_alt_outlined, size: SizeConfig.defaultSize * 1.2, color: Colors.red,),
            Text(" $likes", style: TextStyle(color: Colors.red, fontSize: SizeConfig.defaultSize * 1.2),),
          ],
        )
      ],
    );
  }
}
