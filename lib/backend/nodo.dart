import './linea.dart';


class Nodo {

    String nombre;
    (double x, double y) coordenadas;   //Estructura record, como una tupla pero con lo que quieras dentro
    Map<Linea, int> lineas; //Un conjunto de lineas que tiene asociado el tiempo que se tarda andando en llegar

    Nodo (String nombre, (double, double) coordenadas, Map<Linea, int> lineas){
        this.nombre = nombre;
        this.lineas = lineas;
        this.coordenadas = cordenadas;
    }

    String getNombre (){
        return this.nombre;
    }

    List<Linea> getLineas (){
        return this.lineas;
    }

    (double x, double y) getCoordenadas (){
        return this.coordenadas; 
    }

/*
 *  Utilizo == puesto que en dart compara si dos objetos son iguales
 *  Dos string son iguales si contienen la misma secuencia de code units
*/
    boolean equals(Nodo nodo) {
        return this.nombre == nodo.nombre;
    }
}
