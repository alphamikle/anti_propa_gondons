import 'package:anti_propa_gondons/domain/about/content/replacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yalo_locale/lib.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  void _handleLinkTap(String text, String? href, String title) {
    try {
      launch(href ?? '');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Some error with link: (Text: "$text"; Href: "$href"; Title: $title)'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LocalizationMessages loc = Messages.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.about.title),
      ),
      body: Markdown(
        data: replaceLargeContent(loc.about.content),
        onTapLink: _handleLinkTap,
      ),
    );
  }
}
