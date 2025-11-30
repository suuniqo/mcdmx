import 'package:mcdmx/domain/line.dart';
import 'package:mcdmx/domain/station.dart';

class Stop {
  final Direction _direction;
  final Station _station;

  Stop(this._direction, this._station);

  Line get line => _direction.line;
  Direction get direction => _direction;
  Station get station => _station;
  int get lineIndex => _direction.stationIndex(station)!;

  // calcula si la estación provista
  // es una de las siguientes estaciones
  // si se permanece en la dirección de la parada
  bool isFollowingStation(Station station) {
    return _direction.isFollowingStation(_station, station);
  }

  // calcula cuanto tarda en llegar el siguiente tren
  // a esta parada a la hora time
  Duration nextArrivalDuration(DateTime time) {
    return _direction.nextArrivalDuration(_station, time);
  }
  
  @override
  String toString() {
    return "Stop(${_station.name}, ${_direction.line.number}, ${_direction.name})";
  }
}
