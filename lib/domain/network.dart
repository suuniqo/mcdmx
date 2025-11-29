import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';


import './line.dart';
import './station.dart';
import './stop.dart';
import './edge.dart';

class Network {
  final List<Line> _lines;
  final List<Station> _stations;

  // Horarios de apertura oficiales
  static const TimeOfDay _openingTimeReg = TimeOfDay(hour: 5, minute: 0);
  static const TimeOfDay _openingTimeSat = TimeOfDay(hour: 6, minute: 0);
  static const TimeOfDay _openingTimeSun = TimeOfDay(hour: 7, minute: 0);
  static const TimeOfDay _closingTime    = TimeOfDay(hour: 0, minute: 0);

  // La velocidad programada del tren es 36 km/h,
  // aunque luego se haya registrado que de media es menos
  static const double trainVelocity = 600.0; // metros por minuto

  static const bool accesibleModeDefault = false;

  late Map<Station, Set<Stop>> _stationStops;
  late Map<Stop, Set<Edge>> _connections;

  // TODO: Rellenar en el constructor o en la fábrica
  // es sólo el mínimo del coste de las aristas dónde
  // ambos nodos son la misma estación, es decir,
  // el mínimo timepo de andar el transbordo.
  // No hace falta el mínimo tiempo de esperar el tren
  // ya que siempre es 0.
  late int _minTransferTime;

  bool _isAccesibleMode = accesibleModeDefault;

  Network(this._lines, this._stations) {
    // TODO: Rellenar

    // IMPORTANTE: Como el json tiene bastante información
    // como transbordos igual es más eficiente que connections y/o stationStops
    // sean argumentos del constructor y creados en Network.fromFile,
    // en vez de calculare a posteriori

    // A partir de aquí están rellenos ambos

    _stationStops = {};
    _connections = {};
  }

  Iterable<Line> get lines => _lines;
  Iterable<Station> get stations => _stations;

  bool get isAccesibleMode => _isAccesibleMode;
  int get minTransferTime => _minTransferTime;

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

  Edge? pathToLine(Stop src, Line line) {
    for (final edge in _connections[src]!) {
      if (edge.opposite(src)!.line == line) {
        return edge;
      }
    }
    return null;
  }

  // TODO: mínimo número de transbordos de una línea a otra
  // como son pocas líneas es fácil, incluso
  // a malas podríais verlo a mano y ponerlo en el json
  // PLUS: en vez de mínimo número de una línea a otra,
  // de una parada (Stop) a una línea.
  // IMPORTANTE: Necesita estar precomputado, se puede
  // hacer un Map<(Line, Line), int> o lo que sea
  int minTransfers(Line src, Line dst) {
    return 1;
  }

  void toggleAccesibleMode() {
    _isAccesibleMode = !_isAccesibleMode;
  }

  factory Network.fromFile(File file) {
    //Lectura síncrona del archivo (los factory no pueden ser async)
    final String jsonString = file.readAsStringSync();
    final Map<String, dynamic> data = jsonDecode(jsonString);

    //Parseamos estaciones
    final Map<String, Station> stationsByID = {};
    (data['estaciones'] as Map<String, dynamic>).forEach((key, json) {
        final coordsList = List<dynamic>.from(json['coordenadas']);

        stationsByID[key] = Station( 
            json['nombre'],
            LatLng(coordsList[0], coordsList[1]),
            json['accesibilidad'] ?? false
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
      var trainFreq = (freqs['pico'] as int, freqs['valle'] as int);

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

    //Con lo que tenemos ya podemos inicializar una Network
    final network = Network(linesMap.values.toList(), stationsByID.values.toList());
    
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
      line.network = network;

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
          int costInt = travelTimes["${prevId}_${currentId}_$lineIdStr"] ?? 3;
          double cost = costInt.toDouble();

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

    network._stationStops.forEach((station, stopsSet) {
      // Si hay más de una línea pasando por aquí (más de 2 stops contando idas y vueltas)
      if (stopsSet.length > 2) { 
        List<Stop> stopsList = stopsSet.toList();

        // Conectamos todos contra todos
        for (int i = 0; i < stopsList.length; i++) {
          for (int j = i + 1; j < stopsList.length; j++) {
            Stop s1 = stopsList[i];
            Stop s2 = stopsList[j];

            // Solo creamos transbordo si son de LÍNEAS DISTINTAS
            // si quieremos permitir cambio de andén, podrías quitar este if?.
            if (s1.line != s2.line) {
              
              double cost = 4; 

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
                cost = (penaltyInfo['tiempo'] as num).toDouble();
              }

              // c. Crear aristas de transbordo bidireccionales
              Edge trans1 = Edge(s1, s2, cost);
              Edge trans2 = Edge(s2, s1, cost);

              addConnection(s1, trans1);
              addConnection(s2, trans2);
            }
          }
        }
      }
    });

    return network;
  }
}
