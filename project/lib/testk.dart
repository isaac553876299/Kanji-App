import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'dart:math';

import 'kanjim.dart';

class TestK extends StatefulWidget {
  const TestK({
    super.key,
    required this.kdb,
  });

  final List<Kanji> kdb;

  @override
  State<TestK> createState() => _TestKState();
}

class _TestKState extends State<TestK> {
  late dynamic xd;

  List<int> H = [];
  List<int> lOr = [];
  int? correct;

  bool waitingNext = true;
  bool showMeanings = false;

  @override
  initState() {
    super.initState();
    next();
  }

  void next() {
    if (waitingNext) {
      setState(() {
        lOr = List<int>.generate(2, (_) => Random().nextInt(widget.kdb.length));
        correct = Random().nextInt(lOr.length);

        waitingNext = false;
        showMeanings = false;
      });
    }
  }

  void check(int choice) {
    if (!waitingNext) {
      setState(() {
        waitingNext = true;
        if (choice == correct) {
          H.add(lOr[correct!]);
          if (H.length >= 6) {
            xxd();
          }
        }
        /*bool result = (choice == correct);
        int trueIx = lOr[correct!];
        H[trueIx] ??= result;
        if (H[trueIx] != result) {
          H[trueIx] = null;
        }*/
      });
    }
  }

  void xxd() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        contentPadding: EdgeInsets.only(top: 10),
        content: AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                    child: Text(
                      " 頑張れ！",
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
              const Divider(thickness: 1, indent: 30, endIndent: 30),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: FittedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var upRow = 0; upRow < 2; ++upRow)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var downRow = 3;
                                  downRow < 6 /*H.length*/;
                                  ++downRow)
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      '鬱',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ), //widget.kdb[H[i]].K),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  child: InkWell(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                    child: FittedBox(
                      child: Text(
                        "【々】",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => next(),
      onDoubleTap: () => xxd(),
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16, //0.5625,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(flex: 1, child: SizedBox.shrink()),
              const Flexible(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 1.33,
                  child: Placeholder(),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onTap: () => setState(() => showMeanings ^= true),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FittedBox(
                        child: Text(
                          !showMeanings
                              ? widget.kdb[lOr[correct!]].K
                              : widget.kdb[lOr[correct!]].I['EN']!
                                  .replaceAll(', ', '\n'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FittedBox(
                  child: Text(
                    '${H.length}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(
                    lOr.length,
                    (index) => GestureDetector(
                      onTap: () => check(index),
                      child: AspectRatio(
                        aspectRatio: 0.666666,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: !waitingNext
                                ? Colors.grey.shade300
                                : index == correct
                                    ? Colors.white
                                    : Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FittedBox(
                            child: Text(
                              widget.kdb[lOr[index]].Y.replaceAll('、', '\n'),
                              style: TextStyle(
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}

/*
Widget xd() {
  return MyTextBox(
    1,
    30,
    Colors.grey.shade300,
    Colors.grey.shade800,
    !showMeanings
        ? widget.kdb[lOr[correct!]].K
        : widget.kdb[lOr[correct!]].I['EN']!.replaceAll(', ', '\n'),
  );
}
Widget xd2() {
  return MyTextBox(
    0.666666,
    20,
    !waitingNext
        ? Colors.grey.shade300
        : index == correct
            ? Colors.white
            : Colors.grey.shade700,
    Colors.grey.shade800,
    widget.kdb[lOr[index]].Y.replaceAll('、', '\n'),
  );
}
Widget MyTextBox(double ar, double rc, Color bg, Color s, String content) {
  return AspectRatio(
    aspectRatio: ar,
    child: Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(rc),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FittedBox(
          child: Text(
            content,
            style: TextStyle(
              color: s,
            ),
          ),
        ),
      ),
    ),
  );
}*/
