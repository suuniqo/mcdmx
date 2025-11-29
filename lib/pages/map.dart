import 'package:flutter/material.dart';

import 'package:mcdmx/pages/network_info.dart';

import 'package:mcdmx/widgets/icon_fab.dart';
import 'package:mcdmx/widgets/map_cdmx.dart';

import 'package:mcdmx/style/format.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        MapCDMX(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Format.marginPrimary),
            child: IconFAB(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NetworkInfoPage()),
                );
              },
              msg: 'Busca líneas o paradas',
              icon: Icons.search_rounded,
              color: theme.colorScheme.surfaceContainer,
              center: false,
              elevation: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
