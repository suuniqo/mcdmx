import './edge.dart';
import './vertex.dart';
import './trainMap.dart';
import 'heuristic.dart';
import 'path.dart';


class Astar {
    final TrainMap _map;

    Astar(this._map);
        
    Path calculateRoute(Vertex begin, Vertex end){
      Vertex stationBeing = begin;

      /*  Desgraciadamente no existian las priorityQueue
       *  Lista con las estaciones a las estaciones que no todavia no se puede asegurar que se 
       *  ha llegado con el mejor tiempo, la primera estacion si
       */
      final List<({Vertex station, double f})> openList = List.empty(); 
      //Set con las estaciones a las que se ha llegado con el camino optimo
      final Set<Vertex> closedList = Set<Vertex>();
      /*  Map que es un arbol, cada key es un vertice y el value es la arista para llegar a su padre
       *  No contiene a la raiz (begin), luego se conseguira el path recorriendo hacia atras el arbol
       *  y terminando cuando el padre de uno sea begin(no cuando la key sea begin)
       */
      final Map<Vertex, ({Edge toFather, double f})> treeMap = {};
    
      do{
          final Set<Edge> conexions = stationBeing.getconexions();
          //Meto en la openList las nuevas estaciones y mejores caminos
          for(Edge conexion in conexions){
              Vertex nextStation = conexion.nextstation(stationBeing);
              if (!closedList.contains(nextStation)){
                  _addOpenList(stationBeing, nextStation, conexion, end, treeMap, closedList, openList);
              }
          }
      //Saco de la openList y meto en la closedList
      //Hay removeLast pero no removeFirst, muy raro
      closedList.add(openList.removeAt(0).station);

      //No compruebo si la lista esta vacia, no deberia pasar, pero estaria bien ponerlo
      //Sigo hasta que el primer elemento de la openList sea end(se ha conseguido el camino optimo)
      }while(!openList.elementAt(0).station.equals(end));

       Path path = Path(begin);
       //Si he llegado aqui supongo que he encontrado la meta, luego treeMap[] no puede dar null
       Vertex cursor = end;
       while(!cursor.equals(begin)){
          Edge nextEdge = treeMap[cursor]!.toFather;
          path.insertStation(nextEdge);
          cursor = nextEdge.nextstation(cursor);
       }
       return path;
    }
    
    /*
     *  Funcion para insertar en la posicion correcta de la openList
     *  Complejidad alta, ver si se puede reducir la complejidad
     */
     static void _insertOpenList(({Vertex station, double f}) station, List<({Vertex station, double f})> openList){
        int i;
        for(i = 0 ; i < openList.length && openList[i].f < station.f ; i++);
        //Ver que se puede insertar en openList.length
        openList.insert(i, station);
     }

    /*
     *  Funcion para ver si meterlo o no en la pila
     */
    static void _addOpenList (Vertex stationBeing, Vertex nextStation, Edge edge, Vertex end, Map<Vertex, ({Edge toFather, double f})> treeMap, Set<Vertex> closedList, List<({Vertex station, double f})> openList){
        double newf = _calculatef (stationBeing, edge, end);
        if(!treeMap.containsKey(nextStation)){
            _insertOpenList((station: nextStation, f: newf), openList); 
            treeMap[nextStation] = (toFather: edge, f: newf);
        }
        else {
            //Estoy seguro de que aqui no es null (utilizo !) porque si es null, entraria en el if
            double oldf = treeMap[nextStation]!.f;
            if(oldf > newf){
                openList.remove((station: nextStation, f: oldf));
                _insertOpenList((station: nextStation, f: newf), openList); 
                treeMap[nextStation] = (toFather: edge, f: newf);
            }
        }
    }


    static double _calculatef(Vertex stationBeing, Edge candidate, Vertex end){
        double g = candidate.gettime();
        double h = Heuristic.heuristic(stationBeing, end);
        return g + h;
    }
}
