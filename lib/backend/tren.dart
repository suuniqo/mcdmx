import 'dart:async';
import './arista.dart';
import './nodo.dart';


class Tren {
    
    Arista currentPosition;
    Nodo nextStation;
    final StreamController<String> controller = StreamController<String>();

    Tren (this.currentPosition, this.nextStation, int tiempo){
        //TODO que se hace con el tiempo?
    }
    
    Arista getcurrentPosition (){
        return currentPosition;
    }

    Nodo getSiguienteEstacion (){
        return nextStation;
    }

    /*
     *  Funcion que actualiza la arista en la que esta el tren
     *  y cambia la nextStation, esta debe ser la siguiente de la nextStation previa
     *  En caso de que la nextStation previa no se encuentre en la nueva arista,
     *  la funcion nextStation de Arista lanzara un error
    */
    void setNextPosition (Arista newPosition){
        currentPosition = newPosition;
        nextStation = currentPosition.nextStation(nextStation);
    }

    void goToNextStation (Arista newPosition){
       setNextPosition(newPosition);
       //TODO
       Timer(Duration(minutes: newPosition.gettime()), () {
        controller.add();
        });
    }
}
