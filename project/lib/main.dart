import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui';
import 'dart:convert';

import 'kanjim.dart';
import 'testk.dart';
import 'flashk.dart';
import 'levelr.dart';

Future<List<Kanji>> loadKustom() async {
  final contents = await rootBundle.loadString("assets/kdb.json");
  final entries = List<String>.from(json.decode(contents));
  final result = <Kanji>[];
  for (var e in entries) {
    var index = int.parse(RegExp(r'#(\d{1,4})【').firstMatch(e)!.group(1)!);
    var kanji = RegExp(r'【(.)】').firstMatch(e)!.group(1)!;
    var yomi = RegExp(r'】「(.*?)」')
        .firstMatch(e)!
        .group(1)!
        .split('、')
        //.map((ee) => ee.replaceAll(RegExp(r'-|\..*?'), r''))
        //.toSet()
        .join('、');
    var imi = <String, String>{};
    imi['EN'] = 'xd';
    result.add(
      Kanji(N: index, K: kanji, Y: yomi, I: imi),
    );
  }
  return result;
}

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyScrollBehavior(),
      title: '漢字のパワー',
      home: const Placeholder(),
      routes: {
        'xd': (context) => const MyWidget(),
      },
      initialRoute: 'xd',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade800,
        primaryColor: Colors.green.shade300,
        primarySwatch: Colors.amber,
        primaryTextTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.yellow.shade800),
          displayLarge: TextStyle(color: Colors.yellow.shade800),
          displayMedium: TextStyle(color: Colors.yellow.shade800),
          displaySmall: TextStyle(color: Colors.yellow.shade800),
        ),
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

enum BASHO {
  test,
  filter,
  flash,
}

class _MyWidgetState extends State<MyWidget> {
  int statexd = 0;
  BASHO basho = BASHO.test;

  late List<Kanji> kdb = [];
  var lvls = [0, 80, 240, 440, 640, 825, 1006, 2136];
  int filter = 0;

  @override
  void initState() {
    super.initState();
    loadKustom().then((value) {
      setState(() {
        kdb = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return kdb.isEmpty
        ? const CircularProgressIndicator()
        : Scaffold(
            //backgroundColor: Colors.grey.shade800,
            body: PageView(
              children: [
                TestK(kdb: kdb),
                FlashK(kdb: kdb),
                LevelR(),
              ],
            ),
          );
  }
}
