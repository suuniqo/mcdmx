import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';

import 'package:mcdmx/style/format.dart';

class ItemList extends StatelessWidget {
  final List<Widget> children;
  final String itemName;

  ItemList({required this.itemName, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Card(
      margin: EdgeInsets.zero,
      elevation: Format.elevation,
      color: theme.colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(Format.marginSecondary),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Format.borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: children.isNotEmpty
              ? ListView(children: children)
              : SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(flex: 1),
                      Text(
                        'No hay $itemName',
                        style: contentStyle.titleSecondary.copyWith(
                          color: theme.colorScheme.surfaceDim,
                        ),
                      ),
                      Spacer(flex: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
