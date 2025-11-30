import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcdmx/domain/line.dart';

import 'package:mcdmx/domain/network.dart';
import 'package:mcdmx/domain/station.dart';

class NetworkState extends ChangeNotifier {
  final Network _network;

  NetworkState._(this._network);

  static Future<NetworkState> create() async {
    final jsonString = await rootBundle.loadString('assets/data/data.json');
    final network = Network.fromJson(jsonString);

    return NetworkState._(network);
  }

  bool get isAccesibleMode => _network.isAccesibleMode;

  Iterable<Station> get stations => _network.stations;
  Iterable<Line> get lines => _network.lines;

  void toggleAccesibleMode() {
    _network.toggleAccesibleMode();
    notifyListeners();
  }

  (List<Station>, int) calculateRoute(Station src, Station dst) {
    return _network.calculateRoute(src, dst);
  }

  Line? lineBetweenStations(Station src, Station dst) {
    return _network.lineBetweenStations(src, dst);
  }

  void restore() {
    if (_network.isAccesibleMode) {
      _network.toggleAccesibleMode();
    }
    notifyListeners();
  }
}
