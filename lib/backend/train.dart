import 'dart:async';
import './edge.dart';
import './vertex.dart';


class Tren {
    
    Edge currentPosition;
    Vertex nextStation;
    final StreamController<String> controller = StreamController<String>();

    Tren (this.currentPosition, this.nextStation, int tiempo){
        //TODO que se hace con el tiempo?
    }
    
    Edge getcurrentPosition (){
        return currentPosition;
    }

    Vertex getSiguienteEstacion (){
        return nextStation;
    }

    /*
     *  Funcion que actualiza la arista en la que esta el tren
     *  y cambia la nextStation, esta debe ser la siguiente de la nextStation previa
     *  En caso de que la nextStation previa no se encuentre en la nueva arista,
     *  la funcion nextStation de Arista lanzara un error
    */
    void setNextPosition (Edge newPosition){
        currentPosition = newPosition;
        nextStation = currentPosition.nextStation(nextStation);
    }

    void goToNextStation (Edge newPosition){
       setNextPosition(newPosition);
       //TODO
       Timer(Duration(minutes: newPosition.gettime()), () {
        controller.add();
        });
    }
}
