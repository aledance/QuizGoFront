enum Role {
  student,
  teacher,
}

extension RoleExt on Role {
  /// machine-facing value
  String get value => toString().split('.').last;

  /// human-friendly label (Spanish)
  String get label {
    switch (this) {
      case Role.student:
        return 'Estudiante';
      case Role.teacher:
        return 'Profesor';
    }
  }

  /// Parse from a variety of incoming role strings (legacy mapping included)
  static Role fromString(String s) {
    final lower = s.toLowerCase();
    // Map legacy and possible server values into the canonical two roles
    switch (lower) {
      case 'student':
      case 'player':
        return Role.student;
      case 'teacher':
      case 'educator':
      case 'admin':
      case 'moderator':
        return Role.teacher;
      default:
        return Role.student;
    }
  }
}
