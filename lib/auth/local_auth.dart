import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return true; // if no biometrics, return true

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
      );
    } on PlatformException catch (e) {
      return true;
    }
  }


}