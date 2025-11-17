import './nodo.dart';

class Arista {

    Nodo estacion1;
    Nodo estacion2;
    int tiempo;    //Tiempo que se tarda en recorrerlo

    Arista (Nodo estacion1, Nodo estacion2, int tiempo){
        this.estacion1 = estacion1;
        this.estacion2 = estacion2;
        this.tiempo = tiempo;
    }

    Nodo siguienteEstacion (Nodo estacion){
        if (estacion1.equals(estacion))
            return this.estacion2;
        else if (estacion2.equals(estacion))
            return this.estacion1;
        throw Exception("Error: Se ha pedido la siguiente estacion de ($estacion) un nodo que no se encuentra en la arista");
    }

    int getTiempo (){
        return this.tiempo;
    }

}
