import 'package:flutter/material.dart';
import 'package:mcdmx/pages/map_panel.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/icon_fab.dart';
import 'package:mcdmx/widgets/item_list.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';

class RoutePage extends StatelessWidget {
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
                Padding(
                  padding: const EdgeInsets.all(Format.marginPrimary),
                  child: ItemList(itemName: 'favoritos', children: []),
                ),
              ),
              (
                Icons.history_rounded,
                'Recientes',
                Padding(
                  padding: const EdgeInsets.all(Format.marginPrimary),
                  child: ItemList(itemName: 'recientes', children: []),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TitledPage(
      title: '¿A dónde vas?',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconFAB(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPanel()),
            ),
            msg: 'Buscar',
            icon: Icons.search_rounded,
            color: theme.colorScheme.surfaceContainer,
            center: false,
          ),
          SizedBox(height: Format.marginPrimary),
          _quickAccessTabs(context),
        ],
      ),
    );
  }
}
