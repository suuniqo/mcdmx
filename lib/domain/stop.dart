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
}
