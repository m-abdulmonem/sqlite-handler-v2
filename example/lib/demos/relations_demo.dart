import 'package:sqlite_handler/database/database_helper.dart';
import 'package:sqlite_handler/model.dart';

class RelCompany extends Model {
  int? id;
  String? name;
  RelCompany({this.id, this.name}) : super(table: 'compaines');

  DBHelper persons() => hasMany('persons', 'person_id');

  @override
  Map<String, Object?> toMap() => {'id': id, 'name': name};

  @override
  RelCompany fromMap(Map<dynamic, dynamic> map) => RelCompany(
        id: map['id'] as int?,
        name: map['name'] as String?,
      );
}

class RelPerson extends Model {
  int? id;
  String? name;
  int? companyId;
  RelPerson({this.id, this.name, this.companyId}) : super(table: 'persons');

  DBHelper company() => belongsTo('compaines', 'company_id');
  DBHelper departments() => belongsToMany('departments', 'department_persons',
      tableId: 'person_id', relatedId: 'department_id');

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'company_id': companyId,
      };

  @override
  RelPerson fromMap(Map<dynamic, dynamic> map) => RelPerson(
        id: map['id'] as int?,
        name: map['name'] as String?,
        companyId: map['company_id'] as int?,
      );
}

Future<String> runRelationsDemo() async {
  final company = await RelCompany(name: 'Acme').insert() as RelCompany?;
  final person = await RelPerson(name: 'Bob', companyId: company?.id).insert()
      as RelPerson?;

  if (company != null && person != null) {
    final companyPersons = await company
        .persons()
        .where('id', value: person.id)
        .pluck(['id', 'name']);
    final personCompany = await person.company().pluck(['id', 'name']);

    return 'Company persons: $companyPersons\nPerson company: $personCompany';
  }

  return 'Failed to create company or person';
}
