import 'dart:math';

import 'station.dart';
import 'stop.dart';

class Heuristic {
  // La velocidad programada del tren es 36 km/h, 
  // aunque luego se haya registrado que de media es menos
  static const double trainVelocity = 600; //metros por minuto

  // Factor de conversión aproximado: 1 grado ≈ 111 km (111,000 metros)
  static const double conversionKm = 111000.0;

  /*
   *  La euristica es minorante. Se dara el caso de que haya que cambiar 
   *  linea y no cambiar la estacion, la euristica sera la misma, pero 
   *  el coste del camino aumentara
   */
  static double hScore(Stop curr, Station dst) {
    // TODO: Sumarle la penalización de transbordo
    double norma = _norm(curr.station, dst);
    return norma / trainVelocity;
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
    return conversionKm * sqrt(dLat * dLat + dLong * dLong);
  }
}
