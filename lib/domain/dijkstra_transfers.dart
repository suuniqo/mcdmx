import 'package:collection/collection.dart';
import 'package:mcdmx/domain/line.dart';

import 'package:mcdmx/domain/network.dart';
import 'package:mcdmx/domain/stop.dart';

class DijkstraTransfers {
  final Network _network;

  DijkstraTransfers(this._network);

  Map<Line, int> minTransfers(Stop stop) {
    // Encontré una Priority Queue
    final PriorityQueue<({int cost, Stop stop})>
    heap = PriorityQueue((a, b) => a.cost.compareTo(b.cost));

    // Mínimo coste encontrado de momento
    final Map<Stop, int> cost = {};

    // Número mínimo de transbordos a cada línea
    final Map<Line, int> transfers = {};

    // Se inicializa el heap y el mapa de costes
    cost[stop] = 0;
    transfers[stop.line] = 0;
    heap.add((cost: 0, stop: stop));

    do {
      final (cost: costCurr, stop: curr) = heap.removeFirst();

      if (costCurr > cost[curr]!) {
        continue;
      }

      for (final edge in _network.connections[curr]!) {
        final next = edge.opposite(curr)!;

        // La puntuación es en base de transbordos,
        // ya que es lo que se trata de minimizar
        final costTransfer = edge.isTransfer ? 1 : 0;
        final costNext = costCurr + costTransfer;

        if (!cost.containsKey(next) || costNext < cost[next]!) {
          cost[next] = costNext;

          if (!transfers.containsKey(next.line) || costNext < transfers[next.line]!) {
            transfers[next.line] = costNext;
          }

          heap.add((cost: costNext, stop: next));
        }
      }
    } while (heap.isNotEmpty);

    return transfers;
  }
}
