import 'package:mcdmx/backend/edge.dart';

import './line.dart';


class Vertex {

    final String _name;
    final (double x, double y) _coordenates;   //Estructura record, como una tupla pero con lo que quieras dentro
    final Map<Line, int> _lines; //Un conjunto de lineas que tiene asociado el tiempo que se tarda andando en llegar
    final Set<Edge> _conexions;

    Vertex (this._name, this._coordenates, this._lines, this._conexions);

    String getname (){
        return _name;
    }

    Map<Line, int> getlines (){
        return _lines;
    }

    (double x, double y) getcoordenates (){
        return _coordenates; 
    }

/*
 *  Utilizo == puesto que en dart compara si dos objetos son iguales
 *  Dos string son iguales si contienen la misma secuencia de code units
*/
    bool equals(Vertex vertex) {
        return _name == vertex.getname();
    }

    Set<Edge> getconexions() {
        return _conexions;
    }
}
