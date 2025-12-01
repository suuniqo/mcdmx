import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:mcdmx/state/network.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/network.dart';

import 'package:provider/provider.dart';

import 'package:mcdmx/widgets/icon_textfield.dart';
import 'package:mcdmx/widgets/maps.dart';
import 'package:mcdmx/widgets/tab_box.dart';

import 'package:mcdmx/pages/info.dart';

import 'package:mcdmx/style/format.dart';


class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  static const LatLng centeredCDMX = LatLng(
    19.389547839456625,
    -99.1722223513429,
  );

  final TextEditingController _textController = TextEditingController();

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

    _textController.addListener(() => setState(() {}));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_displayOverlay) {
        _focusNode.requestFocus();
        setState(() => _displayOverlay = true);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildSearchLines() {
    final theme = Theme.of(context);
    final content = ContentStyle.fromTheme(theme);

    final network = context.watch<NetworkState>();

    final matching = network.lines.expand((line) => [line.forwardDir, line.backwardDir]).where(
      (direction) {
        final names = direction.name.split('-');
        final prefix = _textController.text.toLowerCase().trim();

        return names[0].toLowerCase().startsWith(prefix) || names[1].toLowerCase().startsWith(prefix);
      }
    );

    return Padding(
      padding: const EdgeInsets.all(Format.marginPrimary),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final match in matching)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LinesPage(dir: match))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        NetworkStyle.fromLine(match.line),
                        height: 34,
                        width: 34,
                      ),
                    ),
                    SizedBox(width: Format.marginPrimary,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                match.name.split('-')[1],
                                style: content.titleItem,
                              ),
                            ],
                          ),
                          Text('Desde ${match.name.split('-')[0]}'),
                          if (match != matching.last)
                            Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchStations() {
    final theme = Theme.of(context);
    final content = ContentStyle.fromTheme(theme);

    final network = context.watch<NetworkState>();

    final matching = network.stations.where(
      (station) => station.name
        .toLowerCase()
        .startsWith(_textController.text.toLowerCase().trim())
    );

    return Padding(
      padding: const EdgeInsets.all(Format.marginPrimary),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final match in matching)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StationsPage(station: match))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      NetworkStyle.fromStation(match),
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: Format.marginPrimary,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                match.name,
                                style: content.titleItem,
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  for (final line in match.lines)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4.0),
                                      child: Image.asset(
                                        NetworkStyle.fromLine(line),
                                        height: 16,
                                        width: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(match.accesible ? Icons.accessible_rounded : Icons.not_accessible_rounded, size: 15),
                              SizedBox(width: 4,),
                              Text(match.accesible ? 'Accesible' : 'No accesible'),
                            ],
                          ),
                          if (match != matching.last)
                            Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _quickAccessTabs(BuildContext context, ThemeData theme) {
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
                'Estaciones',
                Center(
                  child: _buildSearchStations(),
              )),
              (
                Icons.timeline,
                'Lineas',
                Center(
                  child: _buildSearchLines()
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
          MapCDMX(
            centeredCDMX,
            (station) => Navigator.push(context, MaterialPageRoute(builder: (context) => StationsPage(station: station))),
          ),
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
                        msg: 'Busca líneas o estaciones',
                        icon: _isSearchActive ? Icons.arrow_back_rounded : Icons.search_rounded,
                        primary: true,
                        focusNode: _focusNode,
                        controller: _textController,
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
