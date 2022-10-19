import 'package:bloc_test/bloc_test.dart';
import 'package:fatree/ticker.dart';
import 'package:fatree/timer/bloc/timer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTicker extends Mock implements Ticker {}

void main() {
  late Ticker ticker;

  setUp(() {
    ticker = MockTicker();
    when(() => ticker.tick(ticks: 5))
        .thenAnswer((_) => Stream<int>.fromIterable([5, 4, 3, 2, 1]));
  });

  test('Initial state harus TimerInitial(60)', () {
    expect(
      TimerBloc(ticker: ticker).state,
      const TimerInitial(60),
    );
  });

  blocTest<TimerBloc, TimerState>(
    'emits TickerRunInProgress 5 kali setelah timer dimulai',
    build: () => TimerBloc(ticker: ticker),
    act: (bloc) => bloc.add(const TimerStarted(duration: 5)),
    expect: () => [
      const TimerRunInProgress(5),
      const TimerRunInProgress(4),
      const TimerRunInProgress(3),
      const TimerRunInProgress(2),
      const TimerRunInProgress(1),
    ],
    verify: (_) => verify(() => ticker.tick(ticks: 5)).called(1),
  );

  blocTest<TimerBloc, TimerState>(
    'emit [TickerRunPause(2)] ketika ticker di pause saat detik ke 2',
    build: () => TimerBloc(ticker: ticker),
    seed: () => const TimerRunInProgress(2),
    act: (bloc) => bloc.add(const TimerPaused()),
    expect: () => [const TimerRunPause(2)],
  );

  blocTest<TimerBloc, TimerState>(
    'emit [TickerRunInProgress(5)] when ticker is resumetd at 5',
    build: () => TimerBloc(ticker: ticker),
    seed: () => const TimerRunPause(5),
    act: (bloc) => bloc.add(const TimerResumed()),
    expect: () => [const TimerRunInProgress(5)],
  );

  blocTest<TimerBloc, TimerState>(
    'emit [TimerInitial(60)] ketika timer restart',
    build: () => TimerBloc(ticker: ticker),
    act: (bloc) => bloc.add(const TimerReset()),
    expect: () => [const TimerInitial(60)],
  );

  blocTest<TimerBloc, TimerState>(
    'emit [TimerRunInProgress(3)] ketika timer tick ke 3',
    build: () => TimerBloc(ticker: ticker),
    act: (bloc) => bloc.add(TimerTicked(duration: 3)),
    expect: () => [const TimerRunInProgress(3)],
  );

  blocTest<TimerBloc, TimerState>(
    'emit [TimerRunComplete()] ketika timer tick 0',
    build: () => TimerBloc(ticker: ticker),
    act: (bloc) => bloc.add(TimerTicked(duration: 0)),
    expect: () => [const TimerRunComplete()],
  );
}
