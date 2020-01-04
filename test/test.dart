import 'dart:math';
import 'dart:convert';

main(List<String> args) {
  for (var i = 0; i < 50; i++) {
    var list = List<int>.generate(32, (i) {
      // Random().nextInt(max);
    });
    print(utf8.decode(list));
  }
}
