import 'package:dart_flutter/src/domain/entity/question.dart';
import 'package:dart_flutter/src/domain/entity/user.dart';
import 'package:dart_flutter/src/domain/entity/vote_request.dart';
import 'package:dart_flutter/src/domain/use_case/friend_use_case.dart';
import 'package:dart_flutter/src/domain/use_case/user_use_case.dart';
import 'package:dart_flutter/src/domain/use_case/guest_use_case.dart';
import 'package:dart_flutter/src/domain/use_case/vote_use_case.dart';
import 'package:dart_flutter/src/presentation/vote/vimemodel/state/vote_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class VoteCubit extends HydratedCubit<VoteState> {
  static final FriendUseCase _friendUseCase = FriendUseCase();
  static final VoteUseCase _voteUseCase = VoteUseCase();
  static final UserUseCase _userUseCase = UserUseCase();
  static final GuestUseCase _guestUseCase = GuestUseCase();

  // VoteCubit() : super(VoteState.init());
  VoteCubit()
      : super(VoteState(
            isLoading: false,
            step: VoteStep.start,
            voteIterator: 0,
            votes: [],
            questions: [],
            nextVoteDateTime: DateTime.now(),
            friends: [],
            userResponse: User(titleVotes: []),
            newFriends: {},
            contacts: []));

  void initVotes() async {
    state.setIsLoading(true);
    emit(state.copy());

    // 친구 목록 설정
    List<User> friends = await _friendUseCase.getMyFriends();
    state.setFriends(friends);

    if (!state.step.isProcess) {
      // 투표중이지 않았던 경우, 다음 투표 가능 시간을 기록하고, 다음 스텝 지정
      await getNextVoteTime();
      _setStepByNextVoteTime();
      print("dhjksjhksdkhjskjhsdkjhsdkhjsdkjsdkjsdkjs");
    } else {
      print("dddjksjsldfksdljksdfjlksldjfjlskdjlsfkd");
    }

    state.setIsLoading(false);
    emit(state.copy());
  }

  void exitStandby() async {
    List<User> friends = await _friendUseCase.getMyFriends();
    state.setFriends(friends);

    if (friends.length >= 4) {
      state.setStep(VoteStep.start);
    }

    emit(state.copy());
  }

  void refresh() {
    emit(state.copy());
  }

  void stepStart() async {
    // 투표 가능한지 확인
    _setStepByNextVoteTime();

    if (state.step.isStart) {
      // 친구 목록 설정
      List<User> friends = await _friendUseCase.getMyFriends();
      state.setFriends(friends);

      // 새로 투표할 목록들을 가져오기
      List<Question> questions = await _voteUseCase.getNewQuestions();
      state.setQuestions(questions);

      // 투표 화면으로 전환
      state.setStep(VoteStep.process);
    }

    emit(state.copy());
  }

  void nextVoteWithContact() async {
    state.setIsLoading(true);
    emit(state.copy());

    state.nextVote();
    if (state.isVoteDone()) {
      DateTime myNextVoteTime = await _voteUseCase.setNextVoteTime();
      state.setNextVoteDateTime(myNextVoteTime);
    }

    state.setIsLoading(false);
    emit(state.copy());
  }

  void nextVote(VoteRequest voteRequest) async {
    print(voteRequest.toString());

    state.setIsLoading(true);
    emit(state.copy());
    print(state.toString());

    state.pickUserInVote(voteRequest);
    _voteUseCase.sendMyVote(voteRequest); // 투표한 내용을 서버로 전달
    state.nextVote();
    if (state.isVoteDone()) {
      // 투표 리스트 비우기 + 다음투표가능시간 갱신 + (포인트는 My page에서 값 받아오면 알아서 갱신되어있음)
      DateTime myNextVoteTime = await _voteUseCase.setNextVoteTime();
      state.setNextVoteDateTime(myNextVoteTime);
    }

    state.setIsLoading(false);
    emit(state.copy());
    print(state.toString());
  }

  void stepDone() {
    state.setStep(VoteStep.wait);
    emit(state.copy());
  }

  void stepWait() {
    getNextVoteTime();
    _setStepByNextVoteTime();

    print(state.toString());
    emit(state.copy());
  }

  Future<DateTime> getNextVoteTime() async {
    DateTime myNextVoteTime = await _voteUseCase.getNextVoteTime();
    print("===============");
    print(myNextVoteTime);

    state.setNextVoteDateTime(myNextVoteTime);
    return myNextVoteTime;
  }

  void inviteFriend() {
    bool isInvited = true;
    if (isInvited) {
      // 정상적으로 카톡 공유하기를 전송한 경우
      state.setNextVoteDateTime(DateTime.now()).setStep(VoteStep.start);
    }

    emit(state.copy());
  }

  void _setStepByNextVoteTime() {
    if (isVoteTimeOver()) {
      state.setStep(VoteStep.start);
    } else {
      state.setStep(VoteStep.wait);
    }
  }

  bool isVoteTimeOver() {
    return state.isVoteTimeOver();
  }

  // 친구추가
  void initUser() async {
    // 타이머페이지 init
    User userResponse = await _userUseCase.myInfo();
    state.setMyInfo(userResponse);
    List<User> newFriends = await _friendUseCase.getRecommendedFriends();
    state.setRecommendedFriends(newFriends);
  }

  Future<void> pressedFriendAddButton(User friend) async {
    state.isLoading = true;
    emit(state.copy());

    try {
      await _friendUseCase.addFriend(friend);
      state.addFriend(friend);
      state.setRecommendedFriends(await _friendUseCase.getRecommendedFriends(put: true));
    } catch (e, trace) {
      print("친구추가 실패! $e $trace");
      throw Error();
    } finally {
      state.isLoading = false;
      emit(state.copy());
    }
  }

  Future<void> pressedFriendCodeAddButton(String inviteCode) async {
    state.isLoading = true;
    emit(state.copy());

    try {
      User friend = await _friendUseCase.addFriendBy(inviteCode);
      state.addFriend(friend);
      state.setRecommendedFriends(await _friendUseCase.getRecommendedFriends(put: true));
    } catch (e, trace) {
      print("친구추가 실패! $e $trace");
      throw Error();
    } finally {
      state.isLoading = false;
      emit(state.copy());
    }
  }

  void inviteGuest(String name, String phoneNumber, String questionContent) {
    _guestUseCase.inviteGuest(name, phoneNumber, questionContent);
  }

  @override
  VoteState fromJson(Map<String, dynamic> json) {
    return state.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(VoteState state) {
    return state.toJson();
  }
}
