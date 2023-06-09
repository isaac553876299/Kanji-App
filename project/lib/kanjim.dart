import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Kanji {
  int N;
  String K;
  String Y;
  Map<String, String> I;
  Kanji({
    required this.N,
    required this.K,
    required this.Y,
    required this.I,
  });
}

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
