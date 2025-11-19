import './edge.dart';
import './vertex.dart';
import './line.dart';
import 'heuristic.dart';


class Astar {
    static const transferTiem = 5;
    
    static List<Edge>? calculateRoute(Vertex begin, Vertex end){
        Vertex current = begin;
        final Map<Vertex, double> visited = {};
        final List<Edge> tree = [];
        int currentLine = 0;


        do{
            Map<Line, int> lines = current.getlines();
            for(Line line in lines.keys){
                List<Edge> pathLine = line.getPath();
                pathLine.contains();
            }
        }while(!current.equals(end));

    }
}
