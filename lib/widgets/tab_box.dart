
import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:tab_container/tab_container.dart';

class TabBox extends StatelessWidget {
  final List<(IconData, String, Widget)> tabsData;

  TabBox({required this.tabsData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(Theme.of(context));

    return TabContainer(
      selectedTextStyle: contentStyle.titleItem.copyWith(fontWeight: FontWeight.bold),
      unselectedTextStyle: contentStyle.titleItem,
      colors: List.generate(tabsData.length, (_) => theme.colorScheme.surfaceContainerLow),
      tabs: tabsData.map((tabData) {
        var (icon, title, _) = tabData;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary,),
            SizedBox(width: 6),
            Text(title),
          ],
        );
      }).toList(),
      children: tabsData.map((item) => item.$3).toList(),
    );
  }
}
