import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/presentation/page/exercisepage.dart';
import 'package:namer_app/presentation/page/musclepage.dart';
import 'package:namer_app/presentation/page/programpage.dart';

void main() async {
  await dotenv.load();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Gym Tracker',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.dark(),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 220, 0, 0),
            brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

@immutable
class PageItem {
  const PageItem({
    required this.title,
    required this.iconData,
    required this.page,
  });

  final String title;
  final IconData iconData;
  final Widget page;
}

class _HomePageState extends ConsumerState<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    final pageItems = <PageItem>[
      PageItem(
        title: 'Programs',
        iconData: Icons.list_alt_outlined,
        page: ProgramPage(),
      ),
      PageItem(
        title: "Exercises",
        iconData: Icons.sports_gymnastics,
        page: ExercisePage(),
      ),
      PageItem(
        title: 'Muscles',
        iconData: Icons.back_hand,
        page: MusclePage(),
      )
    ];

    var mainArea = ColoredBox(
      color: colorScheme.primaryContainer,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: pageItems[selectedIndex].page,
      ),
    );

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 350 || shortestSide < Config.phoneSize) {
        return SafeArea(
          child: Scaffold(
              body: mainArea,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                type: BottomNavigationBarType.fixed,
                items: pageItems
                    .map((e) => BottomNavigationBarItem(
                        label: e.title,
                        icon: Icon(e.iconData),
                        tooltip: e.title))
                    .toList(),
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              )),
        );
      } else {
        return SafeArea(
          left: false,
          right: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavigationRail(
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  extended: constraints.maxWidth > 500,
                  minExtendedWidth: 220,
                  selectedIndex: selectedIndex,
                  destinations: pageItems
                      .map((e) => NavigationRailDestination(
                            icon: Icon(
                              e.iconData,
                            ),
                            label: Text(
                              e.title,
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                          ))
                      .toList()),
              Expanded(child: mainArea),
            ],
          ),
        );
      }
    });
  }
}
