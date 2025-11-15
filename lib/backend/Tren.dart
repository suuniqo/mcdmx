import 'Linea.dart';
import 'dart:async';

class Tren {
    
    Arista posicionActual;
    Nodo siguienteEstacion;
    final StreamController<String> controller = StreamController<String>();

    Tren (Arista posicionActual, Nodo siguienteEstacion, int tiempo){
        this.posicionActual = posicionActual;
        this.siguienteEstacion = siguienteEstacion;
    }
    
    Arista getPosicionActual (){
        return this.PosicionActual;
    }

    Nodo getSiguienteEstacion (){
        return this.siguienteEstacion;
    }

    /*
     *  Funcion que actualiza la arista en la que esta el tren
     *  y cambia la siguienteEstacion, esta debe ser la siguiente de la siguienteEstacion previa
     *  En caso de que la siguienteEstacion previa no se encuentre en la nueva arista,
     *  la funcion siguienteEstacion de Arista lanzara un error
    */
    void actualizarSiguienteEstacion (Arista posicionNueva){
        this.posicionActual = posicionNueva;
        this.siguienteEstacion = this.posicionActual.siguienteEstacion(this.siguienteEstacion);
    }

    void irSiguienteEstacion (Arista posicionNueva){
       actualizarSiguienteEstacion(posicionNueva);
       Timer(Duration(minutes: posicionNueva.getTiempo()), () {
        controller.add();
        });
    }
}
