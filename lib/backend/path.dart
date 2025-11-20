import 'dart:collection';

import 'edge.dart';
import 'vertex.dart';

class Path {
    final Queue<Vertex> _stations;
    final Queue<Edges> _edges;
    //A lo mejor hay que hacer que la variable solo cambie cuando se ha encontrado el camino optimo
    final double _time;

    Path (){
        this._station = Queue<Vertex>();
        this._edges = Queue<Edge>();
        this._time = 0.0;
    }

    double gettime () => _time;

    Queue<Vertex> getstations () => _stations;
    
    Queue<Edges> getedges () => _edges;

    void insertStation (Vertex nextStation, Edge nextEdge){
        this._stations.add(nextStation);
        this._edges.add(nextEdge);
        this._time += nextEdge.gettime();
    }

    void changePath (Path newPath, Vertex nextStation, Edge nextEdge){
        this._stations.clear();
        this._stations.addAll(newPath.getstations());
        this._edges.clear();
        this._edges.addAll(newPath.getedges());
        this._stations.insertStation(nextStation, nextEdge);
        this._time = newPath.gettime();
    }
}
