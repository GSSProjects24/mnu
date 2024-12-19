import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../homePage.dart';


class BiometricLogin extends StatefulWidget {
  const BiometricLogin({super.key});

  @override
  State<BiometricLogin> createState() => _BiometricLoginState();
}

class _BiometricLoginState extends State<BiometricLogin> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  @override
  void initState() {
    super.initState();
    authenticateWithBiometrics();
  }

  Future<void> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();
    bool authenticated = false;
    final List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();

    try {
      // Check if biometric authentication is available on the device
      bool canCheckBiometrics = await localAuth.canCheckBiometrics ||
          await localAuth.isDeviceSupported();
      if (!canCheckBiometrics) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        // Authenticate with biometrics

        authenticated = await localAuth.authenticate( 
          // options: AuthenticationOptions(biometricOnly: true),

          localizedReason:
              'Authenticate to access protected content', // Reason for the authentication prompt
          // useErrorDialogs: true, // Show system error dialogs if needed
          // stickyAuth: true, // Use sticky authentication to prevent automatic dismissal
        );
      }
    } catch (e) {
      debugPrint('Failed to authenticate with biometrics: $e');
    }

    if (authenticated) {
      // Biometric authentication successful, proceed with your app logic
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      // Biometric authentication failed or was cancelled by the user(
      authenticateWithBiometrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.fingerprint,
          size: 100,
          color: Colors.deepOrangeAccent,
        ),
      ),
    );
  }
}
