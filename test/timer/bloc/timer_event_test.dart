import 'package:fatree/timer/bloc/timer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimerEvent', () {
    group('TimerStarted', () {
      test('Support value comparison', () {
        expect(
          const TimerStarted(duration: 60),
          const TimerStarted(duration: 60),
        );
      });
    });

    group('TimerPaused', () {
      test('Support value comparison', () {
        expect(
          const TimerPaused(),
          const TimerPaused(),
        );
      });
    });

    group('TimerResumed', () {
      test('Support value comparison', () {
        expect(
          const TimerResumed(),
          const TimerResumed(),
        );
      });
    });

    group('TimerReset', () {
      test('Support value comparison', () {
        expect(
          const TimerReset(),
          const TimerReset(),
        );
      });
    });
  });
}
