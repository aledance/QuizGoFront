// DTOs para la API de Grupos y Roles

class GroupSummary {
  final String id;
  final String name;
  final String role;
  final int memberCount;
  final DateTime createdAt;

  GroupSummary({
    required this.id,
    required this.name,
    required this.role,
    required this.memberCount,
    required this.createdAt,
  });

  factory GroupSummary.fromJson(Map<String, dynamic> json) => GroupSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        role: json['role'] as String,
        memberCount: (json['memberCount'] as num).toInt(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'memberCount': memberCount,
        'createdAt': createdAt.toIso8601String(),
      };
}

class GroupCreateRequest {
  final String name;
  GroupCreateRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class GroupCreateResponse {
  final String id;
  final String name;
  final String adminId;
  final int memberCount;
  final DateTime createdAt;

  GroupCreateResponse({
    required this.id,
    required this.name,
    required this.adminId,
    required this.memberCount,
    required this.createdAt,
  });

  factory GroupCreateResponse.fromJson(Map<String, dynamic> json) =>
      GroupCreateResponse(
        id: json['id'] as String,
        name: json['name'] as String,
        adminId: json['adminId'] as String,
        memberCount: (json['memberCount'] as num).toInt(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'adminId': adminId,
        'memberCount': memberCount,
        'createdAt': createdAt.toIso8601String(),
      };
}

class GroupPartialUpdate {
  final String? name;
  final String? description;

  GroupPartialUpdate({this.name, this.description});

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      };
}

class TransferAdminRequest {
  final String newAdminId;
  TransferAdminRequest({required this.newAdminId});

  Map<String, dynamic> toJson() => {'newAdminId': newAdminId};
}

class TransferAdminResponse {
  final String groupId;
  final AdminChange previousAdmin;
  final AdminChange newAdmin;
  final DateTime transferredAt;

  TransferAdminResponse({
    required this.groupId,
    required this.previousAdmin,
    required this.newAdmin,
    required this.transferredAt,
  });

  factory TransferAdminResponse.fromJson(Map<String, dynamic> json) =>
      TransferAdminResponse(
        groupId: json['groupId'] as String,
        previousAdmin:
            AdminChange.fromJson(json['previousAdmin'] as Map<String, dynamic>),
        newAdmin: AdminChange.fromJson(json['newAdmin'] as Map<String, dynamic>),
        transferredAt: DateTime.parse(json['transferredAt'] as String),
      );
}

class AdminChange {
  final String userId;
  final String newRole;
  AdminChange({required this.userId, required this.newRole});

  factory AdminChange.fromJson(Map<String, dynamic> json) => AdminChange(
        userId: json['userId'] as String,
        newRole: json['newRole'] as String,
      );

  Map<String, dynamic> toJson() => {'userId': userId, 'newRole': newRole};
}

class InvitationRequest {
  final String expiresIn;
  InvitationRequest({required this.expiresIn});

  Map<String, dynamic> toJson() => {'expiresIn': expiresIn};
}

class InvitationResponse {
  final String groupId;
  final String invitationLink;
  final DateTime expiresAt;

  InvitationResponse({
    required this.groupId,
    required this.invitationLink,
    required this.expiresAt,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      InvitationResponse(
        groupId: json['groupId'] as String,
        invitationLink: json['invitationLink'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
      );
}

class JoinRequest {
  final String invitationToken;
  JoinRequest({required this.invitationToken});

  Map<String, dynamic> toJson() => {'invitationToken': invitationToken};
}

class JoinResponse {
  final String groupId;
  final String groupName;
  final DateTime joinedAt;
  final String role;

  JoinResponse({
    required this.groupId,
    required this.groupName,
    required this.joinedAt,
    required this.role,
  });

  factory JoinResponse.fromJson(Map<String, dynamic> json) => JoinResponse(
        groupId: json['groupId'] as String,
        groupName: json['groupName'] as String,
        joinedAt: DateTime.parse(json['joinedAt'] as String),
        role: json['role'] as String,
      );
}

class AssignQuizRequest {
  final String quizId;
  final DateTime availableFrom;
  final DateTime availableTo;

  AssignQuizRequest({
    required this.quizId,
    required this.availableFrom,
    required this.availableTo,
  });

  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'availableFrom': availableFrom.toIso8601String(),
        'availableTo': availableTo.toIso8601String(),
      };
}

class AssignedQuizResponse {
  final String groupId;
  final String quizId;
  final String assignedBy;
  final DateTime availableFrom;
  final DateTime availableTo;

  AssignedQuizResponse({
    required this.groupId,
    required this.quizId,
    required this.assignedBy,
    required this.availableFrom,
    required this.availableTo,
  });

  factory AssignedQuizResponse.fromJson(Map<String, dynamic> json) =>
      AssignedQuizResponse(
        groupId: json['groupId'] as String,
        quizId: json['quizId'] as String,
        assignedBy: json['assignedBy'] as String,
        availableFrom: DateTime.parse(json['availableFrom'] as String),
        availableTo: DateTime.parse(json['availableTo'] as String),
      );
}

class LeaderboardEntry {
  final String userId;
  final String name;
  final int completedQuizzes;
  final int totalPoints;
  final int position;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.completedQuizzes,
    required this.totalPoints,
    required this.position,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        userId: json['userId'] as String,
        name: json['name'] as String,
        completedQuizzes: (json['completedQuizzes'] as num).toInt(),
        totalPoints: (json['totalPoints'] as num).toInt(),
        position: (json['position'] as num).toInt(),
      );
}

class QuizTopPlayer {
  final String userId;
  final String name;
  final int score;
  QuizTopPlayer({required this.userId, required this.name, required this.score});

  factory QuizTopPlayer.fromJson(Map<String, dynamic> json) => QuizTopPlayer(
        userId: json['userId'] as String,
        name: json['name'] as String,
        score: (json['score'] as num).toInt(),
      );
}

class QuizLeaderboardResponse {
  final String quizId;
  final String groupId;
  final List<QuizTopPlayer> topPlayers;

  QuizLeaderboardResponse({
    required this.quizId,
    required this.groupId,
    required this.topPlayers,
  });

  factory QuizLeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      QuizLeaderboardResponse(
        quizId: json['quizId'] as String,
        groupId: json['groupId'] as String,
        topPlayers: (json['topPlayers'] as List<dynamic>)
            .map((e) => QuizTopPlayer.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
