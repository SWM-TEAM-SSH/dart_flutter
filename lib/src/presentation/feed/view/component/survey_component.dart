import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:dart_flutter/src/common/util/toast_util.dart';
import 'package:dart_flutter/src/domain/entity/survey.dart';
import 'package:dart_flutter/src/presentation/feed/view/component/option_component.dart';
import 'package:dart_flutter/src/presentation/feed/view/component/option_notpicked_component.dart';
import 'package:dart_flutter/src/presentation/feed/view/survey_detail_view.dart';
import 'package:dart_flutter/src/presentation/feed/viewmodel/feed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:dart_flutter/res/config/size_config.dart';
import 'package:intl/intl.dart';

class SurveyComponent extends StatefulWidget {
  late Survey survey;
  late FeedCubit feedCubit;
  late bool isPicked;
  late int pickedOption;
  late double optionFirstPercent;
  late double optionSecondPercent;

  SurveyComponent({super.key, required this.survey, required this.feedCubit}) {
    isPicked = survey.isPicked();
    pickedOption = survey.pickedOption;
    optionFirstPercent = survey.options.first.headCount / (survey.options.first.headCount + survey.options.last.headCount);
    optionSecondPercent = survey.options.last.headCount / (survey.options.first.headCount + survey.options.last.headCount);
  }

  @override
  State<SurveyComponent> createState() => _SurveyComponentState();
}

class _SurveyComponentState extends State<SurveyComponent> {
  Color mainColor = const Color(0xffFE6059);
  Color commentColor = const Color(0xffFFFAF9);
  double marginHorizontal = SizeConfig.defaultSize * 2.3;
  bool isChanged = false;
  bool isTapped = false;

  void onPickedChanged(bool changed, int pickedOption) async {
    AnalyticsUtil.logEvent('피드_선택지_선택', properties: {
      '질문 id': widget.survey.id,
      '질문 내용': widget.survey.question,
      '옵션 id': pickedOption
    });

    setState(() {
      widget.isPicked = changed;
      widget.pickedOption = pickedOption;
      isChanged = true;
      if (widget.survey.options.first.id == pickedOption) {
        widget.optionFirstPercent = (widget.survey.options.first.headCount + 1) / (widget.survey.options.first.headCount + widget.survey.options.last.headCount + 1);
        widget.optionSecondPercent = (widget.survey.options.last.headCount) / (widget.survey.options.first.headCount + widget.survey.options.last.headCount + 1);
      } else {
        widget.optionFirstPercent = (widget.survey.options.first.headCount) / (widget.survey.options.first.headCount + widget.survey.options.last.headCount + 1);
        widget.optionSecondPercent = (widget.survey.options.last.headCount + 1) / (widget.survey.options.first.headCount + widget.survey.options.last.headCount + 1);
      }
    });

    try {
      await widget.feedCubit.postOption(widget.survey.id, widget.pickedOption);
    } catch (error) {
      setState(() {
        widget.isPicked = false;
        widget.optionFirstPercent = widget.survey.options.first.headCount / (widget.survey.options.first.headCount + widget.survey.options.last.headCount);
        widget.optionSecondPercent = widget.survey.options.last.headCount / (widget.survey.options.first.headCount + widget.survey.options.last.headCount);
      });
      ToastUtil.showMeetToast('내 투표 결과 전송에 실패했어요🥺\n투표에 다시 참여해주세요!', 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedSurveyDate = DateFormat('MM월 dd일').format(widget.survey.createdAt);
    String formattedNowDate = DateFormat('MM월 dd일').format(now);

    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.defaultSize * 30,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1.6
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
            child: Column(
              children: [
                  SizedBox(height: SizeConfig.defaultSize * 2,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: mainColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize,
                                  vertical: SizeConfig.defaultSize * 0.4),
                              child: Text(formattedSurveyDate, style: TextStyle(
                                  color: mainColor,
                                  fontSize: SizeConfig.defaultSize * 1.4)),
                            )
                        ),
                        if (formattedNowDate == formattedSurveyDate) Text("오늘의 질문", style: TextStyle(fontSize: SizeConfig.defaultSize * 1.4, color: Colors.grey),)
                      ],
                    ),
                      SizedBox(height: SizeConfig.defaultSize * 1.5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(' ${widget.survey.question}', style: TextStyle(fontSize: SizeConfig.defaultSize * 1.6, fontWeight: FontWeight.w600),),
                      ],
                    ),
                      SizedBox(height: SizeConfig.defaultSize * 2,),
                    widget.isPicked
                        ? OptionComponent(isPicked: widget.pickedOption == widget.survey.options.first.id, option: widget.survey.options.first, percent: widget.optionFirstPercent, isMost: widget.optionFirstPercent>widget.optionSecondPercent, isChanged: isChanged)
                        : OptionNotPickedComponent(option: widget.survey.options.first, onPickedChanged: onPickedChanged),
                      SizedBox(height: SizeConfig.defaultSize),
                    widget.isPicked
                        ? OptionComponent(isPicked: widget.pickedOption == widget.survey.options.last.id, option: widget.survey.options.last, percent: widget.optionSecondPercent, isMost: widget.optionFirstPercent<widget.optionSecondPercent, isChanged: isChanged)
                        : OptionNotPickedComponent(option: widget.survey.options.last, onPickedChanged: onPickedChanged)
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async {
              AnalyticsUtil.logEvent('ㅈ', properties: {
                '질문 id': widget.survey.id,
                '질문 내용': widget.survey.question
              });

              if (!widget.isPicked) {
                ToastUtil.showMeetToast('선택지 중 하나를 선택해야\n댓글과 비율을 볼 수 있어요!', 2);
              } else {
                if (isTapped) {
                  return;
                }
                setState(() {
                  isTapped = true;
                });
                ToastUtil.showMeetToast('실시간 댓글 접속중입니다 . . .', 2);

                await widget.feedCubit.getSurveyDetail(widget.survey.id).then((_) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyDetailView(surveyDetail: widget.feedCubit.state.surveyDetail, feedCubit: widget.feedCubit,)));
                });

                setState(() {
                  isTapped = false;
                });
              }
            },
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.defaultSize * 6.5,
              color: commentColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('실시간 댓글', style: TextStyle(color: mainColor, fontSize: SizeConfig.defaultSize * 1.3),),
                        Icon(Icons.arrow_forward_ios_rounded, size: SizeConfig.defaultSize * 1.3, color: mainColor,)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 0.5),
                      child: Text(widget.survey.latestComment, style: TextStyle(fontSize: SizeConfig.defaultSize * 1.3), overflow: TextOverflow.ellipsis,),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
