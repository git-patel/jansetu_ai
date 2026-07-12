class CurrentUser {
  final String uid;
  final String name;
  final String email;
  final String role; // e.g. CITIZEN, MP, ADMIN
  final String language;
  final String state;
  final String district;
  final String constituency;
  final String ward;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;
  final String? deviceId;

  const CurrentUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.language,
    required this.state,
    required this.district,
    required this.constituency,
    required this.ward,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
    this.deviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'language': language,
      'state': state,
      'district': district,
      'constituency': constituency,
      'ward': ward,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'photoUrl': photoUrl,
      'deviceId': deviceId,
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? 'Anonymous User',
      email: map['email'] as String? ?? '',
      role: map['role'] as String? ?? 'CITIZEN',
      language: map['language'] as String? ?? 'English',
      state: map['state'] as String? ?? 'Gujarat',
      district: map['district'] as String? ?? '',
      constituency: map['constituency'] as String? ?? '',
      ward: map['ward'] as String? ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'] as String) 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'] as String) 
          : DateTime.now(),
      photoUrl: map['photoUrl'] as String?,
      deviceId: map['deviceId'] as String?,
    );
  }
}
