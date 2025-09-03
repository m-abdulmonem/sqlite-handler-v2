import 'package:sqlite_handler/model.dart';
import 'package:sqlite_handler/core/enums/orders.dart';

class DemoUser extends Model {
  int? id;
  String? name;
  String? email;
  DateTime? createdAt;

  DemoUser({this.id, this.name, this.email, this.createdAt})
      : super(table: 'users');

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'created_at': createdAt?.toIso8601String(),
      };

  @override
  DemoUser fromMap(Map<dynamic, dynamic> map) => DemoUser(
        id: map['id'] as int?,
        name: map['name'] as String?,
        email: map['email'] as String?,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
      );
}

Future<String> runQueryDemo() async {
  final buffer = StringBuffer();

  // Insert
  final user = await DemoUser(
          name: 'Alice', email: 'alice@example.com', createdAt: DateTime.now())
      .insert() as DemoUser?;
  buffer.writeln('Inserted user id=${user?.id}');

  // Select with where/order/limit
  final list = await DemoUser()
      .where('email', value: 'alice@example.com')
      .orderBy(column: 'created_at', order: DatabaseOrder.descending)
      .limit(1)
      .pluck(['id', 'name', 'email']);
  buffer.writeln('Pluck top: $list');

  // Aggregate
  final count = await DemoUser().count();
  buffer.writeln('Users count: $count');

  // Update
  if (user?.id != null) {
    await DemoUser(id: user!.id, name: 'Alice Updated').update(user.id!);
    final updated = await DemoUser().find(user.id!) as DemoUser?;
    buffer.writeln('Updated name: ${updated?.name}');

    // Delete
    if (updated?.id != null) {
      await updated!.delete(updated.id!);
      buffer.writeln('Deleted user id=${user.id}');
    }
  }

  return buffer.toString();
}
