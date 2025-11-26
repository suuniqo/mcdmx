import 'package:flutter/material.dart';
import 'package:mcdmx/style/content.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/widgets/tab_box.dart';
import 'package:mcdmx/widgets/titled_page.dart';

class LineasParadasPage extends StatelessWidget {
  const LineasParadasPage({super.key});
Widget _quickAccessTabs(ThemeData theme) {
  // Datos de ejemplo
  final lineada = [
    LineaBoton(icon:Image.asset('assets/images/linea1logo.png'), name: "Observatorio-Balderas"),
    LineaBoton(icon:Image.asset('assets/images/linea1logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Balderas-Observatorio"),
    LineaBoton(icon:Image.asset('assets/images/linea3logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Universidad-Juarez"),
    LineaBoton(icon:Image.asset('assets/images/linea3logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Juarez-Universidad"),
    LineaBoton(icon:Image.asset('assets/images/linea7logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Polanco-Barranca del Muerto"),
    LineaBoton(icon:Image.asset('assets/images/linea7logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Barranca del Muerto-Polanco"),
    LineaBoton(icon:Image.asset('assets/images/linea9logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Tacubaya-Lazaro Cardenas"),
    LineaBoton(icon:Image.asset('assets/images/linea9logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Lazaro Cardenas-Tacubaya"),
    LineaBoton(icon:Image.asset('assets/images/linea12logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Mixcoac-Eje Central"),
    LineaBoton(icon:Image.asset('assets/images/linea12logo.png',width: 20,height: 20,fit: BoxFit.contain,), name: "Eje Central-Mixcoac"),
  ];
  return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.surfaceContainerLowest,
          elevation: 0,
          child: TabBox(
            tabsData: [
              (Icons.directions_subway_filled_rounded, 'Paradas', const SizedBox()),
              (Icons.timeline, 
              'Lineas', 
              Center(child: ListView(
              children: [
                    for (var i = 0; i < lineada.length; i++)
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : Format.marginPage),
                      child: lineada[i],
                      ),
              ],
              ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body:TitledPage(
      title: 'Metro',
      icon: Image.asset('assets/images/logocdmx.png',width: 32,height: 32,fit: BoxFit.contain,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: Format.marginPage),
          _quickAccessTabs(theme),
        ],
      ), 
      ),      
    );
  }
}

class LineaBoton extends StatelessWidget {
  final Widget icon;
  final String name;

  const LineaBoton({
    super.key,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleName = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>Placeholder()
                ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Format.borderRadius),
            ),
            backgroundColor: Colors.amber,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Format.marginCard),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[ SizedBox(width: 30,height: 30,child: icon),
                    SizedBox(width: 12),
                    Text(name, style: styleName),
                    ]
            ),
          ),
        ),
      ),
    );
  }
}

class LineasPage extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final String file;

  const LineasPage({
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
