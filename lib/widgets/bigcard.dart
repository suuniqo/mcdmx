import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';

class Bigcard extends StatelessWidget {
  final String title;

  Bigcard({required this.title});

  @override
  Widget build(BuildContext context) {
    final contentStyle = ContentStyle.fromTheme(Theme.of(context));

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(title, style: contentStyle.titlePrimary),
      ),
    );
  }
}
