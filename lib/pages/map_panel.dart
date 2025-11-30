import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mcdmx/domain/station.dart';
import 'package:mcdmx/pages/map_route.dart';
import 'package:mcdmx/state/network.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/network.dart';
import 'package:mcdmx/widgets/icon_fab.dart';
import 'package:mcdmx/widgets/icon_textfield.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:mcdmx/widgets/maps.dart';

class MapPanelPage extends StatefulWidget {
  @override
  State<MapPanelPage> createState() => _MapPanelPageState();
}

class _MapPanelPageState extends State<MapPanelPage> {
  static const LatLng offsetCDMX = LatLng(
    19.37786673706038,
    -99.17284775574397
  );

  final _controllerPanel = PanelController();
  final _focusOrigin = FocusNode();
  final _focusDest = FocusNode();
  final _controllerOrigin = TextEditingController();
  final _controllerDest = TextEditingController();

  bool _isOpen = false;
  bool _focusRequested = false;

  Station? _origin;
  Station? _dest;

  void _validateOrigin() {
    final network = context.read<NetworkState>();
    final text = _controllerOrigin.text.trim();

    for (final station in network.stations) {
      if (text.toLowerCase() == station.name.toLowerCase()) {
        _controllerOrigin.text = station.name;
        setState(() => _origin = station);
        return;
      }
    }
    
    setState(() => _origin = null);
    setState(() => _dest = null);
    _controllerDest.clear();
  }

  void _validateDest() {
    final network = context.read<NetworkState>();
    final text = _controllerDest.text.trim();

    for (final station in network.stations) {
      if (text.toLowerCase() == station.name.toLowerCase()) {
        _controllerDest.text = station.name;
        setState(() => _dest = station);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MapRoutePage(_origin!, _dest!)));
        return;
      }
    }
    setState(() => _dest = null);
  }


  @override
  void initState() {
    super.initState();

    _controllerOrigin.addListener(_validateOrigin);
    _controllerDest.addListener(_validateDest);

    _focusOrigin.addListener(() {
      if (_focusOrigin.hasFocus) {
        _controllerPanel.open();
      }
    });

    _focusDest.addListener(() {
      if (_focusDest.hasFocus) {
        _controllerPanel.open();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusOrigin.dispose();
    _focusDest.dispose();
    _controllerOrigin.dispose();
    _controllerDest.dispose();
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
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              SizedBox(height: 8),
              Text('Planifica tu viaje', style: contentStyle.titleTertiary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClosedTitle(BuildContext context) {
    final theme = Theme.of(context);
    final contentStyle = ContentStyle.fromTheme(theme);

    return Column(
      children: [
        SizedBox(height: 8),
        Text(
          _origin != null ? 'Indica tu destino' : 'Indica tu origen', 
          style: contentStyle.titleTertiary
        ),
        Text(
          'Busca su nombre o selecciónalo en el mapa',
          style: contentStyle.descItem,
        ),
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

  Widget _buildRecommendationList(BuildContext context) {
    final theme = Theme.of(context);
    final content = ContentStyle.fromTheme(theme);

    final network = context.watch<NetworkState>();

    final matching = network.stations.where(
      (station) => station.name
        .toLowerCase()
        .startsWith(
          _origin != null
            ? _controllerDest.text.toLowerCase().trim()
            : _controllerOrigin.text.toLowerCase().trim()
        )
    );

    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final match in matching)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (_origin == null) {
                    _controllerOrigin.text = match.name;
                    setState(() => _origin = match);
                  } else if (_dest == null) {
                    _controllerDest.text = match.name;
                    setState(() => _dest = match);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MapRoutePage(_origin!, _dest!)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Format.marginPrimary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            NetworkStyle.fromStation(match),
                            height: 40,
                            width: 40,
                          ),
                        ],
                      ),
                      SizedBox(width: Format.marginPrimary,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              match.name,
                              style: content.titleItem,
                            ),
                            Text(
                              'A xx km de tu ubicación'
                            ),
                            Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                          ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
            onPanelOpened: () {
              setState(() => _isOpen = true);
              if (!_focusRequested) {
                if (_origin == null) {
                  _focusOrigin.requestFocus();
                } else if (_dest == null) {
                  _focusDest.requestFocus();
                }
                setState(() => _focusRequested = true);
              }
            },
            onPanelClosed: () {
              setState(() {
                  _isOpen = false;
                  _focusRequested = false;
              });
              FocusManager.instance.primaryFocus?.unfocus();
            },
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            controller: _controllerPanel,
            maxHeight: constraints.maxHeight * 0.94,
            minHeight: 225,
            boxShadow: Format.shadow,
            color: theme.colorScheme.surfaceContainerLow,
            collapsed: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Format.borderRadius),
              ),
              child: Column(
                children: [
                  SizedBox(height: Format.marginPrimary),
                  _buildDragHandle(context),
                  SizedBox(height: Format.marginPrimary),
                  _buildClosedTitle(context),
                  SizedBox(height: Format.marginPrimary),
                  Divider(color: theme.colorScheme.surfaceTint, thickness: 2),
                  SizedBox(height: Format.marginPrimary),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Format.marginPrimary,
                    ),
                    child: IconFAB(
                      onPressed: () {
                        _controllerPanel.open();
                        _focusDest.requestFocus();
                      },
                      msg: 'Buscar estación',
                      icon: Icons.directions_subway_rounded,
                      color: theme.colorScheme.surfaceContainerLowest,
                      center: true,
                    ),
                  ),
                ],
              ),
            ),
            panel: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Format.borderRadius),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Format.marginPrimary),
                      child: Column(
                        children: [
                          _buildDragHandle(context),
                          SizedBox(height: Format.marginPrimary),
                          _buildOpenTile(context),
                          SizedBox(height: Format.marginPrimary),
                          IconTextfield(
                            icon: Icons.trip_origin_rounded,
                            msg: 'Estación de origen',
                            primary: false,
                            focusNode: _focusOrigin,
                            controller: _controllerOrigin,
                            readOnly: _origin != null,
                          ),
                          SizedBox(height: Format.marginSecondary),
                          IconTextfield(
                            icon: Icons.location_on_rounded,
                            msg: 'Estación de destino',
                            primary: false,
                            focusNode: _focusDest,
                            controller: _controllerDest,
                            enabled: _origin != null,
                            readOnly: _dest != null,
                          ),
                          SizedBox(height: Format.marginPrimary),
                        ],
                      ),
                    ),
                    _buildRecommendationList(context),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                MapCDMX(
                  offsetCDMX,
                  (station) {
                    if (_origin == null) {
                      _controllerOrigin.text = station.name;
                    } else if (_dest == null) {
                      _controllerDest.text = station.name;
                      setState(() => _focusRequested = true);
                      _controllerPanel.open();
                    }
                  }
                ),
                _buildBackArrow(context)]
              ),
            borderRadius: BorderRadius.circular(Format.borderRadius),
          );
        },
      ),
    );
  }
}
