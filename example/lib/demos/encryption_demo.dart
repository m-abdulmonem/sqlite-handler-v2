import 'package:sqlite_handler/core/utils/encryption.dart';

Future<String> runEncryptionDemo() async {
  final buffer = StringBuffer();
  const password = 'P@ssw0rd!';

  final encryption = Encryption();
  final pw = encryption.hashPassword(password);
  final ok = encryption.verifyPassword(
    password,
    pw['hash']!,
    pw['salt']!,
    int.parse(pw['iterations']!),
    int.parse(pw['keyLength']!),
  );
  final notOk = encryption.verifyPassword(
    'wrong',
    pw['hash']!,
    pw['salt']!,
    int.parse(pw['iterations']!),
    int.parse(pw['keyLength']!),
  );

  final token = encryption.generateToken(16);
  final uuid = encryption.generateUuid();
  final sha = encryption.hashSha256('hello');

  // Simple symmetric encryption demo
  final encStr = encryption.encrypt('hello', 'secret');
  final decStr = encryption.decrypt(encStr, 'secret');

  buffer
    ..writeln('Password hash verified: $ok (wrong: $notOk)')
    ..writeln('Token: $token')
    ..writeln('UUID: $uuid')
    ..writeln('SHA256("hello"): $sha')
    ..writeln('Roundtrip encrypt/decrypt OK: ${decStr == 'hello'}');

  return buffer.toString();
}
