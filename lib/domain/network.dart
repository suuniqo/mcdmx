import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mcdmx/domain/astar.dart';
import 'package:mcdmx/domain/dijkstra_transfers.dart';
import 'package:mcdmx/domain/heuristic.dart';


import './line.dart';
import './station.dart';
import './stop.dart';
import './edge.dart';

class Network {
  final List<Line> _lines;
  final List<Station> _stations;

  final Map<Stop, Set<Edge>> _connections;
  final Map<Station, Set<Stop>> _stationStops;
  final Map<({Stop stop, Line line}), int> _minTransfers = {};

  // Horarios de apertura oficiales
  static const TimeOfDay _openingTimeReg = TimeOfDay(hour: 5, minute: 0);
  static const TimeOfDay _openingTimeSat = TimeOfDay(hour: 6, minute: 0);
  static const TimeOfDay _openingTimeSun = TimeOfDay(hour: 7, minute: 0);
  static const TimeOfDay _closingTime    = TimeOfDay(hour: 0, minute: 0);

  // La velocidad programada del tren es 36 km/h,
  // aunque luego se haya registrado que de media es menos
  static const double trainVelocity = 600.0; // metros por minuto

  // No es accesible por defecto
  static const bool accesibleModeDefault = false;

  // Mínimo tiempo que se tarda en hacer un transbordo andando
  int? _minTransferTime;

  bool _isAccesibleMode = accesibleModeDefault;

  Network(this._lines, this._stations, this._connections, this._stationStops) {
    for (final line in _lines) {
      line.addNetwork(this);
    }
  }

  Iterable<Line> get lines => _lines;
  Iterable<Station> get stations => _stations;

  bool get isAccesibleMode => _isAccesibleMode;
  int? get minTransferTime => _minTransferTime;

  Map<Stop, Set<Edge>> get connections => _connections;
  Map<Station, Set<Stop>> get stationStops => _stationStops;

  TimeOfDay get closingTime => _closingTime;

  TimeOfDay openingTime(DateTime day) {
    var weekday = day.weekday;

    if (weekday == 7) {
      return _openingTimeSun;
    }
    if (weekday == 6) {
      return _openingTimeSat;
    }

    return _openingTimeReg;
  }

  // Si es posible, retorna la arista
  // de la parada src que te lleva a una
  // parada de la línea line
  Edge? pathToLine(Stop src, Line line) {
    for (final edge in _connections[src]!) {
      if (edge.opposite(src)!.line == line) {
        return edge;
      }
    }
    return null;
  }

  int? minTransfers(Stop stop, Line line) {
    return _minTransfers[(stop: stop, line: line)];
  }

  void computeMinTransfers() {
    final dijkstra = DijkstraTransfers(this);

    for (final stop in _connections.keys) {
      final minTransfersStop = dijkstra.minTransfers(stop);

      for (final line in _lines) {
        _minTransfers[(line: line, stop: stop)] = minTransfersStop[line]!;
      }
    }
  }

  void addMinTransferTime(int minTransferTime) {
    if (_minTransferTime != null) {
      throw Exception("Se intentó añadir dos veces el tiempo mínimo de transbordo");
    }

    _minTransferTime = minTransferTime;
  }

  // Interruptor para el modo accesible
  void toggleAccesibleMode() {
    _isAccesibleMode = !_isAccesibleMode;
  }

  void benchmarkAStar() {
    for (final h in [7, 17]) {
      DateTime now = DateTime.now().copyWith(hour: h, minute: 0, second: 0);

      for (double m = 0.00; m <= 2.50 + 0.01; m += 0.25) {
        for (double p = 0.00; p <= 2.50 + 0.01; p += 0.25) {
          for (double q = 0.00; q <= 2.50 + 0.01; q += 0.25) {

            var astar = AStar(this, (stop, g, dst) => Heuristic(this).transferAware(stop, g, dst, m, p, q));

            int score = 0;
            int branching = 0;

            for (int i = 0; i < _stations.length; ++i) {
              for (int j = i + 1; j < _stations.length; ++j) {
                var (_, dist, branch) = astar.calculateRoute(_stations[i], _stations[j], now)!;

                score += dist;
                branching += branch;
              }
            }
            print("heuristic(h: $h, m: ${m.toStringAsFixed(2)}, p: ${p.toStringAsFixed(2)}, q: ${q.toStringAsFixed(2)}) => score(time: $score, branching: $branching)");
          }
        }
      }
    }
  }

  factory Network.empty() {
    return Network([], [], {}, {});
  }

  Network.isolated(this._lines, this._stations)
    : _connections = {},
      _stationStops = {}
  {
    for (final line in _lines) {
      line.addNetwork(this);
    }
  }


  factory Network.fromJson(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);

    //Parseamos estaciones
    final Map<String, Station> stationsByID = {};
    (data['estaciones'] as Map<String, dynamic>).forEach((key, json) {
        final coordsList = List<dynamic>.from(json['coordenadas']);

        stationsByID[key] = Station( 
            json['nombre'],
            LatLng(coordsList[0], coordsList[1]),
            json['accesibilidad']
        );
    });

    //Parseamos ahora las lineas
    final Map<String, Line> linesMap = {};
    
    // Guardamos la lista de IDs de estaciones para calcular tiempos luego
    final Map<String, List<String>> lineRoutesById = {};
    
    for (var lineJson in (data['lineas'] as List)) {
      String idStr = lineJson['id'].toString();
      int idNum = lineJson['id'];
      
      var freqs = lineJson['frecuencias'];
      var trainFreq = (peak: freqs['pico'] as int, flat: freqs['valle'] as int);

      List<String> routeStationIds = (lineJson['recorrido'] as List)
          .map((e) => e['estacion'] as String)
          .toList();
      
      lineRoutesById[idStr] = routeStationIds;

      List<Station> stationObjects = routeStationIds
          .map((id) => stationsByID[id]!)
          .toList();

      // Creamos la Línea.
      // NOTA: _timeOffsets se inicializa vacío internamente en tu constructor
      linesMap[idStr] = Line(
        idNum,
        stationObjects,
        trainFreq,
      );
    }

    // Con lo que tenemos ya podemos inicializar una Network
    final network = Network.isolated(linesMap.values.toList(), stationsByID.values.toList());
    
    //Aunque tengamos network ya inicializado, falta asignar a las estaciones sus lineas y a las lineas las estaciones y offsets
    //Calculamos el offset
    final Map<String, int> travelTimes = {};
    for (var conn in (data['conexiones'] as List)) {
        String s1 = conn['estacion-1'];
        String s2 = conn['estacion-2'];
        String lId = conn['id-linea'].toString();
        int t = (conn['tiempo'] as num).toInt();
      
        // Guardamos en ambas direcciones para facilitar la búsqueda
        travelTimes["${s1}_${s2}_$lId"] = t;
        travelTimes["${s2}_${s1}_$lId"] = t; 
    }

    // Rellenar datos pendientes en cada Línea
    linesMap.forEach((lineIdStr, line) {
      List<String> routeIds = lineRoutesById[lineIdStr]!;
      int accumulatedTime = 0;

      // El primer offset siempre es 0
      line.addTimeOffset(0);

      for (int i = 0; i < routeIds.length - 1; i++) {
        String current = routeIds[i];
        String next = routeIds[i+1];
        
        int? segmentTime = travelTimes["${current}_${next}_$lineIdStr"];
        
        // Si falta el dato en el JSON, ponemos 3 min por defecto para no romper
        accumulatedTime += (segmentTime ?? 3);
        
        // Usamos tu método para añadir a la lista final
        line.addTimeOffset(accumulatedTime);
      }
    });

    //Contruimos el grafo


    // Helper local para añadir conexiones al mapa de forma segura
    void addConnection(Stop source, Edge edge) {
      if (!network._connections.containsKey(source)) {
        network._connections[source] = {};
      }
      network._connections[source]!.add(edge);
    }

    // Helper local para añadir stops al mapa de estaciones
    void registerStop(Station station, Stop stop) {
      if (!network._stationStops.containsKey(station)) {
        network._stationStops[station] = {};
      }
      network._stationStops[station]!.add(stop);
    }

    //Iteramos las líneas para crear nodos y aristas de viaje
    linesMap.forEach((lineIdStr, line) {
      
      List<String> routeIds = lineRoutesById[lineIdStr]!;
      
      // Variables para guardar el Stop anterior y poder conectar
      Stop? prevStopFwd;
      Stop? prevStopBwd;

      for (int i = 0; i < routeIds.length; i++) {
        String currentId = routeIds[i];
        Station currentStation = stationsByID[currentId]!;

        // Creamos los Stops (Nodos)
        // Como Stop pide (Direction, Station), creamos dos por cada estación:
        // Uno para la dirección de ida y otro para la de vuelta.
        
        Stop stopFwd = Stop(line.forwardDir, currentStation);
        Stop stopBwd = Stop(line.backwardDir, currentStation);

        registerStop(currentStation, stopFwd);
        registerStop(currentStation, stopBwd);

        //Creamos Aristas de Viaje (Edges)
        if (i > 0) {
          // Recuperamos el ID de la estación anterior para buscar el coste
          String prevId = routeIds[i - 1];
          
          // Coste: Buscamos en el mapa travelTimes "Prev_Curr_LineID"
          int cost = travelTimes["${prevId}_${currentId}_$lineIdStr"] ?? 3;

          // Conexión 1: Forward (Del anterior hacia el actual)
          // prevStopFwd  ---> stopFwd
          if (prevStopFwd != null) {
            Edge edgeFwd = Edge(prevStopFwd, stopFwd, cost);
            addConnection(prevStopFwd, edgeFwd);
          }

          // Conexión 2: Backward (Del actual hacia el anterior)
          // stopBwd ---> prevStopBwd
          // Nota: En backward, el tren va de Current a Previous.
          if (prevStopBwd != null) {
            Edge edgeBwd = Edge(stopBwd, prevStopBwd, cost);
            addConnection(stopBwd, edgeBwd);
          }
        }

        // Actualizamos los "anteriores" para la siguiente vuelta del bucle
        prevStopFwd = stopFwd;
        prevStopBwd = stopBwd;
      }
    });

    // Busca la clave (ID) de una estación en el mapa stationsByID
    String keyOf(Map<String, Station> map, Station station) {
        return map.keys.firstWhere((k) => map[k] == station, orElse: () => "");
    }
    //Crear aristas de transbordo
    
    final transbordosList = data['transbordos'] as List;

    int minTransferTime = (data['minTiempoTransbordo'] as num).toInt();
    int maxTransferTime = (data['maxTiempoTransbordo'] as num).toInt();

    int networkMinTransfer = maxTransferTime;

    network._stationStops.forEach((station, stopsSet) {
      // Si hay más de una línea pasando por aquí (más de 2 stops contando idas y vueltas)
      if (stopsSet.length >= 2) { 
        List<Stop> stopsList = stopsSet.toList();

        // Conectamos todos contra todos
        for (int i = 0; i < stopsList.length; i++) {
          for (int j = i + 1; j < stopsList.length; j++) {
            Stop s1 = stopsList[i];
            Stop s2 = stopsList[j];

            if (s1.line == s2.line && s1.station == s2.station) {
              // Si es un cambio de sentido no se debería
              // prohibir, pero sí penalizar gravemente
              Edge trans1 = Edge(s1, s2, maxTransferTime);
              Edge trans2 = Edge(s2, s1, maxTransferTime);

              addConnection(s1, trans1);
              addConnection(s2, trans2);

              continue;
            }

            // tiempo de transbordo mínimo como fallback
            int cost = minTransferTime;

            // Buscar penalización específica en JSON
            var penaltyInfo = transbordosList.firstWhere(
              (t) {
                bool sameStation = t['estacion'] == station.name || t['estacion'] == keyOf(stationsByID, station);
                if (!sameStation) return false;

                List<dynamic> linesJson = t['lineas'];
                return linesJson.contains(s1.line.number.toString()) && 
                       linesJson.contains(s2.line.number.toString());
              },
              orElse: () => null
            );

            if (penaltyInfo != null) {
              cost = (penaltyInfo['tiempo'] as num).toInt();
            }

            networkMinTransfer = min(networkMinTransfer, cost);

            // c. Crear aristas de transbordo bidireccionales
            Edge trans1 = Edge(s1, s2, cost);
            Edge trans2 = Edge(s2, s1, cost);

            addConnection(s1, trans1);
            addConnection(s2, trans2);
          }
        }
      }
    });

    network.addMinTransferTime(networkMinTransfer.toInt());
    network.computeMinTransfers();

    return network;
  }
}
