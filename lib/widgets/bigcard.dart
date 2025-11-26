import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';

class Bigcard extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Color? color;
  final Icon? icon;

  Bigcard({required this.title, this.style, this.color,this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginCard),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: style),
                  SizedBox(width: 12),
                  Icon(icon!.icon,size: 40),
                ],
              )
            : Text(title, style: style),
      ),
    );
  }
}
