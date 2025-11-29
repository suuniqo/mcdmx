import 'dart:math';

import 'package:mcdmx/domain/network.dart';

import 'station.dart';
import 'stop.dart';

class Heuristic {
  final Network _network;

  Heuristic(this._network);

  // Factor de conversión aproximado: 1 grado ≈ 111 km (111,000 metros)
  static const double _conversionKm = 111000.0;

  // Straight Line Time: iendo en línea recta a la velocidad máxima de tren
  static double slt(Stop curr, Station dst) {
    return _norm(curr.station, dst) / Network.trainVelocity;
  }

  /*
   * Esta heurística suma a la euclidea (SLT), una penalización por transbordos.
   * Sumar esto no hace que deje de ser minorante ya que la distancia del transbordo
   * aunque sea en la misma dirección que el destino, es insignificante respecto a la
   * distancia restante, además de que en otros casos podrá ser en sentido contrario,
   * por lo que es difícil que tengan una suma constructiva.
   * 
   * Sean:
   * - T_min = min(tiempo transbordo a las líneas que pasan por el destino)
   * - N_min = min(número de transbordos para llegar a una línea que pasa por el destino)
   *
   * La penalización es la siguiente:
   *
   * - Si ya estás en una línea que pasa por el destino y vas en sentido correcto:
   *   0
   *
   * - Si estás en una parada con uno o más transbordos a una línea que pasa por el destino:
   *   T_min
   * 
   * - En otro caso:
   *   T_min * N_min
   */
  double transferAware(Stop curr, double gScore, Station dst) {
    double euclideanScore = slt(curr, dst);
    double transferPenalty = _networkTransferPenalty(curr, gScore, dst);

    return euclideanScore + transferPenalty;
  }

  // Se calcula la penalización
  double _networkTransferPenalty(Stop curr, double gScore, Station dst) {
    // Se comprueba si nos encontramos en el mejor caso,
    // ya estamos en una línea que pasa por dst
    final linesDst = dst.lines;

    if (linesDst.contains(curr.line) && curr.isFollowingStation(dst)) {
      // No hay penalización
      return 0;
    }

    // El siguiente mejor caso es que se pueda hacer un transbordo a una línea que pasa por dst
    final linesCurr = curr.station.lines;

    final linesBoth = linesDst.intersection(linesCurr);

    if (linesBoth.isNotEmpty) {
      // La penalización es el tiempo mínimo de transbordo + el tiempo mínimo de espera
      // Esta penalización se puede calcular con exactitud
      var minPenalty = double.infinity;

      for (final line in linesBoth) {
        final edge = _network.pathToLine(curr, line)!;

        final walkCost = edge.cost;

        final waitTime = DateTime.now()
          .add(Duration(minutes: (gScore + walkCost).round()));

        final waitCost = edge
          .opposite(curr)!
          .nextArrivalDuration(waitTime)
          .inMinutes;

        final transferCost = walkCost + waitCost;

        minPenalty = minPenalty < transferCost
         ? minPenalty
         : transferCost;
      }

      return minPenalty;
    }

    // Peor caso, no estás en ninguna línea que pase por dst
    // y en la estación actual tampoco hay transbordo a ninguna
    int? minNumTransfers;

    for (final line in linesDst) {
      final numTransfers = _network.minTransfers(curr.line, line);
      if (minNumTransfers == null || numTransfers < minNumTransfers) {
        minNumTransfers = numTransfers;
      }
    }

    // En este caso el mínimo tiempo de espera al siguiente metro es 0,
    // luego sólo se multiplica por el mínimo tiempo de andar el transbordo
    return (minNumTransfers! * _network.minTransferTime).toDouble();
  }

  /*
   *  Función auxiliar que calcula la norma euclidia. Para ello hay que tener en cuenta que estamos en latitud y longitud
   *  Y usamos una converssion a km aproximando usando que estamos una escala "pequeña"
   */
  static double _norm(Station station1, Station station2) {
    (double x, double y) cordenates1 = station1.coordinates;
    (double x, double y) cordenates2 = station2.coordinates;

    double dLat = cordenates1.$1 - cordenates2.$1;
    double dLong = cordenates1.$2 - cordenates2.$2;

    // Correccion de la longitud en funcion de la latitud
    dLong *= cos((cordenates1.$1 + cordenates2.$1) / 2 * (pi / 180));
    return _conversionKm * sqrt(dLat * dLat + dLong * dLong);
  }
}
