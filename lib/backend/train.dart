import 'dart:async';
import './edge.dart';
import './vertex.dart';


class Tren {
    
    Edge _currentPosition;
    Vertex _nextStation;
    final StreamController<String> controller = StreamController<String>();

    Tren (this._currentPosition, this._nextStation, int tiempo){
        //TODO que se hace con el tiempo?
    }
    
    Edge getcurrentPosition () => _currentPosition;

    Vertex getSiguienteEstacion () => _nextStation;

    /*
     *  Funcion que actualiza la arista en la que esta el tren
     *  y cambia la _nextStation, esta debe ser la siguiente de la _nextStation previa
     *  En caso de que la _nextStation previa no se encuentre en la nueva arista,
     *  la funcion _nextStation de Arista lanzara un error
    */
    void setNextPosition (Edge newPosition){
        _currentPosition = newPosition;
        _nextStation = _currentPosition.nextstation(_nextStation);
    }

    void goTonextStation (Edge newPosition){
       setNextPosition(newPosition);
       //TODO
       Timer(Duration(minutes: newPosition.gettime()), () {
        controller.add();
        });
    }
}
