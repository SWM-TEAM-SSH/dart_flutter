import 'dart:io';
import 'package:dart_flutter/src/domain/entity/location.dart';
import 'package:dart_flutter/src/domain/entity/meet_team.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dart_flutter/src/domain/entity/user.dart';
import '../../../../domain/entity/blind_date_team.dart';
import '../../../../domain/entity/university.dart';

@JsonSerializable()
class MeetState {
  late MeetStateEnum meetPageState;
  late List<Location> serverLocations;
  late User userResponse;
  // meet - createTeam
  late bool isLoading;
  late bool isMemberOneAdded;
  late bool isMemberTwoAdded;
  late Set<User> friends;
  late List<User> filteredFriends;
  late Set<User> teamMembers;
  late Set<Location> cities;
  late List<MeetTeam> myTeams;

  late MeetTeam? myTeam; // todo : change to not lazy init
  late String teamName;
  late bool isChecked;
  late int teamCount;
  // meet - 친구 추가
  late Set<User> newFriends;
  // meet - blindDate
  late List<BlindDateTeam> blindDateTeams;
  late int nowTeamId;
  late bool pickedTeam;
  late bool proposalStatus;
  // meet - createTeamInput
  late List<University> universities;
  late File profileImageFile;

  late int leftProposalCount;

  @Deprecated("애드몹 제거로 인해 사용하지 않음")
  late DateTime lastAdmobTime;

  void setLastAdmobTime(DateTime dateTime) {
    lastAdmobTime = dateTime;
  }

  MeetState ({
    required this.meetPageState,
    required this.serverLocations,
    required this.userResponse,
    required this.isLoading,
    required this.isMemberOneAdded,
    required this.isMemberTwoAdded,
    required this.friends,
    required this.filteredFriends,
    required this.teamMembers,
    required this.cities,
    required this.myTeams,
    required this.myTeam,
    required this.teamName,
    required this.isChecked,
    required this.teamCount,
    required this.newFriends,
    required this.blindDateTeams,
    required this.nowTeamId,
    required this.pickedTeam,
    required this.proposalStatus,
    required this.universities,
    required this.profileImageFile,
    required this.leftProposalCount,
    required this.lastAdmobTime,
  });

  MeetState.init() { // 초기값 설정
    meetPageState = MeetStateEnum.landing;
    serverLocations = [];
    userResponse = User(
      personalInfo: null,
      university: null,
      titleVotes: [],
    );
    isLoading = false;
    isMemberOneAdded = false;
    isMemberTwoAdded = false;
    friends = {};
    filteredFriends = [];
    teamMembers = {};
    cities = {};
    myTeams = [];
    myTeam = null;
    teamName = '';
    isChecked = false;
    teamCount = 0;
    newFriends = {};
    blindDateTeams = [];
    nowTeamId = 0;
    pickedTeam = false;
    proposalStatus = true;
    universities = [
      University(id: 0, name: '', department: '')
    ];
    profileImageFile = File('');
    leftProposalCount = 0;
    lastAdmobTime = DateTime.now();
  }

  MeetState copy() => MeetState(
    meetPageState: meetPageState,
    serverLocations: serverLocations,
    userResponse: userResponse,
    isLoading: isLoading,
    isMemberOneAdded: isMemberOneAdded,
    isMemberTwoAdded: isMemberTwoAdded,
    friends: friends,
    filteredFriends: filteredFriends,
    teamMembers: teamMembers,
    cities: cities,
    myTeam: myTeam,
    myTeams: myTeams,
    teamName: teamName,
    isChecked: isChecked,
    teamCount: teamCount,
    newFriends: newFriends,
    blindDateTeams: blindDateTeams,
    nowTeamId: nowTeamId,
    pickedTeam: pickedTeam,
    proposalStatus: proposalStatus,
    universities: universities,
    profileImageFile: profileImageFile,
    leftProposalCount: leftProposalCount,
    lastAdmobTime: lastAdmobTime,
  );

  void setAll(MeetState state) {
      meetPageState = state.meetPageState;
      serverLocations = state.serverLocations;
      userResponse = state.userResponse;
      isLoading = state.isLoading;
      isMemberOneAdded = state.isMemberOneAdded;
      isMemberTwoAdded = state.isMemberTwoAdded;
      friends = state.friends;
      filteredFriends = state.filteredFriends;
      teamMembers = state.teamMembers;
      cities = state.cities;
      myTeams = state.myTeams;
      teamName = state.teamName;
      isChecked = state.isChecked;
      teamCount = state.teamCount;
      newFriends = state.newFriends;
      blindDateTeams = state.blindDateTeams;
      nowTeamId = state.nowTeamId;
      pickedTeam = state.pickedTeam;
      proposalStatus = state.proposalStatus;
      universities = state.universities;
      profileImageFile = state.profileImageFile;
      leftProposalCount = state.leftProposalCount;
      lastAdmobTime = state.lastAdmobTime;
  }

  MeetState setProposalStatus(bool proposalStatus) {
    this.proposalStatus = proposalStatus;
    return this;
  }

  void setPickedTeam(bool pickedTeam) {
    this.pickedTeam = pickedTeam;
  }

  void addFriend(User friend) {
    friends.add(friend);
    newFriends.remove(friend);
  }

  MeetState setRecommendedFriends(List<User> friends) {
    newFriends = friends.toSet();
    return this;
  }

  void setServerLocations(List<Location> serverLocations) {
    this.serverLocations = serverLocations;
  }

  void setTeamCount(int teamCount) {
    this.teamCount = teamCount;
  }

  void addTeamCount() {
    teamCount += 1;
  }

  void minusTeamCount() {
    teamCount -= 1;
  }

  void setIsLoading(bool isLoading) {
    this.isLoading = isLoading;
  }

  void setIsChecked(bool isChecked) {
    this.isChecked = isChecked;
  }

  // 추가된 친구가 한 명인지 판단
  void setIsMemberOneAdded(bool isMemberOneAdded) {
    this.isMemberOneAdded = isMemberOneAdded;
  }

  // 추가된 친구가 두 명인지 판단
  void setIsMemberTwoAdded(bool isMemberTwoAdded) {
    this.isMemberTwoAdded = isMemberTwoAdded;
  }

  MeetState setMyInfo(User userResponse) {
    this.userResponse = userResponse;
    return this;
  }

  MeetState setMyFriends(List<User> friends) {
    this.friends = friends.toSet();
    return this;
  }

  MeetState setMyFilteredFriends(List<User> filteredFriends) {
    this.filteredFriends = filteredFriends;
    return this;
  }

  MeetState addMyTeam(MeetTeam team) {
    myTeams.add(team);
    return this;
  }

  MeetState removeMyTeamById(String teamId) {
    myTeams.removeWhere((element) => element.id == teamId);
    return this;
  }

  void setMyTeam(MeetTeam team) {
    myTeam = team;
  }

  MeetTeam? getMyTeam() {
    return myTeam;
  }

  MeetState setTeamMembers(List<User> filteredFriends) {
    teamMembers = filteredFriends.toSet();
    return this;
  }

  List<MeetTeam> setMyTeams(List<MeetTeam> myTeams) {
    this.myTeams = myTeams;
    return this.myTeams;
  }

  List<Location> getCities() {
    List<Location> newCities = cities.toList();
    return newCities;
  }

  MeetState setCities(List<Location> cities) {
    this.cities = cities.toSet();
    return this;
  }

  void addTeamMember(User friend) {
    teamMembers.add(friend);
    print("state - friend 추가 {$friend}");
    print("state - 팀 멤버에는 친구 추가 $teamMembers");
    print("state - 필터링 친구에는 친구 삭제 $filteredFriends");
  }

  void deleteTeamMember(User friend) {
    teamMembers.remove(friend);
    print("state - friend 삭제 {$friend}");
    print("state - 필터링 친구에는 친구 추가 $filteredFriends");
    print("state - 팀 멤버에는 친구 삭제 $teamMembers");
  }

  MeetState setBlindDateTeams(List<BlindDateTeam> blindDateTeams) {
    this.blindDateTeams = blindDateTeams;
    return this;
  }

  MeetState setTeamId(int teamId) {
    nowTeamId = teamId;
    return this;
  }

  @override
  String toString() {
    return 'MyTeams: $myTeams';
  }
}

enum MeetStateEnum {
  landing,
  twoPeople,
  threePeople,
  twoPeopleDone,
  threePeopleDone;

  bool get isMeetLanding => this == MeetStateEnum.landing;
  bool get isTwoPeople => this == MeetStateEnum.twoPeople;
  bool get isThreePeople => this == MeetStateEnum.threePeople;
  bool get isTwoPeopleDone => this == MeetStateEnum.twoPeopleDone;
  bool get isThreePeopleDone => this == MeetStateEnum.threePeopleDone;
}