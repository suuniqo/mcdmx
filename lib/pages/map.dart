  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';

  import 'package:provider/provider.dart';

  import 'package:mcdmx/pages/route.dart';
  import 'package:mcdmx/pages/news.dart';
  import 'package:mcdmx/pages/map.dart';
  import 'package:mcdmx/pages/settings.dart';
  import 'package:mcdmx/state/scheme.dart';
  import 'package:mcdmx/style/format.dart';
  import 'package:mcdmx/style/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';
import 'package:mcdmx/pages/lineasparadas.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  // Full-width search button
  Widget _searchButton(ThemeData theme, ContentStyle contentStyle, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LineasParadasPage()), // Use your class here
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainer,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Scaffold(
      body: SafeArea(
        child: Padding(
           padding: const EdgeInsets.all(Format.marginPrimary),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _searchButton(theme, contentStyle, context),
              SizedBox(height: Format.marginPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

