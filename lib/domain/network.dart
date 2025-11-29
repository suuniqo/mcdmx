import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';

import './line.dart';
import './station.dart';
import './stop.dart';
import './edge.dart';

class Network {
  final List<Line> _lines;
  final List<Station> _stations;

  // Horarios de apertura oficiales
  static const TimeOfDay _openingTimeReg = TimeOfDay(hour: 5, minute: 0);
  static const TimeOfDay _openingTimeSat = TimeOfDay(hour: 6, minute: 0);
  static const TimeOfDay _openingTimeSun = TimeOfDay(hour: 7, minute: 0);
  static const TimeOfDay _closingTime    = TimeOfDay(hour: 0, minute: 0);

  // La velocidad programada del tren es 36 km/h,
  // aunque luego se haya registrado que de media es menos
  static const double trainVelocity = 600.0; // metros por minuto

  static const bool accesibleModeDefault = false;

  late Map<Station, Set<Stop>> _stationStops;
  late Map<Stop, Set<Edge>> _connections;

  // TODO: Rellenar en el constructor o en la fábrica
  // es sólo el mínimo del coste de las aristas dónde
  // ambos nodos son la misma estación, es decir,
  // el mínimo timepo de andar el transbordo.
  // No hace falta el mínimo tiempo de esperar el tren
  // ya que siempre es 0.
  late int _minTransferTime;

  bool _isAccesibleMode = accesibleModeDefault;

  Network(this._lines, this._stations) {
    // TODO: Rellenar

    // IMPORTANTE: Como el json tiene bastante información
    // como transbordos igual es más eficiente que connections y/o stationStops
    // sean argumentos del constructor y creados en Network.fromFile,
    // en vez de calculare a posteriori

    // A partir de aquí están rellenos ambos

    _stationStops = {};
    _connections = {};
  }

  Iterable<Line> get lines => _lines;
  Iterable<Station> get stations => _stations;

  bool get isAccesibleMode => _isAccesibleMode;
  int get minTransferTime => _minTransferTime;

  Map<Stop, Set<Edge>> get connections => _connections;
  Map<Station, Set<Stop>> get stationStops => _stationStops;

  TimeOfDay get closingTime => _closingTime;

  TimeOfDay openingTime(DateTime day) {
    var weekday = day.weekday;

    if (weekday == 7) {
      return _openingTimeSun;
    }
    if (weekday == 6) {
      return _openingTimeSat;
    }

    return _openingTimeReg;
  }

  // Si es posible, retorna la arista
  // de la parada src que te lleva a una
  // parada de la línea line
  Edge? pathToLine(Stop src, Line line) {
    for (final edge in _connections[src]!) {
      if (edge.opposite(src)!.line == line) {
        return edge;
      }
    }
    return null;
  }

  // TODO: mínimo número de transbordos de una línea a otra
  // como son pocas líneas es fácil, incluso
  // a malas podríais verlo a mano y ponerlo en el json
  // PLUS: en vez de mínimo número de una línea a otra,
  // de una parada (Stop) a una línea.
  // IMPORTANTE: Necesita estar precomputado, se puede
  // hacer un Map<(Line, Line), int> o lo que sea
  int minTransfers(Line src, Line dst) {
    return 1;
  }

  // Interruptor para el modo accesible
  void toggleAccesibleMode() {
    _isAccesibleMode = !_isAccesibleMode;
  }

  factory Network.fromFile(File file) {
      // try{
      //     final String json = await file.readAsString();
      //
      //     final Map<String, dynamic> data = jsonDecode(json);
      //
      // }
    final List<Line> lines = [];
    final List<Station> stations = [];

    // TODO: Rellenar listas

    return Network(lines, stations);
  }
}
