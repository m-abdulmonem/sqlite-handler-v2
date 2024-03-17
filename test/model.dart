import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'user_model.dart';

void main() {

  test('insert', () async {
    UserModel user = await UserModel(
            name: "ali",
            email: "ana@ana.com",
            password: "123456789",
            createdAt: DateTime.now(),
            bio: "test0",
            isActive: true)
        .insert();

    expect(user.name, "ali");
  });

  // test('decyrptFile', () async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();

  //   final String path = join(appDocDir.path, "test_file");

  //   final String decryptedData = await FileEncryptor().decrypt(path);

  //   expect(decryptedData, content);
  // });
}
