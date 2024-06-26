
import 'package:dart_flutter/src/common/pagination/pagination.dart';
import 'package:dart_flutter/src/domain/entity/blind_date_team.dart';
import 'package:dart_flutter/src/domain/entity/blind_date_team_detail.dart';

abstract class BlindDateTeamRepository {
  Future<Pagination<BlindDateTeam>> getTeams({int page, int size, int targetLocationId, bool targetCertificated = false, bool targetProfileImage = false});
  Future<BlindDateTeamDetail> getTeam(int id);
  Future<Pagination<BlindDateTeam>> getTeamsMostLiked({int page, int size, int targetLocationId, bool targetCertificated = false, bool targetProfileImage = false});
  Future<Pagination<BlindDateTeam>> getTeamsMostSeen({int page, int size, int targetLocationId, bool targetCertificated = false, bool targetProfileImage = false});
}
