import 'dart:math';

import 'package:latlong2/latlong.dart';
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
   * - En otro caso:
   *   T_min * N_min
   */
  double transferAware(Stop curr, int gScore, Station dst, double m, double p, double q) {
    double euclideanScore = slt(curr, dst);
    double transferPenalty = _networkTransferPenalty(curr, gScore, dst);

    return m * (p * euclideanScore + q * transferPenalty);
  }

  // Se calcula la penalización
  double _networkTransferPenalty(Stop curr, int gScore, Station dst) {
    // Se comprueba si nos encontramos en el mejor caso,
    // ya estamos en una línea que pasa por dst
    final linesDst = dst.lines;

    if (linesDst.contains(curr.line) && curr.isFollowingStation(dst)) {
      // No hay penalización
      return 0;
    }

    // Peor caso, no estás en ninguna línea que pase por dst
    // y en la estación actual tampoco hay transbordo a ninguna
    int? minNumTransfers;

    for (final line in linesDst) {
      final numTransfers = _network.minTransfers(curr, line)!;
      if (minNumTransfers == null || numTransfers < minNumTransfers) {
        minNumTransfers = numTransfers;
      }
    }

    // En este caso el mínimo tiempo de espera al siguiente metro es 0,
    // luego sólo se multiplica por el mínimo tiempo de andar el transbordo
    return (minNumTransfers! * _network.minTransferTime!).toDouble();
  }

  /*
   *  Función auxiliar que calcula la norma euclidia. Para ello hay que tener en cuenta que estamos en latitud y longitud
   *  Y usamos una converssion a km aproximando usando que estamos una escala "pequeña"
   */
  static double _norm(Station station1, Station station2) {
    LatLng coords1 = station1.coords;
    LatLng coords2 = station2.coords;

    double dLat = coords1.latitude - coords2.latitude;
    double dLong = coords1.longitude - coords2.longitude;

    // Correccion de la longitud en funcion de la latitud
    dLong *= cos((coords1.latitude + coords2.latitude) / 2 * (pi / 180));
    return _conversionKm * sqrt(dLat * dLat + dLong * dLong);
  }
}
