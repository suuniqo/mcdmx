import 'dart:math';
import './nodo.dart';

class Heuristica {
    
    //La velocidad programada del tren es 36km/h, aunque luego se haya
    //registrado que de media es menos
    static double trainVelocity = 600; //metros por minuto

    /*
     *  Utilizada la norma al cuadrado 
     */
    static double norma (Nodo station1, Nodo station2){
        (double x, double y) cordenates1 = station1.getcordenates();
        (double x, double y) cordenates2 = station2.getcordenates();
        double diferenciaX = cordenates1.$1 - cordenates2.$1;
        double diferenciaY = cordenates1.$2 - cordenates2.$2;
        return diferenciaX*diferenciaX + diferenciaY*diferenciaY; 
    }

    /*
     *  Pendiente a revisar, pues hay que ver si la norma, que es la euclidia
     *  da buenos resultados
     *  La euristica es minorante. Se dara el caso de que haya que cambiar 
     *  linea y no cambiar la estacion, la euristica sera la misma, pero 
     *  el coste del camino aumentara
     */
    static double heuristic (Nodo station1, Nodo station2){
        //TODO hacer la funcion de la norma
        double norma = norm(station1, station2);
        return sqrt(norma) * trainVelocity;
    }
}
