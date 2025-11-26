import 'dart:io';

import './line.dart';
import './stop.dart';
import './station.dart';
import './edge.dart';

class Network {
  final List<Line> _lines;
  final List<Station> _stations;

  final Map<Stop, Set<Edge>> _connections;

  Network(this._lines, this._stations, this._connections);

  List<Line> get lines => _lines;
  List<Station> get stations => _stations;
  Map<Stop, Set<Edge>> get connections => _connections;

  // TODO: implementar
  factory Network.fromFile(File file) {
    final List<Line> lines = [];
    final List<Station> stations = [];
    final Map<Stop, Set<Edge>> connections = {};

    return Network(lines, stations, connections);
  }
}
