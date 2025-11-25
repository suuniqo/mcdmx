import 'edge.dart';

import './line.dart';


class Vertex {

    final String _name;
    final (double x, double y) _coordenates;   //Estructura record, como una tupla pero con lo que quieras dentro
    final Map<Line, int> _lines; //Un conjunto de lineas que tiene asociado el tiempo que se tarda andando en llegar
    final Set<Edge> _conexions;
    final bool _accessibility_friendly;

    Vertex (this._name, this._coordenates, this._lines, this._conexions, this._accessibility_friendly);

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
