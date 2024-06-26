class ProposalRequestDto {
  int? _requestingTeamId;
  int? _requestedTeamId;

  ProposalRequestDto({int? requestingTeamId, int? requestedTeamId}) {
    if (requestingTeamId != null) {
      _requestingTeamId = requestingTeamId;
    }
    if (requestedTeamId != null) {
      _requestedTeamId = requestedTeamId;
    }
  }

  int? get requestingTeamId => _requestingTeamId;
  set requestingTeamId(int? requestingTeamId) =>
      _requestingTeamId = requestingTeamId;
  int? get requestedTeamId => _requestedTeamId;
  set requestedTeamId(int? requestedTeamId) =>
      _requestedTeamId = requestedTeamId;

  ProposalRequestDto.fromJson(Map<String, dynamic> json) {
    _requestingTeamId = json['requestingTeamId'];
    _requestedTeamId = json['requestedTeamId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestingTeamId'] = _requestingTeamId;
    data['requestedTeamId'] = _requestedTeamId;
    return data;
  }
}
