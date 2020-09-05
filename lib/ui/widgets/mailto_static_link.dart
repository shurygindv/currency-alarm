import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MailtoStaticLink extends StatelessWidget {
  static const String email = 'shurygindv1@gmail.com';

  final String subject;
  final String body;

  const MailtoStaticLink({this.subject = "", this.body = ""});

  Uri _createEmailUri() {
    return Uri(
        scheme: 'mailto', path: email, queryParameters: {'subject': subject});
  }

  Future<void> _launchURL() async {
    final url = _createEmailUri().toString();

    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      // be silent gentleman
    }
  }

  // TODO: as libs funcs
  void emailToClipboard(String v) {
    Clipboard.setData(new ClipboardData(text: v));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL();
        emailToClipboard(email);
      },
      child: Text(
        email,
        style: TextStyle(
            fontSize: 17,
            decoration: TextDecoration.underline,
            color: Colors.black54),
      ),
    );
  }
}
