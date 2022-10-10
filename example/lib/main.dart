import 'package:flutter/material.dart';
import 'package:sqlite_handler/model.dart';
import 'package:sqlite_handler_example/tables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // // CustomWidgets().convertSharedDataToSqlite();
  // await GetStorage.init();

  Migrations.createTables(tables);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
            child: const Text('Running on: n'),
            onPressed: () async {
              await UserModel(
                      name: "Allen",
                      email: "allen@ana.com",
                      password: "123456789",
                      isActive: true,
                      createdAt: DateTime.now(),
                      bio: "Allen")
                  .insert();

              await UserModel(
                      name: "Teddy",
                      email: "teddy@ana.com",
                      password: "123456789",
                      isActive: true,
                      createdAt: DateTime.now(),
                      bio: "Teddy")
                  .insert();

              await UserModel(
                      name: "Mark",
                      email: "mark@ana.com",
                      password: "123456789",
                      isActive: true,
                      createdAt: DateTime.now(),
                      bio: "Mark")
                  .insert();

              await UserModel(
                      name: "James",
                      email: "hames@ana.com",
                      password: "123456789",
                      isActive: true,
                      createdAt: DateTime.now(),
                      bio: "James")
                  .insert();

              await UserModel(
                      name: "Kim",
                      email: "kim@ana.com",
                      password: "123456789",
                      isActive: true,
                      createdAt: DateTime.now(),
                      bio: "Kim")
                  .insert();

              await UserModel(
                      name: "Paul",
                      email: "paul@ana.com",
                      password: "123456789",
                      isActive: false,
                      createdAt: DateTime.now(),
                      bio: "Paul")
                  .insert();

              await UserModel(
                      name: "ali",
                      email: "ana@ana.com",
                      password: "123456789",
                      isActive: true,
                      createdAt: DateTime.now(),
                      bio: "annna")
                  .insert();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // UserModel a = await UserModel()
            //     .orWhere("id", value: 21)
            //     .limit(2)
            //     .order()
            //     .first();
            UserModel user = await UserModel().find(1);

            PersonsModel person = await PersonsModel(
              name: "ali",
              email: "ana@ana.com",
              password: "123456789",
              userId: user.id,
              createdAt: DateTime.now(),
            ).insert();

            print(await person.outerJoin());
            // print(await person.outerJoin());
            // print(a.name);
// print((await UserModel().where("id",value: 21).first()).ali);

            // print(UserModel().fromMap(a[0]));
          },
          child: const Text("click me"),
        ),
      ),
    );
  }
}

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

class PersonsModel extends Model {
  int? id, userId;
  String? email, password, name;
  DateTime? createdAt;

  PersonsModel(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.createdAt,
      this.userId})
      : super('persons');
  // super('persons', );

  @override
  PersonsModel fromMap(Map<dynamic, dynamic> map) => PersonsModel(
        id: map['id'],
        email: map['email'],
        password: map['password'],
        name: map['name'],
        userId: map['user_id'],
        createdAt: getDateTime(map['created_at']),
      );

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'email': email,
        'password': password,
        'name': name,
        'user_id': userId,
        'created_at': createdAt,
      };
}
