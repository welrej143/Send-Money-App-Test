import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/use_cases/post_transactions.dart';
import 'package:send_money_app_test/presentation/blocs/send_money/send_money_bloc.dart';
import 'package:send_money_app_test/presentation/pages/send_money_page.dart';
import 'package:mockito/annotations.dart';
import 'send_money_page_test.mocks.dart';

@GenerateMocks([PostTransaction])
void main() {
  late MockPostTransaction mockPostTransaction;
  final Transaction mockTransaction = Transaction(id: '1', body: '100.0');

  setUp(() {
    mockPostTransaction = MockPostTransaction();
  });

  testWidgets('SendMoneyPage UI Test - Success', (WidgetTester tester) async {
    when(mockPostTransaction(mockTransaction))
        .thenAnswer((_) async => mockTransaction);

    await tester.pumpWidget(buildTestableWidget(mockPostTransaction));

    expect(find.text('Send Money'), findsOneWidget);

    final amountField = find.byType(TextField);
    await tester.enterText(amountField, '100.0');

    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pump();

    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('Transaction Successful'), findsOneWidget);
  });
}

Widget buildTestableWidget(PostTransaction postTransaction) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: BlocProvider(
        create: (_) => SendMoneyBloc(postTransactions: postTransaction),
        child: SendMoneyView(),
      ),
    ),
  );
}
