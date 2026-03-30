class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.isAdmin = false,
  });

  final int id;
  final String name;
  final String email;
  final bool isAdmin;

  String get roleLabel => isAdmin ? 'مدير تحرير' : 'صحفي';

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return 'ن';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1);
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}';
  }

  AppUser copyWith({String? name, String? email, bool? isAdmin}) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
