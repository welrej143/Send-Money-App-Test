import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/domain/use_cases/post_transactions.dart';
import 'package:send_money_app_test/presentation/blocs/send_money/send_money_bloc.dart';

import 'send_money_bloc_test.mocks.dart';

@GenerateMocks([PostTransaction])
void main() {
  late SendMoneyBloc sendMoneyBloc;
  late MockPostTransaction mockPostTransaction;

  setUp(() {
    mockPostTransaction = MockPostTransaction();
    sendMoneyBloc = SendMoneyBloc(postTransactions: mockPostTransaction);
  });

  group('SendMoneyBloc', () {
    blocTest<SendMoneyBloc, SendMoneyState>(
      'emits [SendMoneyLoading, SendMoneySuccess] when postTransactions is successful',
      build: () {
        when(mockPostTransaction(any)).thenAnswer((_) async => Future.value());
        return sendMoneyBloc;
      },
      act: (bloc) => bloc.add(const SubmitSendMoney(100)),
      expect: () => [SendMoneyLoading(), SendMoneySuccess()],
      verify: (_) {
        verify(mockPostTransaction(any)).called(1);
      },
    );

    blocTest<SendMoneyBloc, SendMoneyState>(
      'emits [SendMoneyLoading, SendMoneyError] when postTransactions fails',
      build: () {
        when(mockPostTransaction(any))
            .thenThrow(Exception('Failed to post transaction'));
        return sendMoneyBloc;
      },
      act: (bloc) => bloc.add(const SubmitSendMoney(100)),
      expect: () => [SendMoneyLoading(), SendMoneyError()],
      verify: (_) {
        verify(mockPostTransaction(any)).called(1);
      },
    );
  });
}
