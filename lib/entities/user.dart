class User {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String role;
  final String token;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.role,
      required this.token});

  bool get isAdmin {
    return role.contains('Administrador');
  }

  bool get isTutor {
    return role.contains('Tutor');
  }

  bool get isStudent {
    return role.contains('Student');
  }
}
