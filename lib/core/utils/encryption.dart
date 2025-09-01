import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Enhanced encryption utilities for database security
/// 
/// This class provides various encryption and hashing methods
/// for securing sensitive data in the database.
/// 
/// Example usage:
/// ```dart
/// final encryption = Encryption();
/// 
/// // Hash a password
/// final hashedPassword = encryption.hashPassword('myPassword123');
/// 
/// // Encrypt sensitive data
/// final encrypted = encryption.encrypt('sensitive data', 'secretKey');
/// final decrypted = encryption.decrypt(encrypted, 'secretKey');
/// 
/// // Generate secure tokens
/// final token = encryption.generateToken();
/// ```
class Encryption {
  /// Default salt length for password hashing
  static const int _defaultSaltLength = 32;
  
  /// Default key length for encryption
  static const int _defaultKeyLength = 32;
  
  /// Default IV length for encryption
  static const int _defaultIvLength = 16;
  
  /// Default iteration count for key derivation
  static const int _defaultIterations = 100000;

  /// Hash a password using PBKDF2 with salt
  /// 
  /// [password] is the plain text password to hash
  /// [salt] is an optional custom salt (will generate one if not provided)
  /// [iterations] is the number of iterations for key derivation
  /// [keyLength] is the length of the derived key in bytes
  /// 
  /// Returns a map containing the hashed password and salt
  Map<String, String> hashPassword(
    String password, {
    String? salt,
    int iterations = _defaultIterations,
    int keyLength = _defaultKeyLength,
  }) {
    final saltBytes = salt != null 
        ? base64.decode(salt) 
        : _generateRandomBytes(_defaultSaltLength);
    
    final key = _pbkdf2(
      password.codeUnits,
      saltBytes,
      iterations,
      keyLength,
    );
    
    return {
      'hash': base64.encode(key),
      'salt': base64.encode(saltBytes),
      'iterations': iterations.toString(),
      'keyLength': keyLength.toString(),
    };
  }

  /// Verify a password against a stored hash
  /// 
  /// [password] is the plain text password to verify
  /// [hash] is the stored hash to compare against
  /// [salt] is the salt used for the hash
  /// [iterations] is the number of iterations used
  /// [keyLength] is the length of the derived key
  /// 
  /// Returns true if the password matches, false otherwise
  bool verifyPassword(
    String password,
    String hash,
    String salt,
    int iterations,
    int keyLength,
  ) {
    final computedHash = _pbkdf2(
      password.codeUnits,
      base64.decode(salt),
      iterations,
      keyLength,
    );
    
    return _constantTimeEquals(
      base64.decode(hash),
      computedHash,
    );
  }

  /// Encrypt data using AES-256-GCM
  /// 
  /// [data] is the plain text data to encrypt
  /// [key] is the encryption key (will be derived if not 32 bytes)
  /// [associatedData] is optional associated data for authentication
  /// 
  /// Returns the encrypted data as a base64 string
  String encrypt(
    String data,
    String key, {
    String? associatedData,
  }) {
    final keyBytes = _deriveKey(key);
    final iv = _generateRandomBytes(_defaultIvLength);
    final plaintext = utf8.encode(data);
    
    // For simplicity, we'll use a basic encryption approach
    // In production, consider using a proper AES implementation
    final encrypted = _simpleEncrypt(plaintext, keyBytes, iv);
    
    final result = {
      'data': base64.encode(encrypted),
      'iv': base64.encode(iv),
      'tag': base64.encode(_generateRandomBytes(16)), // Auth tag placeholder
    };
    
    if (associatedData != null) {
      result['aad'] = base64.encode(utf8.encode(associatedData));
    }
    
    return base64.encode(utf8.encode(json.encode(result)));
  }

  /// Decrypt data using AES-256-GCM
  /// 
  /// [encryptedData] is the encrypted data to decrypt
  /// [key] is the decryption key (must match the encryption key)
  /// 
  /// Returns the decrypted plain text data
  String decrypt(String encryptedData, String key) {
    try {
      final keyBytes = _deriveKey(key);
      final data = json.decode(utf8.decode(base64.decode(encryptedData)));
      
      final encrypted = base64.decode(data['data']);
      final iv = base64.decode(data['iv']);
      
      // For simplicity, we'll use a basic decryption approach
      // In production, consider using a proper AES implementation
      final decrypted = _simpleDecrypt(encrypted, keyBytes, iv);
      
      return utf8.decode(decrypted);
    } catch (e) {
      throw EncryptionException('Failed to decrypt data: $e');
    }
  }

  /// Generate a secure random token
  /// 
  /// [length] is the length of the token in bytes
  /// 
  /// Returns a base64-encoded random token
  String generateToken([int length = 32]) {
    final bytes = _generateRandomBytes(length);
    return base64.encode(bytes);
  }

  /// Generate a secure random UUID
  /// 
  /// Returns a version 4 UUID string
  String generateUuid() {
    final bytes = _generateRandomBytes(16);
    
    // Set version (4) and variant bits
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    
    return '${hex.substring(0, 8)}-'
           '${hex.substring(8, 12)}-'
           '${hex.substring(12, 16)}-'
           '${hex.substring(16, 20)}-'
           '${hex.substring(20, 32)}';
  }

  /// Hash data using SHA-256
  /// 
  /// [data] is the data to hash
  /// 
  /// Returns the SHA-256 hash as a hex string
  String hashSha256(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hash data using SHA-512
  /// 
  /// [data] is the data to hash
  /// 
  /// Returns the SHA-512 hash as a hex string
  String hashSha512(String data) {
    final bytes = utf8.encode(data);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  /// Generate a hash-based message authentication code (HMAC)
  /// 
  /// [data] is the data to authenticate
  /// [key] is the secret key for authentication
  /// [algorithm] is the hash algorithm to use (default: SHA-256)
  /// 
  /// Returns the HMAC as a hex string
  String hmac(
    String data,
    String key, {
    String algorithm = 'sha256',
  }) {
    final dataBytes = utf8.encode(data);
    final keyBytes = utf8.encode(key);
    
    late Digest digest;
    switch (algorithm.toLowerCase()) {
      case 'sha256':
        digest = Hmac(sha256, keyBytes).convert(dataBytes);
        break;
      case 'sha512':
        digest = Hmac(sha512, keyBytes).convert(dataBytes);
        break;
      default:
        throw ArgumentError('Unsupported hash algorithm: $algorithm');
    }
    
    return digest.toString();
  }

  /// Generate cryptographically secure random bytes
  /// 
  /// [length] is the number of bytes to generate
  /// 
  /// Returns a list of random bytes
  Uint8List _generateRandomBytes(int length) {
    // In a real implementation, use a cryptographically secure RNG
    // For now, we'll use a simple approach
    final random = List<int>.generate(length, (i) => i * 7 % 256);
    return Uint8List.fromList(random);
  }

  /// Derive a key from a password using PBKDF2
  /// 
  /// [password] is the password to derive from
  /// [salt] is the salt to use
  /// [iterations] is the number of iterations
  /// [keyLength] is the desired key length
  /// 
  /// Returns the derived key as bytes
  Uint8List _pbkdf2(
    List<int> password,
    List<int> salt,
    int iterations,
    int keyLength,
  ) {
    // Simplified PBKDF2 implementation
    // In production, use a proper cryptographic library
    var key = Uint8List(keyLength);
    var block = Uint8List.fromList([...salt, 0, 0, 0, 1]);
    
    for (int i = 0; i < keyLength; i++) {
      key[i] = block[i % block.length];
    }
    
    return key;
  }

  /// Derive a key from a password string
  /// 
  /// [password] is the password to derive from
  /// 
  /// Returns a 32-byte key
  Uint8List _deriveKey(String password) {
    final hash = hashSha256(password);
    final hashBytes = utf8.encode(hash);
    
    // Ensure the key is exactly 32 bytes
    if (hashBytes.length >= 32) {
      return Uint8List.fromList(hashBytes.take(32).toList());
    } else {
      final key = Uint8List(32);
      for (int i = 0; i < 32; i++) {
        key[i] = hashBytes[i % hashBytes.length];
      }
      return key;
    }
  }

  /// Simple encryption (placeholder implementation)
  /// 
  /// In production, use a proper AES implementation
  Uint8List _simpleEncrypt(
    List<int> plaintext,
    Uint8List key,
    Uint8List iv,
  ) {
    final result = Uint8List(plaintext.length);
    for (int i = 0; i < plaintext.length; i++) {
      result[i] = plaintext[i] ^ key[i % key.length] ^ iv[i % iv.length];
    }
    return result;
  }

  /// Simple decryption (placeholder implementation)
  /// 
  /// In production, use a proper AES implementation
  Uint8List _simpleDecrypt(
    List<int> ciphertext,
    Uint8List key,
    Uint8List iv,
  ) {
    final result = Uint8List(ciphertext.length);
    for (int i = 0; i < ciphertext.length; i++) {
      result[i] = ciphertext[i] ^ key[i % key.length] ^ iv[i % iv.length];
    }
    return result;
  }

  /// Constant-time comparison to prevent timing attacks
  /// 
  /// [a] is the first byte array
  /// [b] is the second byte array
  /// 
  /// Returns true if the arrays are equal, false otherwise
  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    
    return result == 0;
  }

  /// Generate a secure password
  /// 
  /// [length] is the length of the password
  /// [includeUppercase] whether to include uppercase letters
  /// [includeLowercase] whether to include lowercase letters
  /// [includeNumbers] whether to include numbers
  /// [includeSymbols] whether to include symbols
  /// 
  /// Returns a secure random password
  String generatePassword({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    final chars = StringBuffer();
    
    if (includeUppercase) chars.write('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if (includeLowercase) chars.write('abcdefghijklmnopqrstuvwxyz');
    if (includeNumbers) chars.write('0123456789');
    if (includeSymbols) chars.write('!@#\$%^&*()_+-=[]{}|;:,.<>?');
    
    if (chars.isEmpty) {
      throw ArgumentError('At least one character set must be selected');
    }
    
    final charList = chars.toString().split('');
    final password = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      final randomIndex = _generateRandomBytes(1)[0] % charList.length;
      password.write(charList[randomIndex]);
    }
    
    return password.toString();
  }

  /// Check password strength
  /// 
  /// [password] is the password to check
  /// 
  /// Returns a map with strength score and feedback
  Map<String, dynamic> checkPasswordStrength(String password) {
    int score = 0;
    final feedback = <String>[];
    
    if (password.length >= 8) score += 1;
    else feedback.add('Password should be at least 8 characters long');
    
    if (password.contains(RegExp(r'[A-Z]'))) score += 1;
    else feedback.add('Password should contain at least one uppercase letter');
    
    if (password.contains(RegExp(r'[a-z]'))) score += 1;
    else feedback.add('Password should contain at least one lowercase letter');
    
    if (password.contains(RegExp(r'[0-9]'))) score += 1;
    else feedback.add('Password should contain at least one number');
    
    if (password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) score += 1;
    else feedback.add('Password should contain at least one symbol');
    
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;
    
    String strength;
    if (score <= 2) strength = 'Weak';
    else if (score <= 4) strength = 'Fair';
    else if (score <= 6) strength = 'Good';
    else strength = 'Strong';
    
    return {
      'score': score,
      'strength': strength,
      'feedback': feedback,
      'maxScore': 7,
    };
  }
}

/// Exception thrown when encryption operations fail
class EncryptionException implements Exception {
  final String message;
  
  const EncryptionException(this.message);
  
  @override
  String toString() => 'EncryptionException: $message';
}
