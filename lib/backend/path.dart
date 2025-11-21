import 'dart:collection';

import 'edge.dart';
import 'vertex.dart';

/*
 *  Clase para dar al frontend, guarda el vertice inicial, el path (listas de edges) y el tiempo
 */ 

class Path {
    final Vertex _firstStation;
    final ListQueue<Edge> _path;
    double _time;

    Path (this._firstStation) :
        this._path = ListQueue<Edge>(),
        this._time = 0.0;

    double gettime () => _time;

    Vertex getFirstStation () => _firstStation;
    
    ListQueue<Edge> getpath () => _path;

    void insertStation (Edge nextEdge){
        this._path.addFirst(nextEdge);
        this._time += nextEdge.gettime();
    }
}
