import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'kanjim.dart';
import 'scroll_velocity_listener.dart';

class FlashK extends StatefulWidget {
  const FlashK({
    super.key,
    required this.kdb,
  });

  final List<Kanji> kdb;

  @override
  State<FlashK> createState() => _FlashKState();
}

class AdjustableScrollController extends ScrollController {
  AdjustableScrollController([int extraScrollSpeed = 40]) {
    super.addListener(() {
      ScrollDirection scrollDirection = super.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = super.offset +
            (scrollDirection == ScrollDirection.reverse
                ? extraScrollSpeed
                : -extraScrollSpeed);
        scrollEnd = min(super.position.maxScrollExtent,
            max(super.position.minScrollExtent, scrollEnd));
        jumpTo(scrollEnd);
      }
    });
  }
}

class _FlashKState extends State<FlashK> {
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 200,
      diameterRatio: 2,
      magnification: 1.5,
      useMagnifier: false,
      perspective: 0.01,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.kdb.length,
        builder: (context, index) => Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$index'),
                duration: const Duration(milliseconds: 500),
              ),
            ),
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: ListTile(
                    leading: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${widget.kdb[index].K}',
                            style: const TextStyle(fontSize: 32)),
                        Text('$index'),
                      ],
                    ),
                    title: Text(
                        '${widget.kdb[index].Y}\n${widget.kdb[index].I['EN']}'),
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
