// import 'dart:io';

// import 'package:encrypt/encrypt.dart';
// export 'package:path/path.dart';

// class FileCryptor {
//   static Key key = Key.fromUtf8('mabdulmonemsaddiqabulemnom');
//   static IV iv = IV.fromSecureRandom(16);

//   Encrypter get encrypter => Encrypter(AES(key));


// aaa(){
//   final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';

//   // final key = Key.fromUtf8('mabdulmonemsaddiqabulemnom');
//   // final iv = IV.fromLength(16);

//   final encrypter = Encrypter(AES(key));

//   final encrypted = encrypter.encrypt(plainText, iv: iv);
//   final decrypted = encrypter.decrypt(encrypted, iv: iv);

//   print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//   print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==

// }

//   void encrypt(String path, String content) async {

//     final file = File(path);

//     String contents = encrypter.encrypt(content, iv: iv).base64;

//     file.writeAsString(contents);
//   }

//   Future<String> decrypt(String path) async {
//     final file = File(path);

//     final content = await file.readAsString();


//     return encrypter.decrypt(Encrypted.from, iv: iv);
//   }
// }
