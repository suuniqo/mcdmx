import 'package:flutter/material.dart';
import 'package:mcdmx/pages/map_panel.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/item_list.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';

class RoutePage extends StatelessWidget {
  Widget _searchButton(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton(
        backgroundColor: theme.colorScheme.surfaceContainer,
        highlightElevation: 0,
        elevation: Format.elevation,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPanel()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.search_rounded, color: theme.colorScheme.primary),
              SizedBox(width: Format.separatorIconTitle),
              Text(
                'Buscar',
                style: contentStyle.titleItem.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAccessTabs(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest,
          elevation: Format.elevation,
          child: TabBox(
            tabsData: [
              (
                Icons.favorite_rounded,
                'Favoritos',
                ItemList(itemName: 'Favoritos', children: []),
              ),
              (
                Icons.history_rounded,
                'Recientes',
                ItemList(itemName: 'Recientes', children: []),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TitledPage(
      title: '¿A dónde vas?',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _searchButton(context),
          SizedBox(height: Format.marginPrimary),
          _quickAccessTabs(context),
        ],
      ),
    );
  }
}
