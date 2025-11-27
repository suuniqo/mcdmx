import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcdmx/pages/map.dart';

import 'package:provider/provider.dart';

import 'package:mcdmx/pages/route.dart';
import 'package:mcdmx/pages/news.dart';
import 'package:mcdmx/pages/settings.dart';
import 'package:mcdmx/state/scheme.dart';
import 'package:mcdmx/style/format.dart';
import 'package:mcdmx/style/color_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SchemeState(context))],
      child: Consumer<SchemeState>(
        builder: (context, schemeState, _) {
          final colorTheme = ColorTheme(schemeState.themeHue);

          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(schemeState.fontMul)),
            child: MaterialApp(
              title: 'mcdmx',
              theme: colorTheme.light,
              darkTheme: colorTheme.dark,
              themeMode: schemeState.themeMode,
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _selectedIndex = i),
        children: [RoutePage(), MapPage(), NewsPage(), SettingsPage()],
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: _selectedIndex == 1 ? Format.shadow : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Format.borderRadius),
            topRight: Radius.circular(Format.borderRadius),
          ),
        ),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Format.borderRadius),
              topRight: Radius.circular(Format.borderRadius),
            ),
          ),
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(backgroundColor: Colors.transparent),
            child: NavigationBar(
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
      ),
    );
  }
}
