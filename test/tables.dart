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
    schema.integer("user_id").nullable();
    schema.timestamps();
    return schema;
  }
};

