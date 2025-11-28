import 'package:collection/collection.dart';
import 'package:mcdmx/domain/stop.dart';

import 'station.dart';
import 'network.dart';
import 'heuristic.dart';

class AStar {
  final Network _network;

  AStar(this._network);

  PriorityQueue<({int acc, double f, double g, Stop stop})>
  _makeOpenSet() {
    return PriorityQueue((self, other) {
      var (acc: accA, f: fScoreA, g: gScoreA, stop: _) = self;
      var (acc: accB, f: fScoreB, g: gScoreB, stop: _) = other;

      var cmpFirst = accA.compareTo(accB);

      if (cmpFirst != 0) {
        return cmpFirst;
      }

      var cmpSecond = fScoreA.compareTo(fScoreB);

      if (cmpSecond != 0) {
        return cmpSecond;
      }

      return gScoreA.compareTo(gScoreB);
    });
  }

  ({int acc, double f, double g, Stop stop})
  _makeOpenSetEntry(Stop stop, Station stationDst, double gStop) {
      return (
        acc: _accScore(stop),
        f: gStop + Heuristic.hScore(stop, stationDst),
        g: gStop,
        stop: stop,
      );
  }

  int _accScore(Stop stop) {
    if (!_network.isAccesibleMode) {
      return 0;
    }

    return stop.station.accesible ? 0 : 1;
  }

  List<Station> _rebuildPath(Map<Stop, Stop?> prev, Stop last) {
    final path = [last.station];

    var curr = prev[last];

    while (curr != null) {
      // Podría ser un transbordo
      if (path.last != curr.station) {
        path.add(curr.station);
      }

      curr = prev[curr];
    }

    return path.reversed.toList();
  }

  List<Station>? calculateRoute(Station stationSrc, Station stationDst) {
    // Momento en el que se calcula la ruta
    final now = DateTime.now();

    // Encontré una Priority Queue
    final PriorityQueue<({
      int acc,
      double f,
      double g,
      Stop stop
    })> openSet = _makeOpenSet();

    // Se almaneza g(Stop) por cada Stop visitado
    final Map<Stop, double> gScore = {};

    // En vez de usar el closedList, es más eficiente usar un mapa de antecesores
    final Map<Stop, Stop?> prev = {};

    // Como cada estación tiene múltiples paradas, se inicializa A* con orígenes múltiples
    for (final stop in _network.stationStops[stationSrc]!) {
      prev[stop] = null;

      // En la primera parada del trayecto el tiempo será
      // el tiempo de espera al siguiente metro
      gScore[stop] = stop
        .direction
        .nextArrivalDuration(stop.station, now)
        .inMinutes
        .toDouble();

      final entry = _makeOpenSetEntry(stop, stationDst, 0.0);

      openSet.add(entry);
    }

    do {
      final (acc: _, f: _, g: gCurr, stop: curr) = openSet.removeFirst();

      if (gCurr > gScore[curr]!) {
        continue;
      }

      if (curr.station == stationDst) {
        return _rebuildPath(prev, curr);
      }

      for (final edge in _network.connections[curr]!) {
        final next = edge.opposite(curr)!;

        var gNext = gCurr + edge.cost;

        // Si es un transbordo hay que sumar
        // al coste lo que tarda el próximo tren
        if (curr.station == next.station) {
          gNext += curr
            .direction
            .nextArrivalDuration(curr.station, now.add(Duration(minutes: gNext.round())))
            .inMinutes
            .toDouble();
        }

        if (!gScore.containsKey(next) || gNext < gScore[next]!) {
          prev[next] = curr;
          gScore[next] = gNext;

          final entry = _makeOpenSetEntry(next, stationDst, gNext);

          openSet.add(entry);
        }
      }
    } while (openSet.isNotEmpty);

    // Significa que la estación destino está 'desconectada' del origen
    // que no debería ser posible salvo errores en la definición
    return null;
  }
}
