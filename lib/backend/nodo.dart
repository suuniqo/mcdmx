import './linea.dart';


class Nodo {

    String name;
    (double x, double y) cordenates;   //Estructura record, como una tupla pero con lo que quieras dentro
    Map<Linea, int> lines; //Un conjunto de lineas que tiene asociado el tiempo que se tarda andando en llegar

    Nodo (this.name, this.cordenates, this.lines);

    String getname (){
        return name;
    }

    Map<Linea, int> getlines (){
        return lines;
    }

    (double x, double y) getcordenates (){
        return cordenates; 
    }

/*
 *  Utilizo == puesto que en dart compara si dos objetos son iguales
 *  Dos string son iguales si contienen la misma secuencia de code units
*/
    bool equals(Nodo nodo) {
        return name == nodo.name;
    }
}
