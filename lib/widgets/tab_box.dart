import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:tab_container/tab_container.dart';

class TabBox extends StatelessWidget {
  final List<(IconData, String, Widget)> tabsData;

  TabBox({required this.tabsData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(Theme.of(context));

    return TabContainer(
      selectedTextStyle: contentStyle.titleItem,
      unselectedTextStyle: contentStyle.titleItem.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      colors: List.generate(
        tabsData.length,
        (_) => theme.colorScheme.surfaceContainer,
      ),
      tabs: tabsData.map((tabData) {
        var (icon, title, _) = tabData;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              SizedBox(width: Format.separatorIconTitle),
              Text(title),
            ],
          ),
        );
      }).toList(),
      children: tabsData.map((item) => item.$3).toList(),
    );
  }
}
