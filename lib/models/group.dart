class Group {
  final String name;
  final String region;
  final String district;
  final String groupPhoto;
  final String leaderPhoto;
  final String ward;
  final String village;
  final String zone;
  final int totalMembers;
  final List members;

  Group({
    required this.name,
    required this.region,
    required this.district,
    required this.ward,
    required this.village,
    required this.zone,
    required this.totalMembers,
    required this.groupPhoto,
    required this.leaderPhoto,
    required this.members,
  });

  Group.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        region = map['region'],
        district = map['district'],
        ward = map['ward'],
        village = map['village'],
        totalMembers = map['total_members'],
        zone = map['zone'],
        leaderPhoto = map['leader_photo'] ??
            "https://images.unsplash.com/photo-1535745318714-da922ca9cc81?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHBlb3BsZSUyMGJsYWNrfGVufDB8fDB8fHww",
        groupPhoto = map['group_photo'] ??
            "https://images.unsplash.com/photo-1509099955921-f0b4ed0c175c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGZhcm1lcnMlMjBncm91cHxlbnwwfHwwfHx8MA%3D%3D",
        members = map['members'] ?? [];
}
