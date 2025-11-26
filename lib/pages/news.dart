import 'package:flutter/material.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/titled_page.dart';

class NewsPage extends StatelessWidget {
  static final news = [
    News(
      image: ClipRRect(
        borderRadius: BorderRadius.circular(Format.borderRadius),
        child: Image.asset(
          'assets/images/linea1.png',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
      title: "Reabre la línea 1 CDMX",
      description:
          "La Línea 1 del Metro CDMX reabre tras 3 años y 4 meses, con 36 estaciones operando y nuevas obras previstas para 2026.",
      file:
          'Después de tres años, cuatro meses y cinco días en obras, el 16 de noviembre el gobierno de la Ciudad de México reabrió en su totalidad el servicio de la Línea 1 del Metro CDMX. El Sistema de Transporte Colectivo Metro (STC) concluyó con la modernización del servicio, pese al tiempo de espera, las autoridades celebraron la inversión millonaria.\n\nLa Línea 1 del Metro CDMX, que corre de Balderas a Observatorio, estuvo cerrada desde el 11 de julio de 2022 para llevar a cabo trabajos de rehabilitación y modernización. Durante este periodo, se realizaron diversas mejoras en la infraestructura y el sistema de transporte.\n\nCon la reapertura, todas las estaciones de la Línea 1 están nuevamente operativas, beneficiando a miles de usuarios que dependen de este servicio diariamente. La presidenta SheinBaum tomó parte en la apertura y declaró a los medios:Durante la ceremonia de inauguración, la mandataria capitalina explicó que el servicio del Metro CDMX tendrá una conexión directa con el servicio del Tren Interurbano, el cual también está próximo a inaugurarse.“Este gran complejo Observatorio se va a convertir en el nodo de conectividad metropolitana más importante. Hoy, se podrán conectar desde Toluca, viajar en el próximo tren, El Insurgente, que próximamente va a inaugurar nuestra presidenta, llegar a este complejo, tomar la Línea 1 y bajarse hasta Pantitlán y después trasladarse por la Línea A todo Zaragoza y llegar al Metro Santa Martha en donde podrán tomar el Trolebús Elevado hasta Chalco”. Además, anunció planes para continuar con obras adicionales en el sistema de transporte durante el año 2026. Y terminar de renovar la infraestructura del Metro CDMX.\n\nLa reapertura de la Línea 1 del Metro CDMX marca un hito importante en la mejora del transporte público en la capital, ofreciendo a los usuarios un servicio más eficiente y moderno.',
    ),
    News(
      image: ClipRRect(
        borderRadius: BorderRadius.circular(Format.borderRadius),
        child: Image.asset(
          'assets/images/genz.webp',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
      title: "Estaciones cerradas el 29 Noviembre",
      description:
          "Varias estaciones del Metro CDMX permanecerán cerradas el 29 de noviembre debido a la marcha de la Generación Z. ",
      file:
          'El día 29 de Noviembre queda organizada una gran manifestación por parte de la Generación Z, la cual tendrá como punto de partida el Auditorio Nacional y como destino final Ciudad Universitaria. Las autoridades locales han implementado medidas de seguridad adicionales para garantizar el orden público durante la marcha.\nDebido a esta manifestación, varias estaciones del Metro permanecerán cerradas para garantizar la seguridad de los asistentes y evitar aglomeraciones en las áreas cercanas a la marcha.\n\nLas estaciones que estarán cerradas durante el día 29 de noviembre son las siguientes:\n\n1. Auditorio (Línea 7)\n2. Constituyentes (Línea 7)\n3. Insurgentes Sur (Línea 12)\n4. Zapata (Líneas 12 y 3)\n5. Viveros (Línea 3)\n6. Universidad (Línea 3)\n\nSe recomienda a los usuarios del Metro CDMX planificar sus viajes con anticipación y considerar rutas alternativas para evitar las estaciones afecatdas. Se sugiere mantenerse informado a través de los canales oficiales del Metro CDMX para cualquier actualización o cambio en el servicio durante la manifestación.',
    ),
    News(
      image: ClipRRect(
        borderRadius: BorderRadius.circular(Format.borderRadius),
        child: Image.asset(
          'assets/images/navidad.jpg',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      ),
      title: "Qué hacer en CDMX estas Navidades",
      description:
          "Descubre los mejores eventos navideños 2025 en CDMX: ferias, conciertos, luces y más para disfrutar en familia.",
      file:
          'La Ciudad de México se alista para celebrar la Navidad 2025 con una agenda amplia de actividades culturales, artísticas y familiares.Desde espectáculos clásicos como El Cascanueces hasta festivales temáticos, bazares, pistas de hielo y conciertos, la capital ofrece propuestas para todos los gustos.\n\nEl Cascanueces en la UNAM\nEl clásico de Tchaikovsky abre la agenda navideña, las funciones se realizarán del 27 de noviembre al 7 de diciembre en la Sala Miguel Covarrubias.\nPrecio: \$150 entrada general.\nHorarios: jueves y viernes 20:00 , sábado 19:00 , domingo 12:30\nUbicación: Sala Miguel Covarrubias de la UNAM\n\nActividades de nieve en Parque Aztlán\nEl Parque Urbano Aztlán comenzará con lluvias de nieve artificial del 25 al 30 de noviembre, a las 18:30, 19:00 y 19:30 horas. La programación continuará del 21 al 25 de diciembre con conciertos, pastorelas y espectáculos gratuitos para niñas y niños.\n\nCarrera Navideña:The Santa Run\nDistancias: 10k, 5k y caminata 1k.\nHorario: 7:00:am\nPrecio: Entrada libre, costo por trajinera varía.\nUbicación: Parque La Mexicana (avenida Luis Barragán 505, Santa Fe, alcaldía Cuajimalpa)\n\nConciertos Navideños en el Auditorio Nacional\nDurante diciembre, el Auditorio Nacional albergará una serie de conciertos navideños con artistas locales e internacionales.\nPrecio: Varía según el artista.\nFechas y horarios: Consultar cartelera oficial.\nUbicación: Auditorio Nacional\n\nPistas de hielo gratuitas en las 16 alcaldías\nDel 20 de diciembre al 5 de enero, se instalarán pistas de hielo de acceso libre en cada una de las alcaldías.\nEntre las ubicaciones destacan: Parque Japón (Álvaro Obregón), Parque Tezozomoc (Azcapotzalco), Parque Las Américas (Benito Juárez) y Deportivo Independencia (Tlalpan).\n\nLuces Navideñas en Paseo de la Reforma\nEl emblemático Paseo de la Reforma se iluminará con decoraciones navideñas desde el 1 de diciembre hasta el 6 de enero, ofreciendo un espectáculo visual para los visitantes.\n\nEstas son solo algunas de las muchas actividades que la Ciudad de México tiene preparadas para celebrar la Navidad 2025. Se recomienda a los asistentes verificar los horarios antes de asistir a los eventos.',
    ),
    News(
      image: ClipRRect(
        borderRadius: BorderRadius.circular(Format.borderRadius),
        child: Image.asset('assets/images/poster.jpg', fit: BoxFit.cover),
      ),
      title: "Llegan los póster del mundial 2026",
      description:
          "Ya han salido los póster oficiales de Ciudad de México para el Mundial 2026, ya queda menos para que ruede la esférica.",
      file:
          'La Ciudad de México presentó su póster para la Copa del Mundo 2026, en el que se resaltan elementos como el Palacio de Bellas Artes, los volcanes Popocatepetl e Iztaccihuatl, además del ajolote, símbolos de la capital.CDMX fue la última de las tres sedes de México para la Copa del Mundo 2026 en presentar su póster.\n\n La CDMX será sede de la inauguración de la Copa del Mundo y ya se trabaja para tener inmuebles como el Estadio Azteca a tiempo, para el compromiso que se consumará en el verano del 2026. Como ya sabemos ya hay muchas selecciones cladificadas y hay una gran cantidad de estadios que acogerán partidos, pero será nuestro Estadio Azteca donde debute el combinado mejicano dirigido por Javier Aguirre.\n\n“Mario Cortés", ‘Cuemanche’, es el artista que seleccionó la FIFA a través de un concurso para diseñar los pósters de las tres Ciudades Sede mexicanas. El ilustrador, que es originario y habitante de la Ciudad de México, basó su diseño en la geometría de una cancha de fútbol. Dentro de este espacio, se pueden observar diversos elementos y personajes en un equilibrio simétrico, representando el enfrentamiento entre dos equipos o dos aficiones con colores diferentes, del choque de pasiones en un partido de futbol, publicó el comité organizador. ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TitledPage(
      title: 'Noticias',
      child: ListView(
        children: [
          for (var i = 0; i < news.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : Format.marginPage),
              child: news[i],
            ),
        ],
      ),
    );
  }
}

class News extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final String file;

  const News({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleTitle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    final styleBody = TextStyle(
      fontSize: 12,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDestination(
                image: image,
                title: title,
                description: description,
                file: file,
              ),
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Format.borderRadius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Format.marginCard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              image,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(title, style: styleTitle),
              ),
              Text(description, style: styleBody),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDestination extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final String file;

  const NewsDestination({
    required this.image,
    required this.title,
    required this.description,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleTitle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    final styleSubTitle = TextStyle(
      fontSize: 15,
      color: theme.colorScheme.onSurface,
    );

    final styleBody = TextStyle(
      fontSize: 14,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Noticias'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
          fontSize: 22,
        ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Format.marginPage),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Format.borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(Format.marginCard),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(title, style: styleTitle),
                      ),
                      image,
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(description, style: styleSubTitle),
                      ),
                      Text(file, style: styleBody),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
