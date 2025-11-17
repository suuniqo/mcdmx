import './nodo.dart';

class Arista {

    Nodo station1;
    Nodo station2;
    int time;    //time que se tarda en recorrerlo

    Arista (this.station1, this.station2, this.time);

    Nodo nextStation(Nodo estacion){
        if (station1.equals(estacion)){
            return station2;

        }
        else if (station2.equals(estacion)){
            return station1;
    }
        throw Exception("Error: Se ha pedido la siguiente estacion de ($estacion) un nodo que no se encuentra en la arista");
    }

    int gettime (){
        return time;
    }

}
