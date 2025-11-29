import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/bigcard.dart';
import 'package:mcdmx/style/content.dart';

class TitledPage extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? icon;

  TitledPage({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    final contentStyle = ContentStyle.fromTheme(Theme.of(context));

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              // TODO: que pasa con este padding?
              top: Format.marginPrimary,
              left: Format.marginPrimary,
              right: Format.marginPrimary,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Bigcard(
                title: title,
                style: contentStyle.titlePrimary,
                icon: icon,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Format.marginPrimary),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Format.borderRadius),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
