class JournalistGroup {
  const JournalistGroup({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.memberIds,
    required this.accessCode,
    required this.createdAt,
    this.description,
  });

  final int id;
  final int ownerId;
  final String name;
  final String? description;
  final String accessCode;
  final DateTime createdAt;
  final List<int> memberIds;

  bool hasMember(int userId) => memberIds.contains(userId);

  JournalistGroup copyWith({
    String? name,
    String? description,
    String? accessCode,
    List<int>? memberIds,
  }) {
    return JournalistGroup(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      accessCode: accessCode ?? this.accessCode,
      createdAt: createdAt,
      memberIds: memberIds ?? this.memberIds,
    );
  }
}
