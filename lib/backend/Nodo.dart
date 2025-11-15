import './Linea.dart';


class Nodo {

    String nombre;
    Map<Linea, int> lineas; //Un conjunto de lineas que tiene asociado el tiempo que se tarda andando en llegar

    Nodo (String nombre, Map<Linea, int> lineas){
        this.nombre = nombre;
        this.lineas = lineas;
    }

    String getNombre (){
        return this.nombre;
    }

    List<Linea> getLineas (){
        return this.lineas;
    }

/*
 *  Utilizo == puesto que en dart compara si dos objetos son iguales
 *  Dos string son iguales si contienen la misma secuencia de code units
*/
    boolean equals(Nodo nodo) {
        return this.nombre == nodo.nombre;
    }
}
