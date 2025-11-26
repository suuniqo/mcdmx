import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';

class Bigcard extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Color? color;
  final Widget? icon;

  Bigcard({required this.title, this.style, this.color,this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: Format.elevation,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginCard),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: style),
                  SizedBox(width: 12),
                  SizedBox(width: 40,height: 40,child: icon!),
                ],
              )
            : Text(title, style: style),
      ),
    );
  }
}
