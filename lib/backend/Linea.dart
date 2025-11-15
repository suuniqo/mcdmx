import './Arista.dart';
import './Tren.dart';

class Linea {
    
    int numero;
    List<Arista> recorrido;
    int frecuencia; //Cada cuantos minutos sale un tren de la primera estacion
    Nodo primeraEstacion;
    int numeroEstaciones;
    Set<Tren> trenes;
    

    Linea (int numero, List<Arista> recorrido, int frecuencia, Nodo primeraEstacion){
        this.numero = numero;
        this.recorrido = recorrido;
        this.frecuencia = frecuencia;
        this.primeraEstacion = primeraEstacion;
        this.numeroEstaciones = recorrido.length;
    }

    int getNumero (){
        return this.numero;
    }

    List<Arista> getRecorrido (){
        return this.recorrido;
    }

    int getFrecuencia (){
        return this.frecuencia;
    }

    Nodo getPrimeraEstacion (){
        return this.primeraEstacion;
    }

    int getNumeroEstaciones (){
        return numeroEstaciones;
    }

    void mantenerTrenesEnMovimient (){
        
    }

}
