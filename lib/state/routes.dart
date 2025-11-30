import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mcdmx/domain/station.dart';

class RoutesState extends ChangeNotifier {
  static const int _recentsNum = 12;

  final Queue<(Station, Station)> _recents = Queue();
  final Set<(Station, Station)> _favs = {};

  Iterable<(Station, Station)> get favs => _favs;
  Iterable<(Station, Station)> get recents => _recents.toList().reversed;

  bool isFav((Station, Station) route) {
    return _favs.contains(route);
  }

  void toggleFav((Station, Station) route) {
    if (_favs.contains(route)) {
      _favs.remove(route);
    } else {
      _favs.add(route);
    }
    notifyListeners();
  }

  void pushRecent((Station, Station) route) {
    _recents.remove(route);

    _recents.add(route);

    if (_recents.length > _recentsNum) {
      _recents.removeFirst();
    }

    notifyListeners();
  }

  void removeRecent((Station, Station) route) {
    _recents.remove(route);
    notifyListeners();
  }

  void restore() {
    _recents.clear();
    _favs.clear();

    notifyListeners();
  }
}

