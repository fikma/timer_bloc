import 'package:fatree/ticker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ticker', () {
    const ticker = Ticker();

    test('Ticker emit 3 tick dari 2 ke 0 tiap detik', () {
      expectLater(ticker.tick(ticks: 3), emitsInOrder(<int>[2, 1, 0]));
    });
  });
}
