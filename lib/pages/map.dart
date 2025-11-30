import 'package:flutter/material.dart';

import 'package:mcdmx/state/network.dart';
import 'package:mcdmx/widgets/item_list.dart';

import 'package:provider/provider.dart';

import 'package:mcdmx/widgets/icon_textfield.dart';
import 'package:mcdmx/widgets/map_cdmx.dart';
import 'package:mcdmx/widgets/tab_box.dart';

import 'package:mcdmx/pages/info.dart';

import 'package:mcdmx/style/format.dart';


class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isSearchActive = false;
  bool _displayOverlay = false;

  final _focusNode = FocusNode();

  void _onSearchTap() {
    setState(() => _isSearchActive = true);
    _animationController.forward();
  }

  void _onSearchClose() {
    _focusNode.unfocus();
    setState(() => _displayOverlay = false);
    _animationController.reverse().then((_) {
      setState(() => _isSearchActive = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _focusNode.requestFocus();
        setState(() => _displayOverlay = true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _quickAccessTabs(BuildContext context, ThemeData theme) {
    // Datos de ejemplo
    final network = context.watch<NetworkState>();

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest,
          elevation: 0,
          child: TabBox(
            tabsData: [
              (
                Icons.directions_subway_filled_rounded,
                'Paradas',
                Center(
                  child: ItemList(
                    itemName:"No hay horarios disponibles",
                    children: [
                      for (var (i, station) in network.stations.indexed)
                        Padding(
                          padding: EdgeInsets.only(
                            top: i == 0 ? 0 : Format.marginPrimary,
                          ),
                          child: StationButton(
                            dst: StationsPage(
                              station: station,
                              lineas: station.lines,
                              lineaPage: false,
                            ),
                            station: station,
                            lines: station.lines,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              (
                Icons.timeline,
                'Lineas',
                Center(
                  child: ItemList(
                    itemName:"No hay horarios disponibles",
                    children: [
                      for (var (i, line) in network.lines.indexed)
                        Padding(
                          padding: EdgeInsets.only(
                            top: i == 0 ? 0 : Format.marginPrimary,
                          ),
                          child: Column(
                            children: [
                              LineButton(line: line, foward: true),
                              LineButton(line: line, foward: false),
                            ],
                          ),
                        ),
                    ],
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
    final maxHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        if (!_displayOverlay) 
          MapCDMX(),
        if (_isSearchActive)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _animation.value * maxHeight,
                child: Container(color: theme.colorScheme.surface)
              );
            },
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Format.marginPrimary),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Format.borderRadius),
                    boxShadow: Format.shadow,
                  ),
                  child: GestureDetector(
                    onTap: _displayOverlay ? null : _onSearchTap,
                    child: AbsorbPointer(
                      absorbing: !_isSearchActive,
                      child: IconTextfield(
                        msg: 'Busca líneas o paradas',
                        icon: _isSearchActive ? Icons.arrow_back_rounded : Icons.search_rounded,
                        primary: true,
                        focusNode: _focusNode,
                        onPressed: _onSearchClose,
                      ),
                    ),
                  ),
                ),
                if (_displayOverlay) 
                  SizedBox(height: Format.marginPrimary),
                if (_displayOverlay) 
                  _quickAccessTabs(context, theme),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
