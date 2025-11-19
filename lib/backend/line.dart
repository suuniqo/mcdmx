import './edge.dart';
import './train.dart';
import './vertex.dart';

class Line {
    
    final int _number;
    final List<Edge> _recorrido;
    final int _frecuency; //Cada cuantos minutos sale un tren de la first estacion
    final Vertex _firstStation;
    final int _numberStations;
    final Set<Tren> trains;
    

    Line (this._number, this._recorrido, this._frecuency, this._firstStation, this.trains)
        : _numberStations = _recorrido.length;

    int getnumber() => _number;
    

    List<Edge> getPath () => _recorrido;
    

    int getfrecuency () => _frecuency;
    

    Vertex getfirstStation () => _firstStation;
    

    int getnumberStations () => _numberStations;
    

    //TODO
    void mantainTrainsInMovement (){
        
    }
}
