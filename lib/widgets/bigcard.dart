import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';

class Bigcard extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Color? color;

  Bigcard({required this.title, this.style, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: Format.elevation,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginCard),
        child: Text(title, style: style),
      ),
    );
  }
}
