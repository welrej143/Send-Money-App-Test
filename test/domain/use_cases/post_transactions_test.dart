import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:send_money_app_test/domain/entities/transaction.dart';
import 'package:send_money_app_test/domain/repositories/transaction_repository.dart';
import 'package:send_money_app_test/domain/use_cases/post_transactions.dart';

import 'get_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  group('PostTransaction', () {
    late PostTransaction postTransaction;
    late MockTransactionRepository mockRepository;

    setUp(() {
      mockRepository = MockTransactionRepository();
      postTransaction = PostTransaction(mockRepository);
    });

    test('should call the repository to post a transaction', () async {
      final transaction = Transaction(id: '1', body: 'New Transaction');

      await postTransaction.call(transaction);

      verify(mockRepository.postTransaction(transaction)).called(1);
    });

    test('should throw an exception if repository call fails', () async {
      final transaction = Transaction(id: '1', body: 'New Transaction');
      when(mockRepository.postTransaction(transaction))
          .thenThrow(Exception('Failed to post transaction'));

      expect(() => postTransaction.call(transaction), throwsException);
    });
  });
}
