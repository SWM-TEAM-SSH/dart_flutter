import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_flutter/src/common/util/analytics_util.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:dart_flutter/src/domain/entity/survey.dart';
import 'package:dart_flutter/src/domain/entity/survey_detail.dart';
import 'package:dart_flutter/src/domain/entity/user.dart';
import 'package:dart_flutter/src/domain/use_case/user_use_case.dart';
import 'package:dart_flutter/src/domain/use_case/feed_use_case.dart';
import 'package:dart_flutter/src/presentation/feed/viewmodel/state/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState.init());
  static final FeedUseCase _feedUseCase = FeedUseCase();
  static final UserUseCase _userUseCase = UserUseCase();

  // pagination
  static const int _numberOfPostsPerRequest = 10;
  final PagingController<int, Survey> pagingController = PagingController(firstPageKey: 0);

  void initFeed() async {
    state.setIsLoading(true);
    emit(state.copy());

    User userResponse = await _userUseCase.myInfo();
    state.setMyInfo(userResponse);

    state.setIsLoading(false);
    emit(state.copy());
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final surveys = (await _feedUseCase.getSurveys(page: pageKey, size: _numberOfPostsPerRequest)).content ?? [];
      final isLastPage = surveys.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        pagingController.appendLastPage(surveys);
      } else {
        final nextPageKey = pageKey + 1;
        AnalyticsUtil.logEvent('피드_게시글 불러오기(페이지네이션)', properties: {
          '새로 불러온 페이지 인덱스': nextPageKey
        });
        pagingController.appendPage(surveys, nextPageKey);
      }
    } catch (error) {
      print('[PAGINATION ERROR] $error');
      pagingController.error = error;
    }
  }

  Future<void> getSurveyDetail(int id) async {
    SurveyDetail survey = await _feedUseCase.getSurvey(id);
    state.setSurvey(survey);
    emit(state.copy());
  }

  Future<void> postOption(int surveyId, int optionId) async {
    await _feedUseCase.postOption(surveyId, optionId);
  }

  Future<void> postComment(int surveyId, String content) async {
    await _feedUseCase.postComment(surveyId, content);
    await getSurveyDetail(surveyId);
  }

  Future<void> deleteComment(int surveyId, int commentId) async {
    await _feedUseCase.deleteComment(surveyId, commentId);
    await getSurveyDetail(surveyId);
  }

  void reportComment(int surveyId, int commentId) {
    _feedUseCase.reportComment(surveyId, commentId);
  }

  Future<void> postLikeComment(int surveyId, int commentId) async {
    await _feedUseCase.postLikeComment(surveyId, commentId);
    await getSurveyDetail(surveyId);
  }
}