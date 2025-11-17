import './linea.dart';

class Mapa {
    List<Linea> lineas;

    Mapa (List<Linea> lineas){
        this.lineas = lineas;
    }

    List<Linea> getLineas (){
        return lineas;
    }
}
