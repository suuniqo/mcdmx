import 'package:flutter/material.dart';
import 'package:mcdmx/pages/home.dart';
import 'package:mcdmx/pages/news.dart';
import 'package:mcdmx/pages/settings.dart';
import 'package:mcdmx/state/scheme.dart';
import 'package:provider/provider.dart';
import 'pages/news.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SchemeState())],
      child: Consumer<SchemeState>(
        builder: (context, schemeState, _) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(schemeState.fontSize)),
            child: MaterialApp(
              title: 'mcdmx',
              theme: schemeState.themeData,
              home: Frame(),
            ),
          );
        },
      ),
    );
  }
}

class Frame extends StatefulWidget {
  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  var _selectedIndex = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: PageView(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _selectedIndex = i),
          children: [
            HomePage(),
            Placeholder(),
            Placeholder(),
            NewsPage(),
            SettingsPage(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(backgroundColor: Colors.transparent),
          child: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) {
              _pageController.animateToPage(
                i,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_rounded),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.route_rounded),
                label: 'Ruta',
              ),
              NavigationDestination(
                icon: Icon(Icons.map_rounded),
                label: 'Mapa',
              ),
              NavigationDestination(
                icon: Icon(Icons.newspaper_rounded),
                label: 'Noticias',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_rounded),
                label: 'Ajustes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
