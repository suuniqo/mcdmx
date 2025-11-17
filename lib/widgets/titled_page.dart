import 'package:flutter/material.dart';
import 'package:mcdmx/style/spacing.dart';
import 'package:mcdmx/widgets/bigcard.dart';

class TitledPage extends StatelessWidget {
  final Widget child;
  final String title;

  TitledPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(SpacingStyle.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child:  Bigcard(title: title),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

}
