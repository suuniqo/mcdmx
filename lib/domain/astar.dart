import 'package:collection/collection.dart';
import 'package:mcdmx/domain/stop.dart';

import 'station.dart';
import 'network.dart';
import 'heuristic.dart';

class AStar {
  final Network _network;
  final Heuristic _heuristic;

  AStar(this._network)
    : _heuristic = Heuristic(_network);

  PriorityQueue<({double h, double g, Stop stop})>
  _makeOpenSet() {
    return PriorityQueue((self, other) {
      final (h: hScoreA, g: gScoreA, stop: stopA) = self;
      final (h: hScoreB, g: gScoreB, stop: stopB) = other;

      if (_network.isAccesibleMode) {
        final cmpPrev = _accScore(stopA).compareTo(_accScore(stopB));

        if (cmpPrev != 0) {
          return cmpPrev;
        }
      }

      final fScoreA = gScoreA + hScoreA;
      final fScoreB = gScoreB + hScoreB;
      
      final cmpF = fScoreA.compareTo(fScoreB);

      if (cmpF != 0) {
        return cmpF;
      }

      return hScoreA.compareTo(hScoreB);
    });
  }

  ({double h, double g, Stop stop})
  _makeOpenSetEntry(Stop stop, Station stationDst, double gStop) {
      return (
        h: _heuristic.transferAware(stop, gStop, stationDst),
        g: gStop,
        stop: stop,
      );
  }

  int _accScore(Stop stop) {
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
      double h,
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
        .nextArrivalDuration(now)
        .inMinutes
        .toDouble();

      final entry = _makeOpenSetEntry(stop, stationDst, 0.0);

      openSet.add(entry);
    }

    do {
      final (h: _, g: gCurr, stop: curr) = openSet.removeFirst();

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
            .nextArrivalDuration(now.add(Duration(minutes: gNext.round())))
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
