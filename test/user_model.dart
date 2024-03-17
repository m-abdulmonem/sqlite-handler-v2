
import 'package:sqlite_handler/model.dart';

class UserModel extends Model {
  int? id;
  String? email, password, name, bio;
  bool? isActive;
  DateTime? createdAt;

  UserModel(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.bio,
      this.createdAt,
      this.isActive})
      : super('users');

  @override
  UserModel fromMap(Map<dynamic, dynamic> map) => UserModel(
        id: map['id'],
        email: map['email'],
        password: map['password'],
        bio: map['bio'],
        name: map['name'],
        isActive: getBool(map['is_active']),
        createdAt: getDateTime(map['created_at']),
      );

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'email': email,
        'password': password,
        'bio': bio,
        'name': name,
        'is_active': isActive,
        'created_at': createdAt,
      };
}
