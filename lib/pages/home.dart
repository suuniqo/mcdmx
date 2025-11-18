import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/widgets/bigcard.dart';
import 'package:mcdmx/style/spacing.dart';
import 'package:mcdmx/widgets/tab_box.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(SpacingStyle.marginPage),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(flex: 3),
            SizedBox(
              width: double.infinity,
              child: Bigcard(
                title: 'planea tu ruta',
                color: theme.colorScheme.primary,
                style: contentStyle.titlePrimary.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 7,
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: theme.colorScheme.surfaceContainerHigh,
                  elevation: 0,
                  child: TabBox(
                    tabsData: [
                      (Icons.favorite_rounded, 'Favoritos', const SizedBox()),
                      (Icons.history_rounded, 'Historial', const SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
