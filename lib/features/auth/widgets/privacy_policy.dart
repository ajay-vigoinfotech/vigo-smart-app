import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/constants.dart';
import '../../../core/strings/strings.dart';

class PrivacyPolicy extends StatelessWidget {
  final String privacyPolicyUrl = AppConstants.privacyPolicyUrl;

  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            Strings.terms,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: Strings.privacyPolicy,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  Uri url = Uri.parse(privacyPolicyUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
            ),
          ),
        ],
      ),
    );
  }
}
