import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/use_cases/get_transactions.dart';
import 'package:send_money_app_test/presentation/blocs/transactions/transactions_bloc.dart';

import 'transactions_bloc_test.mocks.dart';

@GenerateMocks([GetTransactions])
void main() {
  late TransactionsBloc transactionsBloc;
  late MockGetTransactions mockGetTransactions;

  setUp(() {
    mockGetTransactions = MockGetTransactions();
    transactionsBloc = TransactionsBloc(getTransactions: mockGetTransactions);
  });

  group('TransactionsBloc', () {
    blocTest<TransactionsBloc, TransactionsState>(
      'emits [TransactionsLoading, TransactionsLoaded] when getTransactions is successful',
      build: () {
        final mockTransactions = [
          Transaction(id: '1', body: 'Transaction 1'),
          Transaction(id: '2', body: 'Transaction 2'),
        ];

        when(mockGetTransactions()).thenAnswer((_) async => mockTransactions);
        return transactionsBloc;
      },
      act: (bloc) => bloc.add(LoadTransactions()),
      expect: () => [
        isA<TransactionsLoading>(),
        isA<TransactionsLoaded>(),
      ],
      verify: (_) {
        verify(mockGetTransactions()).called(1);
      },
    );

    blocTest<TransactionsBloc, TransactionsState>(
      'emits [TransactionsLoading, TransactionsError] when getTransactions fails',
      build: () {
        when(mockGetTransactions())
            .thenThrow(Exception('Failed to load transactions'));
        return transactionsBloc;
      },
      act: (bloc) => bloc.add(LoadTransactions()),
      expect: () => [
        isA<TransactionsLoading>(),
        isA<TransactionsError>(),
      ],
      verify: (_) {
        verify(mockGetTransactions()).called(1);
      },
    );
  });
}
