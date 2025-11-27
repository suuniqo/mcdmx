import 'edge.dart';
import 'station.dart';
import 'network.dart';
import 'heuristic.dart';

class Astar {
  final Network _map;

  Astar(this._map);

  List<Station> calculateRoute(Station begin, Station end) {
    Station stationBeing = begin;

    /*  Desgraciadamente no existian las priorityQueue
       *  Lista con las estaciones a las estaciones que no todavia no se puede asegurar que se 
       *  ha llegado con el mejor tiempo, la primera estacion si
       */
    final List<({Station station, double f})> openList = List.empty();
    //Set con las estaciones a las que se ha llegado con el camino optimo
    final Set<Station> closedList = Set<Station>();
    /*  Map que es un arbol, cada key es un vertice y el value es la arista para llegar a su padre
       *  No contiene a la raiz (begin), luego se conseguira el path recorriendo hacia atras el arbol
       *  y terminando cuando el padre de uno sea begin(no cuando la key sea begin)
       */
    final Map<Station, ({Edge toFather, double f})> treeMap = {};

    do {
      //Toda estacion tiene conexiones, luego utilizo el !
      final Set<Edge> conexions = _map.connections[stationBeing]!;
      //Meto en la openList las nuevas estaciones y mejores caminos
      for (Edge conexion in conexions) {
        Station nextStation = conexion.adjacent(stationBeing);
        if (!closedList.contains(nextStation)) {
          _addOpenList(
            stationBeing,
            nextStation,
            conexion,
            end,
            treeMap,
            closedList,
            openList,
          );
        }
      }
      //Saco de la openList y meto en la closedList
      //Hay removeLast pero no removeFirst, muy raro
      closedList.add(openList.removeAt(0).station);

      /*  No compruebo si la lista esta vacia, no deberia pasar, pero estaria bien ponerlo
      *   Sigo hasta que el primer elemento de la openList sea end(se ha conseguido el camino optimo)
      *   Dos estaciones son iguales si comparten el nombre
      */
    } while (!(openList.elementAt(0).station.name == end.name));

    List<Station> path = List.empty();
    path.insert(0, begin);
    //Si he llegado aqui supongo que he encontrado la meta, luego treeMap[] no puede dar null
    Station cursor = end;
    while (!(cursor.name == begin.name)) {
      path.insert(1, cursor);
      Edge nextEdge = treeMap[cursor]!.toFather;
      cursor = nextEdge.adjacent(cursor);
    }
    return path;
  }

  /*
     *  Funcion para insertar en la posicion correcta de la openList
     *  Complejidad alta, ver si se puede reducir la complejidad
     */
  static void _insertOpenList(
    ({Station station, double f}) station,
    List<({Station station, double f})> openList,
  ) {
    int i;
    for (i = 0; i < openList.length && openList[i].f < station.f; i++) ;
    //Ver que se puede insertar en openList.length
    openList.insert(i, station);
  }

  /*
     *  Funcion para ver si meterlo o no en la pila
     */
  static void _addOpenList(
    Station stationBeing,
    Station nextStation,
    Edge edge,
    Station end,
    Map<Station, ({Edge toFather, double f})> treeMap,
    Set<Station> closedList,
    List<({Station station, double f})> openList,
  ) {
    double newf = _calculatef(stationBeing, edge, end);
    if (!treeMap.containsKey(nextStation)) {
      _insertOpenList((station: nextStation, f: newf), openList);
      treeMap[nextStation] = (toFather: edge, f: newf);
    } else {
      //Estoy seguro de que aqui no es null (utilizo !) porque si es null, entraria en el if
      double oldf = treeMap[nextStation]!.f;
      if (oldf > newf) {
        openList.remove((station: nextStation, f: oldf));
        _insertOpenList((station: nextStation, f: newf), openList);
        treeMap[nextStation] = (toFather: edge, f: newf);
      }
    }
  }

  static double _calculatef(Station stationBeing, Edge candidate, Station end) {
    double g = candidate.time;
    double h = Heuristic.heuristic(stationBeing, end);
    return g + h;
  }
}
