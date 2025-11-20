import 'dart:ui';

import 'package:flutter/gestures.dart';

import './edge.dart';
import './vertex.dart';
import './trainMap.dart';
import 'heuristic.dart';


class Astar {
    final TrainMap _map;

    Astar(this._map);

    List<Edge>? calculateRoute(Vertex begin, Vertex end){
        final Map<Vertex, (int, double)> visited = {begin: (0, 0.0)}; //Aqui guardamos las estanciones que ya hemos llegado con su g* y f*
        final Map<Edge, int> tree = {}; //Hacemos el "arbol" para llegar a end, int representa la linea
        final Map<Edge, (Vertex, double)> candidates = {}; //Arista candidata con su nodo padre y su f*
        Vertex newStation = begin;


        do{
            final Set<Edge> conexions = newStation.getconexions();
            final Map<Edge, int> conexionLine = {};
            for(Edge conexion in conexions){
                conexionLine[conexion] = _getLine(conexion, _map);
            }

            for(Edge conexion in conexions){
                Vertex candidate = conexion.nextstation(newStation);
                double f = _calculatef(newStation, conexion, visited[newStation]!.$1);
                if(visited.containsKey(candidate) && (visited[candidates]!.$2 > f)){

                }
            }
        }while(!visited.containsKey(end)&&candidates.isNotEmpty);

    }

    static int _getLine(Edge conexion, TrainMap map){
        //TODO
        return 0;
    }

    static double _calculatef(Vertex father, Edge candidate, int fatherg){
        //TODO
        return 0;
    }
}
