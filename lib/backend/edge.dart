import './stop.dart';

class Edge {
    final Stop _station1;
    final Stop _station2;
    final double _time;    // tiempo que se tarda en recorrerlo

    Edge (this._station1, this._station2, this._time);

    Stop adjacent(Stop station){
      if (station == _station1) return _station2;
      if (station == _station2) return _station1;
      
      throw Exception("Error: Se ha pedido la estación adyacente a ($station) en una arista a la que no pertenece");
    }

    double get time => _time;
}
