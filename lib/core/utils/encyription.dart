import 'dart:io';

import 'package:encrypt/encrypt.dart';
export 'package:path/path.dart';

class FileCryptor {
  static IV iv = IV.fromSecureRandom(16);

  Encrypter get encrypter => Encrypter(AES(Key.fromSecureRandom(32)));

  void encrypt(String path, String content) async {
    final file = File(path);

    file.writeAsBytes(encrypter.encrypt(content, iv: iv).bytes);
  }

  Future<String> decrypt(String path) async {
    final file = File(path);

    return encrypter.decrypt(Encrypted(await file.readAsBytes()), iv: iv);
  }
}
