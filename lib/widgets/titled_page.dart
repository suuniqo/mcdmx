import 'package:flutter/material.dart';
import 'package:mcdmx/style/spacing.dart';
import 'package:mcdmx/widgets/bigcard.dart';
import 'package:mcdmx/style/content.dart';

class TitledPage extends StatelessWidget {
  final Widget child;
  final String title;

  TitledPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final contentStyle = ContentStyle.fromTheme(Theme.of(context));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(SpacingStyle.marginPage),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Bigcard(title: title, style: contentStyle.titlePrimary),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

}
