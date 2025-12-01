import 'package:flutter/material.dart';
import 'package:mcdmx/pages/map_panel.dart';
import 'package:mcdmx/pages/map_route.dart';
import 'package:mcdmx/state/routes.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/icon_fab.dart';
import 'package:mcdmx/widgets/item_list.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';
import 'package:provider/provider.dart';

class RoutePage extends StatelessWidget {
  Widget _quickAccessTabs(BuildContext context, RoutesState routes) {
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
                  child: ItemList(itemName: 'favoritos', children: [
                    for (final fav in routes.favs)
                      InkWell(
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) => MapRoutePage(fav.$1, fav.$2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: fav == routes.favs.last ? 0 : Format.marginSecondary),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2*Format.marginSecondary, right: Format.marginSecondary),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(fav.$1.name.split(' ')[0]),
                                          Icon(Icons.arrow_right_rounded),
                                          Text(fav.$2.name.split(' ')[0]),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => routes.toggleFav(fav),
                                        icon: Icon(Icons.delete_outline_rounded),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
              (
                Icons.history_rounded,
                'Recientes',
                Padding(
                  padding: const EdgeInsets.all(Format.marginPrimary),
                  child: ItemList(itemName: 'recientes', children: [
                    for (final recent in routes.recents)
                      InkWell(
                        onTap: () => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) => MapRoutePage(recent.$1, recent.$2)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: recent == routes.recents.last ? 0 : Format.marginSecondary),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(Format.borderRadius)
                              ),
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2*Format.marginSecondary, right: Format.marginSecondary),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(recent.$1.name.split(' ')[0]),
                                          Icon(Icons.arrow_right_rounded),
                                          Text(recent.$2.name.split(' ')[0]),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => routes.removeRecent(recent),
                                        icon: Icon(Icons.delete_outline_rounded),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                  ),
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
    final routes = context.watch<RoutesState>();

    return TitledPage(
      title: '¿A dónde vas?',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconFAB(
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => MapPanelPage()),
            ),
            msg: 'Buscar',
            icon: Icons.search_rounded,
            color: theme.colorScheme.surfaceContainer,
            center: false,
          ),
          SizedBox(height: Format.marginPrimary),
          _quickAccessTabs(context, routes),
        ],
      ),
    );
  }
}
