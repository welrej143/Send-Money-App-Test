import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/presentation/blocs/transactions/transactions_bloc.dart';
import 'package:send_money_app_test/presentation/pages/transactions_page.dart';

import 'transactions_page_test.mocks.dart';

@GenerateMocks([TransactionsBloc])
void main() {
  late TransactionsBloc mockTransactionsBloc;

  setUp(() {
    mockTransactionsBloc = MockTransactionsBloc();
  });

  tearDown(() {
    mockTransactionsBloc.close();
  });

  testWidgets('TransactionsPage Title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: mockTransactionsBloc,
            child: const TransactionsPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Transactions'), findsOneWidget);
  });

  testWidgets('TransactionsPage UI Test - TransactionsLoaded State',
      (WidgetTester tester) async {
    final transactions = [
      Transaction(id: '1', body: '100'),
    ];

    when(mockTransactionsBloc.state)
        .thenReturn(TransactionsLoaded(transactions));
    when(mockTransactionsBloc.stream)
        .thenAnswer((_) => Stream.value(TransactionsLoaded(transactions)));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: mockTransactionsBloc,
            child: const TransactionsView(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const Key('transactions')), findsOneWidget);
  });

  testWidgets('TransactionsPage UI Test - Error State',
      (WidgetTester tester) async {
    when(mockTransactionsBloc.state).thenReturn(TransactionsError());
    when(mockTransactionsBloc.stream)
        .thenAnswer((_) => Stream.value(TransactionsError()));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: mockTransactionsBloc,
            child: const TransactionsView(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Failed to load transactions'), findsOneWidget);
  });
}
