import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/icon_fab.dart';
import 'package:mcdmx/widgets/icon_textfield.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:mcdmx/widgets/map_cdmx.dart';

class MapPanel extends StatefulWidget {
  @override
  State<MapPanel> createState() => _MapPanelState();
}

class _MapPanelState extends State<MapPanel> {
  final _panelController = PanelController();
  final _focusOrigin = FocusNode();
  final _focusDestination = FocusNode();

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _focusOrigin.addListener(() {
      if (_focusOrigin.hasFocus) {
        _panelController.open();
      }
    });

    _focusDestination.addListener(() {
      if (_focusDestination.hasFocus) {
        _panelController.open();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusOrigin.dispose();
    _focusDestination.dispose();
  }

  Widget _buildDragHandle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 50,
      height: 5,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceTint,
        borderRadius: BorderRadius.circular(Format.borderRadius),
      ),
    );
  }

  Widget _buildOpenTile(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: theme.colorScheme.onSurface,)
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              SizedBox(height: 8,),
              Text('Planifica tu viaje', style: contentStyle.titleTertiary),
            ],
          )
        ),
      ],
    );
  }

  Widget _buildClosedTitle(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Column(
      children: [
        SizedBox(height: 8,),
        Text('Indica tu destino', style: contentStyle.titleTertiary),
        Text('Busca su nombre o selecciónalo en el mapa', style: contentStyle.descItem),
      ],
    );
  }

  Widget _buildBackArrow(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Format.marginPrimary),
        child: Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                boxShadow: Format.shadow,
                color: theme.colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SlidingUpPanel(
            defaultPanelState: _isOpen ? PanelState.OPEN : PanelState.CLOSED,
            onPanelOpened: () => setState(() => _isOpen = true),
            onPanelClosed: () {
              setState(() => _isOpen = false);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            controller: _panelController,
            maxHeight: constraints.maxHeight * 0.9,
            minHeight: 245,
            boxShadow: Format.shadow,
            color: theme.colorScheme.surfaceContainerLow,
            collapsed: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Format.borderRadius),
                ),
                child: Column(
                  children: [
                    SizedBox(height: Format.marginPrimary,),
                    _buildDragHandle(context),
                    SizedBox(height: Format.marginPrimary,),
                    _buildClosedTitle(context),
                    SizedBox(height: Format.marginPrimary,),
                    Divider(color: theme.colorScheme.surfaceTint, thickness: 2,),
                    Expanded(child:
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Format.marginPrimary),
                          child: IconFAB(
                            onPressed: () {
                              _panelController.open();
                              _focusDestination.requestFocus();
                            },
                            msg: 'Buscar estación',
                            icon: Icons.directions_subway_rounded,
                            color: theme.colorScheme.surfaceContainerLowest,
                            center: true,
                          ),
                        )
                      )
                    )
                  ],
                ),
              ),
            ),
            panel: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Format.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Format.marginPrimary),
                  child: Column(
                    children: [
                      _buildDragHandle(context),
                      SizedBox(height: Format.marginPrimary,),
                      _buildOpenTile(context),
                      SizedBox(height: Format.marginPrimary,),
                      IconTextfield(
                        icon: Icons.trip_origin_rounded,
                        msg: 'Estación de origen',
                        focusNode: _focusOrigin,
                      ),
                      SizedBox(height: Format.marginSecondary,),
                      IconTextfield(
                        icon: Icons.location_on_rounded,
                        msg: 'Estación de destino',
                        focusNode: _focusDestination,
                      ),
                      SizedBox(height: Format.marginPrimary,),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(children: [MapCDMX(), _buildBackArrow(context)]),
            borderRadius: BorderRadius.circular(Format.borderRadius),
          );
        }
      ),
    );
  }
}
