import 'package:flutter/material.dart';
import 'package:mcdmx/domain/line.dart';
import 'package:mcdmx/domain/station.dart';

class NetworkStyle {
  static Color lineColor(Line line) {
    switch (line.number) {
      case 1:
        return const Color.fromARGB(255, 245, 73, 146);
      case 3:
        return const Color.fromARGB(255, 172, 161, 39);
      case 7:
        return const Color.fromARGB(255, 255, 98, 2);
      case 9:
        return const Color.fromARGB(255, 80, 43, 42);
      case 12:
        return const Color.fromARGB(255, 192, 155, 82);
      default:
        return Colors.grey; // fallback
    }
  }

  static String fromStation(Station station) {
      switch (station.name){
        case 'Auditorio':
         return 'assets/images/logoAuditorio2.png';
        case 'Balderas':
          return 'assets/images/logoBalderas2.png';
        case 'Barranca del Muerto':
          return 'assets/images/logoBarrancadelmuerto2.png';
        case 'Centro Medico':
          return 'assets/images/logoCentromedico2.png';
        case 'Chapultepec':
          return 'assets/images/logoChapultepec2.png';
        case 'Chilpancingo':
          return 'assets/images/logoChilpancingo2.png';
        case 'Constituyentes':
         return 'assets/images/logoConstituyentes2.png';
        case 'Copilco':
         return 'assets/images/logoCopilco2.png';
        case 'Coyoacan':
         return 'assets/images/logoCoyoacan2.png';
        case 'Cuauhtemoc':
         return 'assets/images/logoCuauhtemoc2.png';
        case 'Division del Norte':
          return 'assets/images/logoDivisiondelnorte2.png';
        case 'Eje Central':
          return 'assets/images/logoEjeCentral2.png';
        case 'Etiopia':
          return 'assets/images/logoEtiopia2.png';
        case 'Eugenia':
          return 'assets/images/logoEugenia2.png';
        case 'Hospital 20 de Noviembre':
          return 'assets/images/logoHospital20noviembre2.png';
        case 'Hospital General':
         return 'assets/images/logoHospitalgeneral2.png';
        case 'Insurgentes':
         return 'assets/images/logoInsurgentes2.png';
        case 'Insurgentes Sur':
         return 'assets/images/logoInsurgentesSur2.png';
        case 'Juanacatlan':
          return 'assets/images/logoJuanacatlan2.png';
        case 'Juarez':
          return 'assets/images/logoJuarez2.png';
        case 'Lazaro Cardenas':
          return 'assets/images/logoLazaroCardenas2.png';
        case 'M. A. De Quevedo':
          return 'assets/images/logomaquevedo2.png';
        case 'Mixcoac':
         return 'assets/images/logoMixcoac2.png';
        case 'Niños Heroes':
         return 'assets/images/logoNiñoheroes2.png';
        case 'Observatorio':
         return 'assets/images/logoObservatorio2.png';
        case 'Parque de los Venados':
         return 'assets/images/logoParquedelosvenados2.png';
        case 'Patriotismo':
          return 'assets/images/logoPatriotismo2.png';
        case 'Polanco':
          return 'assets/images/logoPolanco2.png';
        case 'San Antonio':
          return 'assets/images/logoSanAntonio2.png';
        case 'San Pedro de los Pinos':
          return 'assets/images/logoSanpedrodelospinos2.png';
        case 'Sevilla':
         return 'assets/images/logoSevilla2.png';
        case 'Tacubaya':
         return 'assets/images/logoTacubaya2.png';
        case 'Universidad':
         return 'assets/images/logoUniversidad2.png';
        case 'Viveros':
         return 'assets/images/logoViveros2.png';
        case 'Zapata':
         return 'assets/images/logoZapata2.png';
        default:
          return 'assets/images/linea1.png';
      }
  }

  static String fromLine(Line line) {
    switch (line.number){
      case 1:
       return 'assets/images/linea1logo.png';
      case 3:
        return 'assets/images/linea3logo.png';
      case 7:
        return 'assets/images/linea7logo.png';
      case 9:
        return 'assets/images/linea9logo.png';
      case 12:
        return 'assets/images/linea12logo.png';
      default:
        return 'assets/images/linea1.png';
    }
  }
}
