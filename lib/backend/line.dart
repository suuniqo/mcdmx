import './edge.dart';
import './train.dart';
import './vertex.dart';

class Line {
    
    int number;
    List<Edge> recorrido;
    int frecuency; //Cada cuantos minutos sale un tren de la first estacion
    Vertex firstStation;
    int numberStations;
    Set<Tren> trains;
    

    Line (this.number, this.recorrido, this.frecuency, this.firstStation, this.trains)
        : numberStations = recorrido.length;

    int getnumber (){
        return number;
    }

    List<Edge> getPath (){
        return recorrido;
    }

    int getfrecuency (){
        return frecuency;
    }

    Vertex getfirstStation (){
        return firstStation;
    }

    int getnumberStations (){
        return numberStations;
    }

    void mantainTrainsInMovement (){
        
    }

}
