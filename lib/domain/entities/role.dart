enum Role {
  admin,
  educator,
  moderator,
  player,
}

extension RoleExt on Role {
  String get value => toString().split('.').last;

  static Role fromString(String s) {
    switch (s) {
      case 'admin':
        return Role.admin;
      case 'educator':
        return Role.educator;
      case 'moderator':
        return Role.moderator;
      case 'player':
      default:
        return Role.player;
    }
  }
}
