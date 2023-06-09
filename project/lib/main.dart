import 'package:flutter/material.dart';
import 'dart:ui';

import 'kanjim.dart';
import 'testk.dart';
import 'flashk.dart';
import 'levelr.dart';

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
  //test,
  //flash,
  //filter,
  statexd
}

class _MyWidgetState extends State<MyWidget> {
  bool kami = false;

  bool testing = true;
  bool flashing = false;
  bool filtering = false;

  late List<Kanji> kdb = [];
  var lvls = [0, 80, 240, 440, 640, 825, 1006, 2136];
  int filter = 0;

  @override
  void initState() {
    super.initState();
    loadKustom().then((value) {
      setState(() => kdb = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kdb.isEmpty) return const CircularProgressIndicator();
    return Scaffold(
      //backgroundColor: Colors.grey.shade800,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (_) {
          if (_.delta.dx > 6 && 6 < _.delta.dy) {}
        },
        onSecondaryTap: () => setState(() {
          if (!testing && !flashing) {
          } else if (testing && !flashing) {
            testing = false;
            flashing = true;
          } else if (flashing && !testing) {
            testing = true;
            flashing = false;
          }
        }),
        onSecondaryLongPress: () => setState(() {
          filtering ^= true;
        }),
        child: Center(
          child: AspectRatio(
            aspectRatio: 0.5625,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Expanded(child: SizedBox.shrink()),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: AspectRatio(
                    aspectRatio: 1.33,
                    child: Placeholder(color: Colors.grey.shade700),
                  ),
                ),
                MyDivider(Colors.grey.shade700, 10, 1, 10, 2),
                MyDivider(Colors.grey.shade300, 10, 1, 10, 2),
                MyDivider(Colors.white, 10, 1, 10, 2),
                MyDivider(Colors.grey.shade300, 10, 1, 10, 2),
                MyDivider(Colors.grey.shade700, 10, 1, 10, 2),
                Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: SizedBox.expand(
                    child: filtering
                        ? const LevelR()
                        : testing
                            ? TestK(kdb: kdb)
                            : flashing
                                ? FlashK(kdb: kdb)
                                : const Placeholder(),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget MyDivider(Color c, double? ei, double? h, double? i, double? t) {
  return Divider(
    color: c,
    endIndent: ei,
    height: h,
    indent: i,
    thickness: t,
  );
}
