import './edge.dart';
import './vertex.dart';

class Line {
    
    final int _number;
    final List<Edge> _path;
    final int _frecuency; //Cada cuantos minutos sale un tren de la first estacion
    final Vertex _firstStation;
    final Vertex _lastStation;
    final int _numberStations;
    final int _openHour;
    final int _closingHour;
    

    Line (this._number, this._path, this._frecuency, this._firstStation, this._lastStation, this._openHour, this._closingHour)
        : _numberStations = _path.length;

    int getnumber() => _number;
    

    List<Edge> getPath () => _path;
    

    int getfrecuency () => _frecuency;
    

    Vertex getfirstStation () => _firstStation;
    

    int getnumberStations () => _numberStations;
    
    bool containsConexion (Edge conexion){
        return _path.contains(conexion);
    }

//Stop = Vertex no me acuerdo como lo llamabamos
    //Funcion que devuelve las paradas de la linea en orden
    //La clase line cambia a lista de estaciones, pero por si lo quieres
    List<Vertex> get_stops (){
        List<Vertex> stops = List.empty();
        Vertex station = _firstStation;
        stops.add(station);
        for (Edge edge in _path){
          station = edge.nextstation(station);
          stops.add(station);
        }
        return stops;
    }
    
    /*
     *  Funcion que te devuelve cuanto le queda al siguiente tren
     *  El parametro direccion es true si la direccion es de la first_station hasta el final
     * , false en caso contrario 
    */
    double time_for_next_train (Vertex station, bool direction){
      double minutes = (DateTime.now().hour - _openHour)*60;
      Vertex stationBeing = direction ? _firstStation : _lastStation;
      int i = direction ? 0 : _path.length - 1;
      int next = direction ? 1 : -1;
      while(!(stationBeing == station)){
          stationBeing = _path.elementAt(i).nextstation(stationBeing);
          minutes += _path.elementAt(i).gettime();
          i += next;
        }
      return minutes % _frecuency;
    }
}
}
