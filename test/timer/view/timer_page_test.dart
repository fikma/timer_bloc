import 'package:bloc_test/bloc_test.dart';
import 'package:fatree/timer/bloc/timer_bloc.dart';
import 'package:fatree/timer/view/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTimerBloc extends MockBloc<TimerEvent, TimerState>
    implements TimerBloc {}

extension on WidgetTester {
  Future<void> pumpTimerView(TimerBloc timerBloc) {
    return pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: timerBloc,
        child: const TimerView(),
      ),
    ));
  }
}

void main() {
  late TimerBloc timerBloc;

  setUp(() {
    timerBloc = MockTimerBloc();
  });

  tearDown(() => reset(timerBloc));

  group('TimerPage', () {
    testWidgets('render TimerView', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimerPage()));

      expect(find.byType(TimerView), findsOneWidget);
    });
  });

  group('TimerView', () {
    testWidgets('render initial timer view', (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerInitial(60));
      await tester.pumpTimerView(timerBloc);
      expect(find.text('01:00'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets(
      'renders tombol pause dan reset ketika state timer di state in progress ',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunInProgress(59));
        await tester.pumpTimerView(timerBloc);

        expect(find.text('00:59'), findsOneWidget);
        expect(find.byIcon(Icons.pause), findsOneWidget);
        expect(find.byIcon(Icons.replay), findsOneWidget);
      },
    );

    testWidgets(
      'render tombol play dan reset ketika timer state di pause',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunPause(600));
        await tester.pumpTimerView(timerBloc);
        expect(find.text('10:00'), findsOneWidget);
        expect(find.byIcon(Icons.play_arrow), findsOneWidget);
        expect(find.byIcon(Icons.replay), findsOneWidget);
      },
    );

    testWidgets(
      'renders tombol replay ketika timer selesai',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunComplete());
        await tester.pumpTimerView(timerBloc);

        expect(find.text('00:00'), findsOneWidget);
        expect(find.byIcon(Icons.replay), findsOneWidget);
      },
    );

    testWidgets(
      'renders tombol replay ketika timer selesai',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunComplete());
        await tester.pumpTimerView(timerBloc);

        expect(find.text('00:00'), findsOneWidget);
        expect(find.byIcon(Icons.replay), findsOneWidget);
      },
    );

    testWidgets('timer dimulai ketika tombol play dimulai', (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerInitial(60));

      await tester.pumpTimerView(timerBloc);
      await tester.tap(find.byIcon(Icons.play_arrow));

      verify(() => timerBloc.add(const TimerStarted(duration: 60))).called(1);
    });

    testWidgets(
        'timer pauses ketika tombol pause ditekan ketika timer dalam progres',
        (tester) async {
      when(() => timerBloc.state).thenReturn(const TimerRunInProgress(30));

      await tester.pumpTimerView(timerBloc);
      await tester.tap(find.byIcon(Icons.pause));

      verify(() => timerBloc.add(const TimerPaused())).called(1);
    });

    testWidgets(
      'timer reset ketika tombol replay di mulai ketika timer dalam progress',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunPause(30));

        await tester.pumpTimerView(timerBloc);
        await tester.tap(find.byIcon(Icons.replay));

        verify(() => timerBloc.add(const TimerReset())).called(1);
      },
    );

    testWidgets(
      'timer resume ketika tombol play ditap ketika timer dalam keadaan pause',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunPause(20));

        await tester.pumpTimerView(timerBloc);
        await tester.tap(find.byIcon(Icons.play_arrow));

        verify(() => timerBloc.add(const TimerResumed())).called(1);
      },
    );

    testWidgets(
      'timer reset ketika tombol reset ditap ketika timer state dalam keadaan paused',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunPause(40));

        await tester.pumpTimerView(timerBloc);
        await tester.tap(find.byIcon(Icons.replay));

        verify(() => timerBloc.add(const TimerReset())).called(1);
      },
    );

    testWidgets(
      'timer reset ketika tombol reset ditap ketika state finish',
      (tester) async {
        when(() => timerBloc.state).thenReturn(const TimerRunComplete());

        await tester.pumpTimerView(timerBloc);
        await tester.tap(find.byIcon(Icons.replay));

        verify(() => timerBloc.add(const TimerReset())).called(1);
      },
    );
  });
}
