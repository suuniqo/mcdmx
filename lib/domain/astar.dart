import 'package:collection/collection.dart';
import 'package:mcdmx/domain/edge.dart';
import 'package:mcdmx/domain/stop.dart';

import 'station.dart';
import 'network.dart';

class AStar {
  final Network _network;
  final double Function(Stop stop, int g, Station dst) _heuristic;

  AStar(this._network, this._heuristic);

  // Algoritmo para comparar dos entradas en el openSet
  // Se comparan los siguientes valores, con prioridad de mayor a menor:
  //
  // 1. Si el modo accesible está activado y es un transbordo
  //    según sea accesible o no
  //
  // 2. Según la función f
  //
  // 3. Según la función h, que es muy efectiva en caso
  //    de empates en la función f
  //
  PriorityQueue<({int acc, double h, int g, Stop stop})>
  _makeOpenSet() {
    return PriorityQueue((self, other) {
      final (acc: accA, h: hScoreA, g: gScoreA, stop: stopA) = self;
      final (acc: accB, h: hScoreB, g: gScoreB, stop: stopB) = other;

      if (_network.isAccesibleMode) {
        final cmpPrev = accA.compareTo(accB);

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

  ({int acc, double h, int g, Stop stop})
  _makeOpenSetEntry(int accStop, Stop stop, Station stationDst, int gStop) {
      return (
        acc: accStop,
        h: _heuristic(stop, gStop, stationDst),
        g: gStop,
        stop: stop,
      );
  }

  int _accScore(Edge edge) {
    if (!_network.isAccesibleMode) {
      return 0;
    }
    if (edge.first.station != edge.second.station) {
      return 0;
    }
    if (edge.first.station.accesible) {
      return 0;
    }
    return 1;
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

  (List<Station>, int)? calculateRoute(Station stationSrc, Station stationDst, DateTime now) {
    // Encontré una Priority Queue
    final PriorityQueue<({
      int acc,
      double h,
      int g,
      Stop stop
    })> openSet = _makeOpenSet();

    // Se almaneza g(Stop) por cada Stop visitado
    final Map<Stop, int> gScore = {};

    // En vez de usar el closedList, es más eficiente usar un mapa de antecesores
    final Map<Stop, Stop?> prev = {};

    // Como cada estación tiene múltiples paradas, se inicializa A* con orígenes múltiples
    for (final stop in _network.stationStops[stationSrc]!) {
      prev[stop] = null;

      // En la primera parada del trayecto el tiempo será
      // el tiempo de espera al siguiente metro
      final firstArrival = stop
        .nextArrivalDuration(now)
        .inMinutes;

      gScore[stop] = firstArrival;

      final entry = _makeOpenSetEntry(0, stop, stationDst, firstArrival);

      openSet.add(entry);
    }

    do {
      final (acc: _, h: _, g: gCurr, stop: curr) = openSet.removeFirst();

      if (gCurr > gScore[curr]!) {
        continue;
      }

      if (curr.station == stationDst) {
        return (_rebuildPath(prev, curr), gCurr);
      }

      for (final edge in _network.connections[curr]!) {
        final next = edge.opposite(curr)!;

        // tiempo a la parada anterior más tránsito a la siguiente
        // (este tránsito es en metro o andando si es un transbordo)
        var gNext = gCurr + edge.cost;

        // Si es un transbordo hay que sumar
        // al coste lo que tarda el próximo tren
        if (curr.station == next.station) {
          gNext += curr
            .nextArrivalDuration(now.add(Duration(minutes: gNext)))
            .inMinutes;
        }

        if (!gScore.containsKey(next) || gNext < gScore[next]!) {
          prev[next] = curr;
          gScore[next] = gNext;

          int accNext = _accScore(edge);

          final entry = _makeOpenSetEntry(accNext, next, stationDst, gNext);

          openSet.add(entry);
        }
      }
    } while (openSet.isNotEmpty);

    // Significa que la estación destino está 'desconectada' del origen
    // que no debería ser posible salvo errores en la definición
    return null;
  }

  (List<Station>, int, int)? calculateRouteBench(Station stationSrc, Station stationDst, DateTime now) {
    // Encontré una Priority Queue
    final PriorityQueue<({
      int acc,
      double h,
      int g,
      Stop stop
    })> openSet = _makeOpenSet();

    // Se almaneza g(Stop) por cada Stop visitado
    final Map<Stop, int> gScore = {};

    final Set<Stop> visited = {};

    // En vez de usar el closedList, es más eficiente usar un mapa de antecesores
    final Map<Stop, Stop?> prev = {};

    // Como cada estación tiene múltiples paradas, se inicializa A* con orígenes múltiples
    for (final stop in _network.stationStops[stationSrc]!) {
      prev[stop] = null;

      // En la primera parada del trayecto el tiempo será
      // el tiempo de espera al siguiente metro
      final firstArrival = stop
        .nextArrivalDuration(now)
        .inMinutes;

      gScore[stop] = firstArrival;

      final entry = _makeOpenSetEntry(0, stop, stationDst, firstArrival);

      openSet.add(entry);
    }

    do {
      final (acc: _, h: _, g: gCurr, stop: curr) = openSet.removeFirst();
      visited.add(curr);

      if (gCurr > gScore[curr]!) {
        continue;
      }

      if (curr.station == stationDst) {
        return (_rebuildPath(prev, curr), gCurr, visited.length);
      }

      for (final edge in _network.connections[curr]!) {
        final next = edge.opposite(curr)!;

        // tiempo a la parada anterior más tránsito a la siguiente
        // (este tránsito es en metro o andando si es un transbordo)
        var gNext = gCurr + edge.cost;

        // Si es un transbordo hay que sumar
        // al coste lo que tarda el próximo tren
        if (curr.station == next.station) {
          gNext += curr
            .nextArrivalDuration(now.add(Duration(minutes: gNext)))
            .inMinutes;
        }

        if (!gScore.containsKey(next) || gNext < gScore[next]!) {
          prev[next] = curr;
          gScore[next] = gNext;

          int accNext = _accScore(edge);

          final entry = _makeOpenSetEntry(accNext, next, stationDst, gNext);

          openSet.add(entry);
        }
      }
    } while (openSet.isNotEmpty);

    // Significa que la estación destino está 'desconectada' del origen
    // que no debería ser posible salvo errores en la definición
    return null;
  }
}
