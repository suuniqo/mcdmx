import 'dart:math';
import './nodo.dart';

class Heuristica {
    
    //La velocidad programada del tren es 36km/h, aunque luego se haya
    //registrado que de media es menos
    static double velocidadTren = 600; //metros por minuto

    /*
     *  Utilizada la norma al cuadrado 
     */
    static double norma (Nodo estacion1, Nodo estacion2){
        (double x, double y) coordenadas1 = estacion1.getCoordenadas();
        (double x, double y) coordenadas2 = estacion2.getCoordenadas();
        double diferenciaX = coordenadas1.x - coordenadas2.x;
        double diferenciaY = coordenadas1.y - coordenadas2.y;
        return diferenciaX*diferenciaX + diferenciaY*diferenciaY; 
    }

    /*
     *  Pendiente a revisar, pues hay que ver si la norma, que es la euclidia
     *  da buenos resultados
     *  La euristica es minorante. Se dara el caso de que haya que cambiar 
     *  linea y no cambiar la estacion, la euristica sera la misma, pero 
     *  el coste del camino aumentara
     */
    static double heuristica (Nodo estacion1, Nodo estacion2){
        double norma = norma(estacion1, estacion2);
        return sqrt(norma) * velocidadTren;
    }
}
