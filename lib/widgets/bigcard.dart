import 'package:flutter/material.dart';
import 'package:mcdmx/style/spacing.dart';

class Bigcard extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Color? color;

  Bigcard({required this.title, this.style, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(SpacingStyle.marginCard),
        child: Text(title, style: style),
      ),
    );
  }
}
