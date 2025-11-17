import './edge.dart';
import './vertex.dart';
import 'heuristic.dart';

class Astar {
    
    static List<Vertex> calculateRoute(Vertex begin, Vertex end){
        final List<Vertex> path = [];
        Vertex current = begin;
        final Map<Vertex, double> candidates = {};
        double g=0;

        do{
            Set<Edge> conexions = current.getconexions();
            for(Edge edge in conexions){
                Vertex candidate = edge.nextstation(current);
                double candidateg = g + edge.gettime() + Heuristic.heuristic(current, candidate);
                if(candidates.containsKey(candidate)){
                    candidates[candidate] = candidateg < candidates[candidate]! ? candidateg : candidates[candidate]!;
                }
                else {
                    candidates[candidate] = candidateg;
                }
            }
            

        } while (candidates.isNotEmpty);

        return path;
    }

    //TODO implementar función auxiliar que de el mejor candidato
    static Vertex _bestCandidate(Vertex current){

    }
}
