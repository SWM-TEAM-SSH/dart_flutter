import 'package:dart_flutter/src/domain/entity/location.dart';
import 'package:dart_flutter/src/domain/entity/type/blind_date_user.dart';
import 'package:dart_flutter/src/domain/entity/type/blind_date_user_detail.dart';
import 'package:dart_flutter/src/domain/entity/type/student.dart';
import 'package:dart_flutter/src/domain/entity/type/team.dart';
import 'package:dart_flutter/src/domain/mapper/student_mapper.dart';

class BlindDateTeamDetail implements Team {
  final int id;
  final String name;
  final double averageAge;
  final List<Location> regions;
  final String universityName;
  final bool isCertifiedTeam;
  final List<Student> teamUsers;
  final bool proposalStatus;

  BlindDateTeamDetail(
      {required this.id,
       required this.name,
       required this.averageAge,
       required this.regions,
       required this.universityName,
       required this.isCertifiedTeam,
       required this.teamUsers,
       required this.proposalStatus});

  factory BlindDateTeamDetail.fromJson(Map<String, dynamic> json) {
    final int parsedId = json['id'];
    final String parsedName = json['name'];
    final double parsedAverageAge = json['averageAge'];

    List<Location> parsedRegions = [];
    if (json['regions'] != null) {
      var regionsJsonList = json['regions'] as List<dynamic>;
      parsedRegions =
          regionsJsonList.map((v) => Location.fromJson(v)).toList();
    }

    final String parsedUniversityName = json['universityName'];
    final bool parsedIsCertifiedTeam = json['isCertifiedTeam'];

    List<BlindDateUserDetail> parsedTeamUsers = [];
    if (json['teamUsers'] != null) {
      var teamUsersJsonList = json['teamUsers'] as List<dynamic>;
      parsedTeamUsers =
          teamUsersJsonList.map((v) => BlindDateUserDetail.fromJson(v)).toList();
    }

    final bool parsedProposalStatus = json['proposalStatus'];

    return BlindDateTeamDetail(
        id:parsedId ,
        name:parsedName ,
        averageAge:parsedAverageAge ,
        regions :parsedRegions ,
        universityName :parsedUniversityName ,
        isCertifiedTeam :parsedIsCertifiedTeam ,
        teamUsers :parsedTeamUsers,
        proposalStatus: parsedProposalStatus
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['averageAge'] = averageAge;
    if (regions.isNotEmpty) {
      data['regions'] = regions.map((v) => v.toJson()).toList();
    }
    data['universityName'] = universityName;
    data['isCertifiedTeam'] = isCertifiedTeam;
    if (teamUsers.isNotEmpty) {
      data['teamUsers'] = teamUsers.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'BlindDateTeamDetailResponse{id: $id, name: $name, averageAge: $averageAge, regions: $regions, universityName: $universityName, isCertifiedTeam: $isCertifiedTeam, teamUsers: $teamUsers}';
  }

  @override
  int getId() {
    return id;
  }

  @override
  String getName() {
    return name;
  }

  @override
  double getAverageAge() {
    return averageAge;
  }

  @override
  List<Location> getRegions() {
    return regions;
  }

  @override
  String getUniversityName() {
    return universityName;
  }

  @override
  bool getIsCertifiedTeam() {
    return isCertifiedTeam;
  }

  @override
  List<BlindDateUser> getTeamUsers() {
    return teamUsers.map((user) => StudentMapper.toBlindDateUser(user)).toList();
  }
}
