import 'package:flutter/material.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/pages/map_panel.dart';
import 'package:mcdmx/pages/map_route.dart';
import 'package:mcdmx/state/routes.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/network.dart';
import 'package:mcdmx/widgets/icon_fab.dart';
import 'package:mcdmx/widgets/item_list.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';
import 'package:provider/provider.dart';

class RoutePage extends StatelessWidget {
  Widget _buildSavedRoute(BuildContext context, (Station, Station) route, RoutesState routes, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(Format.borderRadius),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => MapRoutePage(route.$1, route.$2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Format.marginPrimary),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            NetworkStyle.fromStation(route.$1),
                            height: 22,
                            width: 22,
                          ),
                          SizedBox(width: 4,),
                          Text(route.$1.name),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 9,),
                          Container(
                            width: 3,
                            height: 10,
                            color: NetworkStyle.lineColor(route.$1.lines.first),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            NetworkStyle.fromStation(route.$2),
                            height: 22,
                            width: 22,
                          ),
                          SizedBox(width: 4,),
                          Text(route.$2.name),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onPressed,
                    icon: Icon(icon),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
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
                      Padding(
                        padding: EdgeInsets.only(bottom: fav == routes.favs.last ? 0 : Format.marginSecondary),
                        child: _buildSavedRoute(context, fav, routes, Icons.close_rounded, () => routes.toggleFav(fav)),
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
                      Padding(
                        padding: EdgeInsets.only(bottom: recent == routes.recents.last ? 0 : Format.marginSecondary),
                        child: _buildSavedRoute(context, recent, routes, Icons.close_rounded, () => routes.removeRecent(recent))
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
