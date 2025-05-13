// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String Name;
  final String ProfilePic;
  final String about;
  final String sem;
  final String role;
  UserModel({
    required this.uid,
    required this.Name,
    required this.ProfilePic,
    required this.about,
    required this.sem,
    required this.role,
  });

  UserModel copyWith({
    String? uid,
    String? Name,
    String? ProfilePic,
    String? about,
    String? sem,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      Name: Name ?? this.Name,
      ProfilePic: ProfilePic ?? this.ProfilePic,
      about: about ?? this.about,
      sem: sem ?? this.sem,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'Name': Name,
      'ProfilePic': ProfilePic,
      'about': about,
      'sem': sem,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      Name: map['Name'] as String,
      ProfilePic: map['ProfilePic'] as String,
      about: map['about'] as String,
      sem: map['sem'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, Name: $Name, ProfilePic: $ProfilePic, about: $about, sem: $sem, role: $role)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.Name == Name &&
        other.ProfilePic == ProfilePic &&
        other.about == about &&
        other.sem == sem &&
        other.role == role;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        Name.hashCode ^
        ProfilePic.hashCode ^
        about.hashCode ^
        sem.hashCode ^
        role.hashCode;
  }
}
