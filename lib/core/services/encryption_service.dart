import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypts sensitive document vault data at rest using AES-256-GCM.
class EncryptionService {
  EncryptionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _keyName = 'travelmate_vault_key_v2';
  static const _legacyPrefix = 'legacy::';

  enc.Key? _cachedKey;

  Future<void> init() async {
    final stored = await _storage.read(key: _keyName);
    if (stored != null && stored.isNotEmpty) {
      _cachedKey = enc.Key(base64Decode(stored));
      return;
    }

    final random = Random.secure();
    final bytes = Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
    _cachedKey = enc.Key(bytes);
    await _storage.write(key: _keyName, value: base64Encode(bytes));
  }

  String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;
    final key = _cachedKey;
    if (key == null) return _legacyEncrypt(plainText);

    final iv = enc.IV.fromSecureRandom(12);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${base64Encode(iv.bytes)}::${encrypted.base64}';
  }

  String decrypt(String cipherText) {
    if (cipherText.startsWith(_legacyPrefix)) {
      return _legacyDecrypt(cipherText.substring(_legacyPrefix.length));
    }
    if (cipherText.contains('::') && !cipherText.startsWith('legacy')) {
      final parts = cipherText.split('::');
      if (parts.length == 2) {
        final key = _cachedKey;
        if (key != null) {
          try {
            final iv = enc.IV(base64Decode(parts[0]));
            final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
            return encrypter.decrypt(enc.Encrypted.fromBase64(parts[1]), iv: iv);
          } catch (_) {
            return _legacyDecrypt(cipherText);
          }
        }
      }
      return _legacyDecrypt(cipherText);
    }
    return cipherText;
  }

  String _legacyEncrypt(String plainText) {
    final key = base64Encode(_cachedKey?.bytes ?? List.filled(32, 0));
    return '$_legacyPrefix${base64Encode(utf8.encode('$key::$plainText'))}';
  }

  String _legacyDecrypt(String cipherText) {
    try {
      final decoded = utf8.decode(base64Decode(cipherText));
      final idx = decoded.indexOf('::');
      if (idx == -1) return decoded;
      return decoded.substring(idx + 2);
    } catch (_) {
      return cipherText;
    }
  }
}
