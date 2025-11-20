import 'dart:ui';
import 'dart:collection';

import 'package:flutter/gestures.dart';

import './edge.dart';
import './vertex.dart';
import './trainMap.dart';
import 'heuristic.dart';
import 'path.dart';


class Astar {
    final TrainMap _map;
    //Las priorityQueue admiten duplicados, luego habra que borrar para meter un elemento ya existente
    final PriorityQueue<(Vertex node, double f) _openList;
    final Set<Vertex> _closedList;
    //Map with the path to vertex
    final Map<Vertex, (Path path, double f) _pathsToStations;

    Astar(TrainMap map){
        this._map = map;
        _openList = PriorityQueue<(Vertex node, double f)> ((a,b) => a.f.compareTo(b.f));
        _closedList = Set<Vertex>();
        _pathsToStations = {begin: (path: Path(), f: 0.0)};
    }

    List<Edge>? calculateRoute(Vertex begin, Vertex end){
        Vertex stationBeing = begin;

        do{
            final Set<Edge> conexions = newStation.getconexions();
            //Meto en la openList las nuevas estaciones y mejores caminos
            for(Edge conexion in conexions){
                Vertex nextStation = edge.nextstation(stationBeing);
                if (!closedList.contains(nextStation)){
                    _addOpenList(stationBeing, nextStation, edge);
                }
            }

            //Saco de la openList y meto en la closedList


            }
        //No compruebo si la lista esta vacia, no deberia pasar, pero estaria bien ponerlo
        }while(!openList.first().node.equals(end));

    }
    
    /*
     *  Funcion para ver si meterlo o no en la pila
     */
    static void _addOpenList (Vertex stationBeing, Vertex nextStation, Edge edge){
        double newf = _calculatef (stationBeing, edge, edge.gettime())
        if(!_pathsToStations.containsKey(nextStation)){
            openList.add((node: nextStation, f: newf));
            Path newPath = changePath(_pathsToStations[stationBeing].path, nextStation, edge); 
            _pathsToStations[nextStation] = (path: newPath, f: newf); 
        }
        else {
            double oldf = pathsToStations[nextStation].f;
            if(oldf > newf){
                _openList.remove((node: nextStation, f: oldf));
                _pathsToStations[nextStation].f = newf; //Creo que puedo hacer esto
                _pathsToStations[nextStation].path = changePath(_pathsToStations[stationBeing].path, nextStation, edge);
                _openList.add((node: nextStation, f: newf));
            }
        }
    }


    static double _calculatef(Vertex father, Edge candidate, int fatherg){
        //TODO
        return 0;
    }
}
