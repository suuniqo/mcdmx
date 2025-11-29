import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mcdmx/domain/line.dart';

import 'package:mcdmx/domain/network.dart';
import 'package:mcdmx/domain/station.dart';

class NetworkState extends ChangeNotifier {
  final _network = Network.fromFile(File('insert/path/here'));

  bool get isAccesibleMode => _network.isAccesibleMode;

  Iterable<Station> get stations => _network.stations;
  Iterable<Line> get lines => _network.lines;

  void toggleAccesibleMode() {
    _network.toggleAccesibleMode();
    notifyListeners();
  }

  void restore() {
    if (_network.isAccesibleMode) {
      _network.toggleAccesibleMode();
    }
  }
}
