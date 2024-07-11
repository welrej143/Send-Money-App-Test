import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/repositories/transaction_repository.dart';
import 'package:send_money_app_test/domain/use_cases/get_transactions.dart';

import 'get_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  group('GetTransactions', () {
    late GetTransactions getTransactions;
    late MockTransactionRepository mockRepository;

    setUp(() {
      mockRepository = MockTransactionRepository();
      getTransactions = GetTransactions(mockRepository);
    });

    test('should return a list of transactions from the repository', () async {
      final mockTransactions = [
        Transaction(id: '1', body: 'Transaction 1'),
        Transaction(id: '2', body: 'Transaction 2'),
      ];

      when(mockRepository.getTransactions()).thenAnswer(
          (_) async => mockTransactions); // Ensure it returns a Future

      final result = await getTransactions.call();

      expect(result, equals(mockTransactions));
    });

    test('should throw an exception if repository call fails', () async {
      when(mockRepository.getTransactions())
          .thenThrow(Exception('Failed to load transactions'));

      expect(() => getTransactions.call(), throwsException);
    });
  });
}
