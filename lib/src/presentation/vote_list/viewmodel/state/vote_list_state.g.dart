// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteListState _$VoteListStateFromJson(Map<String, dynamic> json) =>
    VoteListState(
      isLoading: json['isLoading'] as bool,
      votes: (json['votes'] as List<dynamic>)
          .map((e) => VoteResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFirstTime: json['isFirstTime'] as bool,
      visited: (json['visited'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as bool),
      ),
      nowVoteId: json['nowVoteId'] as int,
          userMe: User(
                personalInfo: null,
                university: null,
                titleVotes: [],
          ),
    );

Map<String, dynamic> _$VoteListStateToJson(VoteListState instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'votes': instance.votes,
      'visited': instance.visited.map((k, e) => MapEntry(k.toString(), e)),
      'isFirstTime': instance.isFirstTime,
      'nowVoteId': instance.nowVoteId,
    };
