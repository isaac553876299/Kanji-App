import 'package:flutter/material.dart';
import 'dart:math';

class MyLockPattern extends CustomPainter {
  final List<Offset> positions;
  final Offset? offset;
  final List<int> codes;
  final Function(int code) onSelect;
  MyLockPattern({
    required this.positions,
    required this.offset,
    required this.codes,
    required this.onSelect,
  });
  @override
  bool shouldRepaint(MyLockPattern oldDelegate) {
    return offset != oldDelegate.offset;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Color non = Colors.grey.shade700;
    Color sel = Colors.white;

    int lastIn = -1;

    for (var i = 0; i < 7; ++i) {
      var pathOut = Path()
        ..addOval(Rect.fromCircle(center: positions[i], radius: 30));

      if (offset != null && pathOut.contains(offset!)) lastIn = i;

      var painter = Paint()
        ..strokeWidth = 1.0
        ..color = codes.contains(i) ? sel : non;
      canvas.drawPath(pathOut, painter..style = PaintingStyle.stroke);
    }
    onSelect(lastIn);
  }
}

class LevelR extends StatefulWidget {
  const LevelR({super.key});

  @override
  State<LevelR> createState() => _LevelRState();
}

class _LevelRState extends State<LevelR> {
  Offset? offset;
  List<int> codes = [];
  bool lastIn = false;

  @override
  Widget build(BuildContext context) {
    var cx = MediaQuery.of(context).size.width / 2;
    var cy = MediaQuery.of(context).size.height / 2;
    var positions = List<Offset>.generate(
      7,
      (i) => Offset(
        cx + 130 * cos(i * 2 * pi / 7 - pi / 4.69),
        cy + 130 * sin(i * 2 * pi / 7 - pi / 4.69),
      ),
    );
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanStart: (_) => setState(() => codes.clear()),
            onPanUpdate: (_) => setState(() => offset = _.localPosition),
            onPanEnd: (_) => setState(
              () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(codes.join('+')),
                  duration: Duration(milliseconds: 500),
                ),
              ),
            ),
            child: CustomPaint(
              size: Size.fromWidth(MediaQuery.of(context).size.width),
              painter: MyLockPattern(
                positions: positions,
                codes: codes,
                offset: offset,
                onSelect: (int code) {
                  if (code == -1) {
                    lastIn = false;
                  } else if (!lastIn) {
                    lastIn = true;
                    if (!codes.contains(code)) {
                      codes.add(code);
                    } else {
                      codes.remove(code);
                    }
                  }
                },
              ),
            ),
          ),
          for (var i = 0; i < 7; ++i)
            Transform(
              transform: Matrix4.identity()
                ..translate(positions[i].dx - cx, positions[i].dy - cy),
              child: Text(
                '「${'➀➁➂➃➄➅Ⓢ'[i]}」',
                style: TextStyle(
                  color:
                      codes.contains(i) ? Colors.white : Colors.grey.shade700,
                  fontSize: 32,
                  //height: 0.9,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
