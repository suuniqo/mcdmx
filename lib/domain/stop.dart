import 'line.dart';
import 'station.dart';

class Stop {
    final String _name;
    final Line _line;
    final Station _station;

    Stop(this._name, this._line, this._station);

    String get name => _name;
    Line get line => _line;
    Station get station => _station;


    /*
     *  Utilizo == puesto que en dart compara si dos objetos son iguales
     *  Dos string son iguales si contienen la misma secuencia de code units
     */
    @override
    bool operator ==(Object other) {
      return identical(this, other)
        || other is Stop
        && other._name == _name
        && other._station == _station;
    }

    @override
    int get hashCode => Object.hash(_name, _line, _station);
}
