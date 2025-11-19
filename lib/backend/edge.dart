import './vertex.dart';

class Edge {

    final Vertex _station1;
    final Vertex _station2;
    final int _time;    //time que se tarda en recorrerlo

    Edge (this._station1, this._station2, this._time);

    Vertex nextstation(Vertex estacion){
        if (_station1.equals(estacion)){
            return _station2;

        }
        else if (_station2.equals(estacion)){
            return _station1;
    }
        throw Exception("Error: Se ha pedido la siguiente estacion de ($estacion) un nodo que no se encuentra en la arista");
    }

    int gettime () => _time;
}
