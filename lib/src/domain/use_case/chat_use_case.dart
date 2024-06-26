import 'package:dart_flutter/src/common/pagination/pagination.dart';
import 'package:dart_flutter/src/data/repository/dart_chat_repository.dart';
import 'package:dart_flutter/src/data/repository/dart_proposal_repository.dart';
import 'package:dart_flutter/src/domain/entity/chat_message.dart';
import 'package:dart_flutter/src/domain/entity/chat_room.dart';
import 'package:dart_flutter/src/domain/entity/chat_room_detail.dart';
import 'package:dart_flutter/src/domain/entity/proposal.dart';
import 'package:dart_flutter/src/domain/repository/chat_repository.dart';
import 'package:dart_flutter/src/domain/repository/proposal_repository.dart';

class ChatUseCase {
  final ChatRepository _chatRepository = DartChatRepository();
  final ProposalRepository _proposalRepository = DartProposalRepository();

  Future<ChatRoomDetail> getChatRoomDetail(int teamId) async {
    return _chatRepository.getChatRoomDetail(teamId);
  }

  Future<List<ChatRoom>> getChatRooms() async {
    return _chatRepository.getChatRooms();
  }

  Future<Pagination<ChatMessage>> getChatMessages(int chatRoomId, {int page = 0}) {
    return _chatRepository.getChatMessages(chatRoomId, page: page);
  }

  // Future<void> createChatRoom(int proposalId) {
  //   return _chatRepository.createChatRoom(proposalId);
  // }

  Future<void> requestChat(int myTeamId, int targetTeamId) async {
    await _proposalRepository.requestChat(myTeamId, targetTeamId);
  }

  Future<void> acceptChatProposal(int proposalId) async {
    // var proposal = await _proposalRepository.acceptChatProposal(proposalId);
    await _chatRepository.createChatRoom(proposalId);
  }

  Future<Proposal> rejectChatProposal(int proposalId) async {
    return await _proposalRepository.rejectChatProposal(proposalId);
  }

  Future<List<Proposal>> getMyRequestedProposals() async {
    return await _proposalRepository.getMyRequestedProposals();
  }

  Future<List<Proposal>> getMyReceivedProposals() async {
    return await _proposalRepository.getMyReceivedProposals();
  }
}
