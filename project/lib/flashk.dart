import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'kanjim.dart';

class FlashK extends StatefulWidget {
  const FlashK({
    super.key,
    required this.kdb,
  });

  final List<Kanji> kdb;

  @override
  State<FlashK> createState() => _FlashKState();
}

class _FlashKState extends State<FlashK> {
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 150,
      diameterRatio: 2.0,
      magnification: 1.5,
      useMagnifier: false,
      perspective: 0.01,
      squeeze: 2.0,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.kdb.length,
        builder: (context, index) => Center(
          child: GestureDetector(
            //behavior: HitTestBehavior.opaque,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$index'),
                duration: const Duration(milliseconds: 500),
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              //padding: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
                boxShadow: true
                    ? [
                        BoxShadow(
                          color: Colors.grey.shade900,
                          blurRadius: 5,
                          spreadRadius: 5,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(-10, 0),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(10, 0),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(0, 10),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade900,
                          offset: Offset(0, -10),
                          blurRadius: 5,
                        ),
                      ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '【${widget.kdb[index].K}】',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text('$index'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                            '${widget.kdb[index].Y}\n${widget.kdb[index].I['EN']}'),
                      ),
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
