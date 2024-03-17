import 'package:flutter/material.dart';
import 'package:sqlite_handler/database/database_helper.dart';
import 'package:sqlite_handler/model.dart';
import 'package:sqlite_handler_example/tables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
            // PersonsModel user = PersonsModel();
            // var all = await user.all();

            // print(all);
            print(await PersonsModel().pluck(['id', 'name']));

            // var a = ['name'];
            // print(a.runtimeType.toString().contains("List<String>"));

            // UserModel a = await UserModel()
            //     .orWhere("id", value: 21)
            //     .limit(2)
            //     .order()
            //     .first();
            // UserModel user = await UserModel().find(1);

            // PersonsModel person = await PersonsModel(
            //   name: "ali",
            //   email: "ana@ana.com",
            //   password: "123456789",
            //   userId: user.id,
            //   createdAt: DateTime.now(),
            // ).insert();

            // print(await PersonsModel().outerJoin());
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
  int? id, companyId;
  String? email, password, name;
  DateTime? createdAt;

  PersonsModel(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.createdAt,
      this.companyId})
      : super('persons');
  // super('persons', );

  DBHelper departments() {
    return belongsToMany("departments", "department_persons",
        tabelId: "department_id", relatedId: "person_id");
  }

  DBHelper company() {
    return belongsTo("compaines", "company_id");
  }

  @override
  PersonsModel fromMap(Map<dynamic, dynamic> map) => PersonsModel(
        id: map['id'],
        email: map['email'],
        password: map['password'],
        name: map['name'],
        companyId: map['company_id'],
        createdAt: getDateTime(map['created_at']),
      );

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'email': email,
        'password': password,
        'name': name,
        'company_id': companyId,
        'created_at': createdAt,
      };
}

class CompanyModel extends Model {
  int? id;
  String? name;
  DateTime? createdAt;

  CompanyModel({this.id, this.name, this.createdAt})
      : super('compaines');



  DBHelper persons() {
    return hasMany("persons", "person_id");
  }


  @override
  CompanyModel fromMap(Map<dynamic, dynamic> map) => CompanyModel(
        id: map['id'],
        name: map['name'],
        createdAt: getDateTime(map['created_at']),
      );

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'created_at': createdAt,
      };
}

class DepartmentModel extends Model {
  int? id;
  String? name;
  DateTime? createdAt;

  DepartmentModel({this.id, this.name, this.createdAt}) : super('departments');

  DBHelper persons() {
    return belongsToMany("persons", "department_persons",
        tabelId: "person_id", relatedId: "department_id");
  }

  @override
  DepartmentModel fromMap(Map<dynamic, dynamic> map) => DepartmentModel(
        id: map['id'],
        name: map['name'],
        createdAt: getDateTime(map['created_at']),
      );

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'created_at': createdAt,
      };
}
