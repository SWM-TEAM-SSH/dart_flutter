import 'package:dart_flutter/src/common/pagination/pagination.dart';
import 'package:dart_flutter/src/domain/entity/question.dart';
import 'package:dart_flutter/src/domain/entity/title_vote.dart';
import 'package:dart_flutter/src/domain/entity/vote_detail.dart';
import 'package:dart_flutter/src/domain/entity/vote_request.dart';
import 'package:dart_flutter/src/domain/entity/vote_response.dart';

abstract class VoteRepository {
  Future<List<Question>> getNewQuestions();
  Future<void> sendMyVotes(List<VoteRequest> voteRequests);
  Future<void> sendMyVote(VoteRequest voteRequest);
  Future<Pagination<VoteResponse>> getVotes({int page});
  Future<VoteDetail> getVote(int voteId);
  Future<DateTime> getNextVoteTime();
  Future<DateTime> postNextVoteTime();
  Future<List<TitleVote>> getMyVoteSummary();
}
