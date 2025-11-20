enum Role {
  student,
  teacher,
}

extension RoleExt on Role {

  String get value => toString().split('.').last;


  String get label {
    switch (this) {
      case Role.student:
        return 'Estudiante';
      case Role.teacher:
        return 'Profesor';
    }
  }


  static Role fromString(String s) {
    final lower = s.toLowerCase();

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