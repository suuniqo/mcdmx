import './stop.dart';

class Edge {
  final Stop _stopFirst;
  final Stop _stopSecond;
  final int _cost; // tiempo que se tarda en recorrerlo en minutos

  Edge(this._stopFirst, this._stopSecond, this._cost);

  Stop? opposite(Stop station) {
    if (station == _stopFirst) return _stopSecond;
    if (station == _stopSecond) return _stopFirst;

    return null;
  }

  bool get isTransfer => _stopFirst.station == _stopSecond.station;

  int get cost => _cost;

  Stop get first => _stopFirst;
  Stop get second => _stopSecond;
}
