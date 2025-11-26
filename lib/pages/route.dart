import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';

class RoutePage extends StatelessWidget {
  Widget _searchButton(ThemeData theme, ContentStyle contentStyle) {
    return SizedBox(
      width: double.infinity,
      child: FloatingActionButton(
        backgroundColor: theme.colorScheme.surfaceContainer,
        highlightElevation: 0,
        elevation: 0,
        onPressed: () {},
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

  Widget _quickAccessTabs(ThemeData theme) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest,
          elevation: 0,
          child: TabBox(
            tabsData: [
              (Icons.favorite_rounded, 'Favoritos', const SizedBox()),
              (Icons.history_rounded, 'Recientes', const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return TitledPage(
      title: '¿A dónde vas?',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _searchButton(theme, contentStyle),
          SizedBox(height: Format.marginPage),
          _quickAccessTabs(theme),
        ],
      ),
    );
  }
}
