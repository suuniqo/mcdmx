import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:mcdmx/widgets/map_cdmx.dart';

class MapPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        panel: Center(child: Text("This slides up!")),
        collapsed: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Center(
            child: Text("Swipe up", style: TextStyle(color: Colors.grey[600])),
          ),
        ),
        body: MapCDMX(),
        borderRadius: BorderRadius.circular(Format.borderRadius),
      ),
    );
  }
}
