import './arista.dart';
import './tren.dart';
import './nodo.dart';

class Linea {
    
    int number;
    List<Arista> recorrido;
    int frecuency; //Cada cuantos minutos sale un tren de la first estacion
    Nodo firstStation;
    int numberStations;
    Set<Tren> trains;
    

    Linea (this.number, this.recorrido, this.frecuency, this.firstStation, this.trains)
        : numberStations = recorrido.length;

    int getnumber (){
        return number;
    }

    List<Arista> getPath (){
        return recorrido;
    }

    int getfrecuency (){
        return frecuency;
    }

    Nodo getfirstStation (){
        return firstStation;
    }

    int getnumberStations (){
        return numberStations;
    }

    void mantainTrainsInMovement (){
        
    }

}
