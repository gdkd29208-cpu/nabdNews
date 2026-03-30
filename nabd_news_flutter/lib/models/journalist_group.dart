class JournalistGroup {
  const JournalistGroup({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.ownerName,
    required this.memberCount,
    required this.isMember,
    required this.createdAt,
    this.description,
  });

  factory JournalistGroup.fromApi(Map<String, dynamic> json) {
    return JournalistGroup(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
      ownerId: json['owner_id'] as int,
      ownerName: (json['owner_name'] ?? 'غير معروف') as String,
      memberCount: json['member_count'] as int,
      isMember: json['is_member'] == true || json['is_member'] == 1,
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '') as String) ??
          DateTime.now(),
    );
  }

  final int id;
  final int ownerId;
  final String ownerName;
  final String name;
  final String? description;
  final int memberCount;
  final bool isMember;
  final DateTime createdAt;
}
