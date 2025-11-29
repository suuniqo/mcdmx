import 'line.dart';

class Station {
  final String _name;
  final List<Line> _lines;

  final (double x, double y) _coordinates;
  final bool _accesible;


  Station(this._name, this._lines, this._coordinates, this._accesible);

  String get name => _name;
  Iterable<Line> get lines => _lines;
  (double x, double y) get coordinates => _coordinates;
  bool get accesible => _accesible;

  String get logo{
      switch (_name){
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
        case 'Hospital 20 Noviembre':
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
        case 'M. A. de Quevedo':
          return 'assets/images/logomaquevedo2.png';
        case 'Mixoac':
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
  
}
