import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';

class LineasParadasPage extends StatelessWidget {
  const LineasParadasPage({super.key});
Widget _quickAccessTabs(ThemeData theme) {
  // Datos de ejemplo
  final paradas = ['Pantitlán', 'Constitución', 'Chabacano', 'Centro Médico'];
  final lineas = ['Línea 1', 'Línea 2', 'Línea 3', 'Línea 4'];

  return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest,
          elevation: 0,
          child: TabBox(
            tabsData: [
              (Icons.directions_subway_filled_rounded, 'Paradas', const SizedBox()),
              (Icons.timeline, 'Lineas', const SizedBox()),
            ],
          ),
        ),
      ),
    );
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body:TitledPage(
      title: 'Metro',
      icon: Icon(Icons.train_rounded),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: Format.marginPage),
          _quickAccessTabs(theme),
        ],
      ),      
    ),
    );
  }
}
