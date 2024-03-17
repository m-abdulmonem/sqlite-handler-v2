import 'package:sqlite_handler/model.dart';

final tables = {
  'users': {
    'id': SqlTypes.integer,
    'name': SqlTypes.varchar,
    'email': SqlTypes.varchar,
    'password': SqlTypes.varchar,
    'is_active': SqlTypes.bool,
    'bio': SqlTypes.text,
    'created_at': SqlTypes.dateTime
  },
  'persons': () {
    Schema schema = Schema();
    schema.id();
    schema.text("email").notNull().unique();
    schema.text("name").nullable().defaultValue("anan");
    schema.text("password").notNull();
    schema.foreignId("company_id").constrained("compaines");
    schema.timestamps();
    return schema;
  },
  'departments': () {
    Schema schema = Schema();
    schema.id();
    schema.text("name").notNull();
    schema.timestamps();
    return schema;
  },
  'compaines': () {
    Schema schema = Schema();
    schema.id();
    schema.text("name").notNull();
    schema.timestamps();
    return schema;
  },
  'department_persons': () {
    Schema schema = Schema();
    schema.id();
    schema.foreignId("department_id").constrained("departments");
    schema.foreignId("person_id").constrained("persons");
    schema.timestamps();
    return schema;
  }
};
