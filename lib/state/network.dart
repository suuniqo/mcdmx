import 'dart:io';

import 'package:flutter/material.dart';

import 'package:mcdmx/domain/network.dart';

class NetworkState extends ChangeNotifier {
  final _network = Network.fromFile(File('insert/path/here'));

  bool get isAccesibleMode => _network.isAccesibleMode;

  void toggleAccesibleMode() {
    _network.toggleAccesibleMode();
    notifyListeners();
  }
}
